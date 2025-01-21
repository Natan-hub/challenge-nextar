import 'package:challange_nextar/components/app_bar_component.dart';
import 'package:challange_nextar/components/botao_component.dart';
import 'package:challange_nextar/components/flush_bar_component.dart';
import 'package:challange_nextar/components/form_field_component.dart';
import 'package:challange_nextar/utils/colors.dart';
import 'package:challange_nextar/utils/images.dart';
import 'package:challange_nextar/utils/styles.dart';
import 'package:challange_nextar/validators/validacoes_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => FforgotPasswordStateView();
}

class FforgotPasswordStateView extends State<ForgotPasswordView>
    with ValidacoesMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        extendBodyBehindAppBar: true,
        appBar: const AppBarComponente(
          isTitulo: 'Recuperar senha',
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: ListView(
              children: [
                SizedBox(
                  width: 180,
                  height: 180,
                  child: SvgPicture.asset(
                    AppImages.esqueciSenhaImagem,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                    textAlign: TextAlign.center,
                    'Esqueceu a senha?',
                    style: biggerTextStyle()),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  'Por favor, informe o endereço de email associado à sua conta que enviaremos um link para o mesmo com as instruções para recuperação de senha.',
                  style: normalTextStyle(Colors.black),
                ),
                const SizedBox(
                  height: 25,
                ),
                FormFieldComponent(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  keyboardType: TextInputType.emailAddress,
                  onFieldSubmitted: (value) => _onPressed(),
                  prefixIcon: const Icon(
                    Icons.email,
                    color: AppColors.primary,
                  ),
                  controller: emailController,
                  labelText: 'Email',
                  hintText: "",
                  obscureText: false,
                  validator: (text) => combine([
                    () => isNotEmpty(text, context),
                    () => validaFormatoEmail(text, context),
                  ]),
                ),
                const SizedBox(
                  height: 150,
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: botaoRecuperarSenha(context),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget botaoRecuperarSenha(BuildContext context) {
    return BotaoPadrao(
      borderRadius: BorderRadius.circular(10),
      nomeBotao: 'Recuperar senha',
      cor: AppColors.corBotao,
      padding: const EdgeInsets.fromLTRB(105, 20, 105, 20),
      onPressed: () {
        _onPressed();
      },
    );
  }

  _onPressed() async {
    if (formKey.currentState?.validate() == true) {
      Navigator.pop(context);
      FlushBarComponente.mostrar(
        context,
        'Email enviado',
        Icons.check_circle_rounded,
        AppColors.verdePadrao,
      );
    }
  }
}
