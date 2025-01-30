import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../models/home_model.dart';

class HomeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

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

  Future<void> saveSection(HomeModel section, int pos) async {
    final collection = _firestore.collection('home');

    if (section.id == null) {
      // Cria um novo documento no Firestore
      final docRef = await collection.add(section.toMap());
      section.id = docRef.id; // 🔹 Atualiza o ID no modelo
      await collection
          .doc(section.id)
          .update({'id': section.id}); // 🔹 Salva o ID no Firestore
    } else {
      // Atualiza o documento existente
      await collection
          .doc(section.id)
          .set(section.toMap(), SetOptions(merge: true));
    }
  }

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

  Future<void> deleteImage(String imageUrl) async {
    try {
      Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      print("Erro ao excluir imagem do Firebase Storage: $e");
    }
  }
}
