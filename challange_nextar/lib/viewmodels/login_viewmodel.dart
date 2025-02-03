import 'package:challange_nextar/models/login_model.dart';
import 'package:challange_nextar/models/user_model.dart';
import 'package:challange_nextar/services/login_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final loginKey = GlobalKey<FormState>();

  final LoginService _loginService = LoginService();

  bool isObscurePassword = true;
  bool isLoading = false;

  User? currentUser;
  UserModel? dataUser;

  LoginViewModel() {
    loadCurrentUser();
  }

  // Alterna a visibilidade da senha
  void obscurePassword() {
    isObscurePassword = !isObscurePassword;
    notifyListeners();
  }

  // Carrega o usuário atual e seus dados
  Future<void> loadCurrentUser() async {
    await _loginService.loadCurrentLogin();
    currentUser = _loginService.currentUser;
    dataUser = _loginService.dataUser;
    notifyListeners();
  }

  // Lógica de validação e login
  Future<String?> login() async {
    if (isLoading) return null;

    isLoading = true;
    notifyListeners();

    try {
      if (loginKey.currentState!.validate()) {
        final user = LoginModel(
          email: usernameController.text.trim(),
          password: passwordController.text,
        );

        final loggedUser = await _loginService.signIn(
          user.email,
          user.password,
        );

        if (loggedUser != null) {
          currentUser = loggedUser;
          dataUser = _loginService.dataUser;
          notifyListeners();
          return 'Acesso realizado com sucesso';
        }
      }
    } catch (e) {
      String errorMessage = e.toString();

      if (errorMessage.contains(
          'The password is invalid or the user does not have a password')) {
        return 'Email ou senha inválidos.';
      } else if (errorMessage.contains('There is no user record')) {
        return 'Esse email não possui uma conta';
      } else {
        return 'Erro desconhecido: $errorMessage';
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return null;
  }

  // Faz logout do usuário
  Future<bool> signOut() async {
    try {
      await _loginService.signOut();
      currentUser = null;
      dataUser = null;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
