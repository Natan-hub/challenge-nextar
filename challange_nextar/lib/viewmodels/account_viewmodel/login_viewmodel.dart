import 'package:challange_nextar/components/flush_bar_component.dart';
import 'package:challange_nextar/utils/colors.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final loginKey = GlobalKey<FormState>();

  bool isObscurePassword = true;
  bool isLoading = false;

  // Alterna a visibilidade da senha
  void obscurePassword() {
    isObscurePassword = !isObscurePassword;
    notifyListeners();
  }

  // Lógica de validação e login

  Future<void> login(BuildContext context) async {
    if (isLoading) return;

    isLoading = true;
    notifyListeners();

    try {
      if (loginKey.currentState!.validate()) {}
    } catch (exception) {
      FlushBarComponente.mostrar(
        context,
        'Ocorreu um erro durante o login. Por favor, tente novamente.',
        Icons.warning_amber,
        AppColors.vermelhoPadrao,
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
