import 'package:challange_nextar/components/app_bar_component.dart';
import 'package:challange_nextar/components/botao_component.dart';
import 'package:challange_nextar/components/form_field_component.dart';
import 'package:challange_nextar/utils/colors.dart';
import 'package:challange_nextar/utils/images.dart';
import 'package:challange_nextar/utils/styles.dart';
import 'package:challange_nextar/validators/validacoes_mixin.dart';
import 'package:challange_nextar/viewmodels/account_viewmodel/login_viewmodel.dart';
import 'package:challange_nextar/views/account/forgot_password_view.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({
    super.key,
  });

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with ValidacoesMixin {
  @override
  Widget build(BuildContext context) {
    final viewModelLogin = Provider.of<LoginViewModel>(context);

    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          extendBodyBehindAppBar: true,
          appBar: const AppBarComponente(
            isTitulo: 'Login',
          ),
          body: Form(
            key: viewModelLogin.loginKey,
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        height: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            AppImages.logoEmpresa,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Text(
                        'Realize o login para acessar a loja.',
                        style: normalTextStyle(
                          AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 25),
                      _buildEmailField(viewModelLogin),
                      const SizedBox(height: 10),
                      _buildPasswordField(viewModelLogin),
                      const SizedBox(height: 10),
                      _buildForgotPassword(context),
                      const SizedBox(height: 25),
                      _buildLoginButton(viewModelLogin),
                      const SizedBox(height: 25),
                      _buildSignUp(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Widget _buildEmailField(LoginViewModel viewModelLogin) {
    return FormFieldComponent(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      prefixIcon: const Icon(
        Icons.email,
        color: AppColors.primary,
      ),
      controller: viewModelLogin.usernameController,
      labelText: 'Email',
      hintText: 'Ex: user@gmail.com',
      validator: (text) => combine([
        () => isNotEmpty(text, context),
        () => validaFormatoEmail(text, context),
      ]),
    );
  }

  Widget _buildPasswordField(LoginViewModel viewModelLogin) {
    return FormFieldComponent(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      textInputAction: TextInputAction.done,
      prefixIcon: const Icon(
        Icons.lock_rounded,
        color: AppColors.primary,
      ),
      suffixIcon: IconButton(
        icon: Icon(
          viewModelLogin.isObscurePassword
              ? Icons.visibility_off
              : Icons.visibility,
          color: Colors.grey,
        ),
        onPressed: viewModelLogin.obscurePassword,
      ),
      controller: viewModelLogin.passwordController,
      labelText: 'Senha',
      hintText: '',
      obscureText: viewModelLogin.isObscurePassword,
      validator: (text) => combine([
        () => isNotEmpty(text, context),
        () => hasSixChars(text, context),
      ]),
    );
  }

  Padding _buildForgotPassword(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              showCupertinoModalBottomSheet(
                isDismissible: false,
                enableDrag: false,
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => const ForgotPasswordView(),
              );
            },
            child: Text(
              'Esqueceu a senha?',
              style: normalTextStyleDefault(
                AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUp() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Ainda não tem conta?",
        ),
        const SizedBox(
          width: 4,
        ),
        InkWell(
          onTap: () {},
          child: Text(
            "Crie uma",
            style: normalTextStyleBold(
              AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(LoginViewModel viewModelLogin) {
    return BotaoPadrao(
      borderRadius: BorderRadius.circular(10),
      cor: AppColors.corBotao,
      padding: const EdgeInsets.fromLTRB(115, 20, 115, 20),
      nomeBotao: 'Login',
      onPressed:
          viewModelLogin.isLoading ? null : () => viewModelLogin.login(context),
      child: viewModelLogin.isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text('Login'),
    );
  }
}
