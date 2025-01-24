import 'package:challange_nextar/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? currentUser;
  UserModel? dataUser;

  LoginService() {
    loadCurrentLogin();
  }

  // Faz login com email e senha
  Future<User?> signIn(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await loadCurrentLogin(firebaseAuth: result.user);
      // currentUser = result.user;
      return currentUser;
    } catch (e) {
      throw Exception('Erro ao realizar login: ${e.toString()}');
    }
  }

  // Carrega o usuário atual e seus dados
  Future<void> loadCurrentLogin({User? firebaseAuth}) async {
    currentUser = firebaseAuth ?? _auth.currentUser;
    if (currentUser != null) {
      final docSnapshot =
          await _firestore.collection('users').doc(currentUser!.uid).get();

      if (docSnapshot.exists) {
        // Mapeia os dados para o UserModel
        dataUser = UserModel.fromFirestore(docSnapshot.data()!);
      }
    }
  }

  // Faz logout do usuário
  Future<void> signOut() async {
    await _auth.signOut();
    currentUser = null;
    dataUser = null;
  }
}
