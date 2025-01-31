import 'package:challange_nextar/components/app_bar_component.dart';
import 'package:challange_nextar/components/botao_component.dart';
import 'package:challange_nextar/components/form_field_component.dart';
import 'package:challange_nextar/utils/colors.dart';
import 'package:challange_nextar/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MudarEmail extends StatefulWidget {
  const MudarEmail({
    super.key,
  });

  @override
  State<MudarEmail> createState() => _MudarEmailState();
}

class _MudarEmailState extends State<MudarEmail> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: const AppBarComponent(isTitulo: "Alterar email"),
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
                    AppImages.changeEmail,
                  ),
                ),
                const FormFieldComponent(
                  maxLength: 250,
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icon(
                    Icons.email,
                    color: AppColors.primary,
                  ),
                  labelText: "Email",
                  hintText: "Ex: nome@gmail.com ",
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
    return DefaultButton(
      borderRadius: BorderRadius.circular(10),
      nomeBotao: "Alterar email",
      cor: AppColors.corBotao,
      padding: const EdgeInsets.symmetric(horizontal: 123, vertical: 20),
      onPressed: () {},
    );
  }
}
