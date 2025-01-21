import 'package:flutter/material.dart';

mixin ValidacoesMixin {
  String? isNotEmpty(String? value, [BuildContext? context, String? message]) {
    if (value!.isEmpty) {
      return message ?? "Este Campo é obrigatório";
    }
    return null;
  }

  String? validaFormatoEmail(String? value,
      [BuildContext? context, String? message]) {
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value!)) {
      return 'Por favor, digite um e-mail válido.';
    }
    return null;
  }

  String? hasSixChars(String? value, [BuildContext? context, String? message]) {
    if (value!.length < 6) {
      return message ?? "Você deve usar pelo menos 6 caracteres.";
    }
    return null;
  }

  String? combine(List<String? Function()> validators) {
    for (final func in validators) {
      final validation = func();
      if (validation != null) return validation;
    }
    return null;
  }
}
