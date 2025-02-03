import 'package:challange_nextar/core/widgets/app_bar_widget.dart';
import 'package:challange_nextar/core/widgets/botao_widget.dart';
import 'package:challange_nextar/core/widgets/flush_bar_widget.dart';
import 'package:challange_nextar/core/widgets/form_field_widget.dart';
import 'package:challange_nextar/core/theme/colors.dart';
import 'package:challange_nextar/core/theme/images.dart';
import 'package:challange_nextar/core/theme/styles.dart';
import 'package:challange_nextar/utils/validators/validacoes_mixin.dart';
import 'package:challange_nextar/viewmodels/forgot_password_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => ForgotPasswordStateView();
}

class ForgotPasswordStateView extends State<ForgotPasswordView>
    with ValidacoesMixin {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final viewModel = context.watch<ForgotPasswordViewModel>();

    if (viewModel.successMessage != null) {
      Future.microtask(() {
        FlushBarWidget.mostrar(
          context,
          viewModel.successMessage!,
          Icons.check_circle_rounded,
          AppColors.verdePadrao,
        );
        Navigator.pop(context);
      });
    }

    if (viewModel.errorMessage != null) {
      Future.microtask(() {
        FlushBarWidget.mostrar(
          context,
          viewModel.errorMessage!,
          Icons.error_outline,
          AppColors.vermelhoPadrao,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModelForgotPaswword = context.watch<ForgotPasswordViewModel>();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        extendBodyBehindAppBar: true,
        appBar: const AppBarWidget(
          isTitulo: 'Recuperar senha',
          isVoltar: true,
        ),
        body: Form(
          key: viewModelForgotPaswword.formKey,
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
                  style: biggerTextStyle(),
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  'Por favor, informe o endereço de email associado à sua conta que enviaremos um link para o mesmo com as instruções para recuperação de senha.',
                  style: normalTextStyle(
                    Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                _buildEmailField(viewModelForgotPaswword),
                const SizedBox(
                  height: 25,
                ),
                _buildRecoverButton(viewModelForgotPaswword, context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField(ForgotPasswordViewModel viewModelForgotPaswword) {
    return FormFieldWidget(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      keyboardType: TextInputType.emailAddress,
      onFieldSubmitted: (value) =>
          viewModelForgotPaswword.sendResetPasswordEmail(),
      prefixIcon: const Icon(
        Icons.email,
        color: AppColors.primary,
      ),
      controller: viewModelForgotPaswword.emailController,
      labelText: 'Email',
      hintText: "",
      obscureText: false,
      validator: (text) => combine([
        () => isNotEmpty(text, context),
        () => validaFormatoEmail(text, context),
      ]),
    );
  }

  Widget _buildRecoverButton(
      ForgotPasswordViewModel viewModelForgotPaswword, BuildContext context) {
    return DefaultButton(
      borderRadius: BorderRadius.circular(10),
      nomeBotao: viewModelForgotPaswword.isLoading ? 'Enviando...' : 'Enviar',
      cor: AppColors.corBotao,
      padding: const EdgeInsets.fromLTRB(115, 20, 115, 20),
      onPressed: viewModelForgotPaswword.isLoading
          ? null
          : () {
              viewModelForgotPaswword.sendResetPasswordEmail();
            },
    );
  }
}
