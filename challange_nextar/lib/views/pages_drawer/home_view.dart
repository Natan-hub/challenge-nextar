import 'package:challange_nextar/utils/colors.dart';
import 'package:challange_nextar/utils/images.dart';
import 'package:challange_nextar/viewmodels/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseView extends StatelessWidget {
  const BaseView({super.key});

  @override
  Widget build(BuildContext context) {
    // Acessa o LoginViewModel para obter os dados do usuário
    final loginViewModel = Provider.of<LoginViewModel>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Bem-vindo(a) a sua loja ${loginViewModel.dataUser?.name ?? 'Erro ao acessar o nome da conta'}",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
              const BannerCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class BannerCard extends StatelessWidget {
  const BannerCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 170, 255),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Imagem alinhada à esquerda
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Image.asset(
              AppImages.modeloRoupa, // Substitua pelo caminho da sua imagem
              fit: BoxFit.cover,
              width: 150, // Largura da imagem
              height: double.infinity,
            ),
          ),
          // Texto e botão alinhados à direita
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Escolha as melhores roupas para levar para sua casa.',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0, // Remove a sombra do botão
                    ),
                    child: const Text('Explore'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
