import 'package:challange_nextar/core/widgets/app_bar_widget.dart';
import 'package:challange_nextar/core/widgets/botao_widget.dart';
import 'package:challange_nextar/core/widgets/form_field_widget.dart';
import 'package:challange_nextar/core/theme/colors.dart';
import 'package:challange_nextar/core/theme/images.dart';
import 'package:challange_nextar/viewmodels/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ChangeEmailView extends StatefulWidget {
  const ChangeEmailView({
    super.key,
  });

  @override
  State<ChangeEmailView> createState() => _ChangeEmailViewState();
}

class _ChangeEmailViewState extends State<ChangeEmailView> {
  @override
  Widget build(BuildContext context) {
    final loginViewModel = context.watch<LoginViewModel>();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: const AppBarWidget(isTitulo: "Alterar email"),
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
                FormFieldWidget(
                  maxLength: 250,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(
                    Icons.email,
                    color: AppColors.primary,
                  ),
                  labelText: "Email",
                  hintText: "Ex: nome@gmail.com ",
                  initialValue: loginViewModel.dataUser!.email,
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
      nomeBotao: "Alterar email",
      cor: AppColors.corBotao,
      padding: const EdgeInsets.symmetric(horizontal: 123, vertical: 20),
      onPressed: () {},
    );
  }
}
