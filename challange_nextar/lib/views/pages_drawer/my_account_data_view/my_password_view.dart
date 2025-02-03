import 'package:challange_nextar/core/widgets/app_bar_widget.dart';
import 'package:challange_nextar/core/widgets/botao_widget.dart';
import 'package:challange_nextar/core/widgets/form_field_widget.dart';
import 'package:challange_nextar/core/theme/colors.dart';
import 'package:challange_nextar/core/theme/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: const AppBarWidget(
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
                const FormFieldWidget(
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
                const FormFieldWidget(
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
                const FormFieldWidget(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: AppColors.primary,
                  ),
                  labelText: "Confirmar nova senha",
                  hintText: "",
                ),
                const SizedBox(height: 25),
                _buildButton(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return DefaultButton(
      borderRadius: BorderRadius.circular(10),
      nomeBotao: "Alterar senha",
      cor: AppColors.corBotao,
      padding: const EdgeInsets.symmetric(horizontal: 123, vertical: 20),
      onPressed: () {},
    );
  }
}
