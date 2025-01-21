import 'package:challange_nextar/components/flush_bar_component.dart';
import 'package:challange_nextar/utils/colors.dart';
import 'package:flutter/material.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  bool isLoading = false;

  // Lógica para validar e enviar o email
  Future<void> sendResetPasswordEmail(BuildContext context) async {
    if (isLoading || formKey.currentState?.validate() != true) return;

    isLoading = true;
    notifyListeners();

    try {
      Navigator.pop(context);
      FlushBarComponente.mostrar(
        context,
        'Email enviado',
        Icons.check_circle_rounded,
        AppColors.verdePadrao,
      );
    } catch (error) {
      FlushBarComponente.mostrar(
        context,
        'Erro ao enviar o email. Tente novamente.',
        Icons.check_circle_rounded,
        AppColors.verdePadrao,
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
