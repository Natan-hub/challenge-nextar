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

  String? isNotEmptyImage(List<dynamic>? value,
      [BuildContext? context, String? message]) {
    if (value!.isEmpty) {
      return message ?? "Insira ao menos uma imagem";
    }
    return null;
  }

  String? hasSixCharsTitleProduct(String? value,
      [BuildContext? context, String? message]) {
    if (value!.length < 6) {
      return message ?? "Título muito curto.";
    }
    return null;
  }

  String? isNotZero(String? value, [BuildContext? context, String? message]) {
    // Tenta converter o valor para número
    final num? parsedValue = num.tryParse(value ?? '');

    if (parsedValue == null || parsedValue <= 0) {
      return message ?? "O valor deve ser maior que zero";
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
