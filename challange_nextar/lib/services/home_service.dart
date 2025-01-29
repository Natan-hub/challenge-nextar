import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../models/home_model.dart';

class HomeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Stream<List<HomeModel>> listenToSections() {
    return _firestore.collection('home').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return HomeModel.fromFirestore(doc.data());
      }).toList();
    });
  }

  Future<void> saveSections(List<HomeModel> sections) async {
    final batch = _firestore.batch();
    final collection = _firestore.collection('home');

    for (var section in sections) {
      final docRef = collection.doc(section.name);
      batch.set(docRef, section.toMap(), SetOptions(merge: true));
    }

    await batch.commit();
  }

  Future<void> deleteSection(HomeModel section) async {
    await _firestore.collection('home').doc(section.name).delete();
  }

  Future<String> uploadImage(File file) async {
    try {
      String fileName = 'home/${const Uuid().v1()}.jpg'; // 🔹 Usa UUID para nome único
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
