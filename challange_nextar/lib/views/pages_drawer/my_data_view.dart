import 'package:challange_nextar/components/app_bar_component.dart';
import 'package:challange_nextar/components/botao_component.dart';
import 'package:challange_nextar/components/form_field_component.dart';
import 'package:challange_nextar/utils/colors.dart';
import 'package:challange_nextar/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MeusDados extends StatelessWidget {
  const MeusDados({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          appBar: const AppBarComponente(
            isTitulo: "Modificar meus dados",
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 250,
                          height: 250,
                          child: SvgPicture.asset(
                            AppImages.profile,
                          ),
                        ),
                        const FormFieldComponent(
                          maxLength: 250,
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          textInputAction: TextInputAction.next,
                          prefixIcon: Icon(
                            Icons.account_circle,
                            color: AppColors.primary,
                          ),
                          labelText: "Nome",
                          hintText: "Ex: João",
                          obscureText: false,
                        ),
                        const SizedBox(height: 15),
                        const FormFieldComponent(
                          maxLength: 250,
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          textInputAction: TextInputAction.done,
                          prefixIcon: Icon(
                            Icons.phone,
                            color: AppColors.primary,
                          ),
                          labelText: "Contato",
                          hintText: "(54) 9 92220549",
                          keyboardType: TextInputType.phone,
                          obscureText: false,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  botaoAlterarDados(context),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          )),
    );
  }

  Widget botaoAlterarDados(BuildContext context) {
    return BotaoPadrao(
      borderRadius: BorderRadius.circular(10),
      nomeBotao: "Alterar dados",
      cor: AppColors.corBotao,
      padding: const EdgeInsets.symmetric(horizontal: 123, vertical: 20),
      onPressed: () {},
    );
  }
}
