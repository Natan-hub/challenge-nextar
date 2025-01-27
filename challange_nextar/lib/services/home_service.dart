import 'package:challange_nextar/models/home_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Escuta alterações em tempo real no Firestore
  // Retorna um Stream de HomeModel
  Stream<List<HomeModel>> listenToSections() {
    return _firestore.collection('home').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return HomeModel.fromFirestore(doc.data());
      }).toList();
    });
  }
}
