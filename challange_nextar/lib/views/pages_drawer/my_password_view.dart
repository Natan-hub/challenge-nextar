import 'package:challange_nextar/components/app_bar_component.dart';
import 'package:challange_nextar/components/botao_component.dart';
import 'package:challange_nextar/components/form_field_component.dart';
import 'package:challange_nextar/utils/colors.dart';
import 'package:challange_nextar/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MudarSenha extends StatelessWidget {
  const MudarSenha({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: const AppBarComponente(
          isTitulo: "Privacidade",
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  height: 250,
                  child: SvgPicture.asset(
                    AppImages.esqueciSenhaImagem,
                  ),
                ),
                const FormFieldComponent(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icon(
                    Icons.lock,
                    color: AppColors.primary,
                  ),
                  labelText: "Senha atual",
                  hintText: "",
                ),
                const SizedBox(height: 10),
                const FormFieldComponent(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icon(
                    Icons.lock,
                    color: AppColors.primary,
                  ),
                  labelText: "Nova senha",
                  hintText: "",
                ),
                const SizedBox(height: 10),
                const FormFieldComponent(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: AppColors.primary,
                  ),
                  labelText: "Confirmar nova senha",
                  hintText: "",
                ),
                const SizedBox(height: 25),
                botaoAlterarDados(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget botaoAlterarDados(BuildContext context) {
    return BotaoPadrao(
      borderRadius: BorderRadius.circular(10),
      nomeBotao: "Alterar senha",
      cor: AppColors.corBotao,
      padding: const EdgeInsets.symmetric(horizontal: 123, vertical: 20),
      onPressed: () {},
    );
  }
}
