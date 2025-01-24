import 'package:challange_nextar/components/flush_bar_component.dart';
import 'package:challange_nextar/models/login_model.dart';
import 'package:challange_nextar/models/user_model.dart';
import 'package:challange_nextar/services/login_service.dart';
import 'package:challange_nextar/utils/colors.dart';
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
    _loadCurrentUser();
  }

  // Alterna a visibilidade da senha
  void obscurePassword() {
    isObscurePassword = !isObscurePassword;
    notifyListeners();
  }

  // Carrega o usuário atual e seus dados
  Future<void> _loadCurrentUser() async {
    await _loginService.loadCurrentLogin();
    currentUser = _loginService.currentUser;
    dataUser = _loginService.dataUser;
    notifyListeners();
  }

  // Lógica de validação e login
  Future<void> login(BuildContext context) async {
    if (isLoading) return;

    isLoading = true;
    notifyListeners();

    try {
      if (loginKey.currentState!.validate()) {
        // Criando um objeto UserModel para validação
        final user = LoginModel(
          email: usernameController.text.trim(),
          password: passwordController.text,
        );

        // Realiza login com o AuthService
        final loggedUser = await _loginService.signIn(
          user.email,
          user.password,
        );

        if (loggedUser != null) {
          print("AQUII: ${loggedUser.uid}");
        }
      }
    } catch (e) {
      String errorMessage = e.toString();
      String mensagem;

      if (errorMessage.contains(
          'The password is invalid or the user does not have a password')) {
        mensagem = 'Email ou senha inválidos.';
      } else if (errorMessage.contains('There is no user record')) {
        mensagem = 'Esse email não possui uma conta';
      } else {
        mensagem = 'Erro desconhecido: $errorMessage';
      }

      FlushBarComponente.mostrar(
        context,
        mensagem,
        Icons.warning_amber,
        AppColors.vermelhoPadrao,
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Faz logout do usuário
  Future<void> signOut() async {
    await _loginService.signOut();
    currentUser = null;
    dataUser = null;
    notifyListeners();
  }
}
