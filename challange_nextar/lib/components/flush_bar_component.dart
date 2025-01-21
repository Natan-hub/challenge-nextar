import 'package:awesome_top_snackbar/awesome_top_snackbar.dart';
import 'package:flutter/material.dart';

class FlushBarComponente {
  static mostrar(
      context, String mensagem, IconData nomeIcone, Color corBackground,
      {Color letraColor = Colors.white}) {
    awesomeTopSnackbar(
      context,
      mensagem,
      backgroundColor: corBackground,
      icon: Icon(
        nomeIcone,
        color: letraColor,
        size: 30,
      ),
    );
  }
}
