import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../models/home_model.dart';

class HomeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// 📌 Escuta as seções no Firestore e retorna um stream de `HomeModel`.
  Stream<List<HomeModel>> listenToSections() {
    return _firestore
        .collection('home')
        .orderBy('pos')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return HomeModel.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  /// 📌 Salva ou atualiza uma seção no Firestore.
  Future<void> saveSection(HomeModel section, int pos) async {
    final collection = _firestore.collection('home');

    if (section.id == null) {
      final docRef = await collection.add(section.toMap());
      section.id = docRef.id; 
      await collection
          .doc(section.id)
          .update({'id': section.id}); 
    } else {
      await collection
          .doc(section.id)
          .set(section.toMap(), SetOptions(merge: true));
    }
  }

  /// 📌 Remove uma seção do Firestore e suas imagens associadas no Storage.
  Future<void> deleteSection(HomeModel section) async {
    if (section.id != null) {
      await _firestore.collection('home').doc(section.id).delete();

      // 🔹 Deleta todas as imagens do Storage associadas à seção
      for (final item in section.items) {
        if (item.image is String) {
          await deleteImage(item.image as String);
        }
      }
    }
  }

  /// 📌Faz upload de uma imagem para o Firebase Storage e retorna sua URL.
  Future<String> uploadImage(File file) async {
    try {
      String fileName =
          'home/${const Uuid().v1()}.jpg'; // 🔹 Usa UUID para nome único
      Reference ref = _storage.ref().child(fileName);
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception("Erro ao fazer upload da imagem: $e");
    }
  }

  /// 📌Remove uma imagem do Firebase Storage.
  Future<void> deleteImage(String imageUrl) async {
    try {
      Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      print("Erro ao excluir imagem do Firebase Storage: $e");
    }
  }
}
