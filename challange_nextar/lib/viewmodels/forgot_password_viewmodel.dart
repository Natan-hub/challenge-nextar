import 'package:flutter/material.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  bool isLoading = false;
  String? successMessage;
  String? errorMessage;

  /// Envia o email de recuperação de senha
  Future<void> sendResetPasswordEmail() async {
    if (isLoading || formKey.currentState?.validate() != true) return;

    isLoading = true;
    successMessage = null;
    errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));
      clearFields();
      successMessage = 'Email enviado com sucesso';
    } catch (error) {
      errorMessage = 'Erro ao enviar o email. Tente novamente.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearFields() {
    emailController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
