import 'package:challange_nextar/core/widgets/app_bar_widget.dart';
import 'package:challange_nextar/core/widgets/botao_widget.dart';
import 'package:challange_nextar/core/widgets/form_field_widget.dart';
import 'package:challange_nextar/core/theme/colors.dart';
import 'package:challange_nextar/core/theme/images.dart';
import 'package:challange_nextar/viewmodels/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class MyDataView extends StatelessWidget {
  const MyDataView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final viewModelLogin = context.watch<LoginViewModel>();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          appBar: const AppBarWidget(
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
                        FormFieldWidget(
                          maxLength: 250,
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          textInputAction: TextInputAction.next,
                          prefixIcon: const Icon(
                            Icons.account_circle,
                            color: AppColors.primary,
                          ),
                          labelText: "Nome",
                          hintText: "Ex: João",
                          obscureText: false,
                          initialValue: viewModelLogin.dataUser!.name,
                        ),
                        const SizedBox(height: 15),
                        const FormFieldWidget(
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
                  _buildButton(context),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          )),
    );
  }

  Widget _buildButton(BuildContext context) {
    return DefaultButton(
      borderRadius: BorderRadius.circular(10),
      nomeBotao: "Alterar dados",
      cor: AppColors.corBotao,
      padding: const EdgeInsets.symmetric(horizontal: 123, vertical: 20),
      onPressed: () {},
    );
  }
}
