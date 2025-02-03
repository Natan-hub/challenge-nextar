import 'package:challange_nextar/core/widgets/app_bar_widget.dart';
import 'package:challange_nextar/core/widgets/botao_widget.dart';
import 'package:challange_nextar/core/widgets/flush_bar_widget.dart';
import 'package:challange_nextar/core/widgets/form_field_widget.dart';
import 'package:challange_nextar/core/theme/colors.dart';
import 'package:challange_nextar/core/theme/images.dart';
import 'package:challange_nextar/core/theme/styles.dart';
import 'package:challange_nextar/routes/routes.dart';
import 'package:challange_nextar/utils/validators/validacoes_mixin.dart';
import 'package:challange_nextar/viewmodels/login_viewmodel.dart';
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
    final viewModelLogin = context.watch<LoginViewModel>();

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }
      },
      child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            extendBodyBehindAppBar: true,
            appBar: const AppBarWidget(
              isTitulo: 'Acessar sua conta',
            ),
            body: Form(
              key: viewModelLogin.loginKey,
              child: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
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
          )),
    );
  }

  Widget _buildEmailField(LoginViewModel viewModelLogin) {
    return FormFieldWidget(
      padding: EdgeInsets.zero,
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
    return FormFieldWidget(
      padding: EdgeInsets.zero,
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

  Widget _buildForgotPassword(BuildContext context) => Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            showCupertinoModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (_) => const ForgotPasswordView(),
            );
          },
          child: Text('Esqueceu a senha?',
              style: normalTextStyleDefault(AppColors.primary)),
        ),
      );

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
    return DefaultButton(
      borderRadius: BorderRadius.circular(10),
      cor: AppColors.corBotao,
      padding: const EdgeInsets.fromLTRB(115, 20, 115, 20),
      nomeBotao: 'Login',
      onPressed: viewModelLogin.isLoading
          ? null
          : () async {
              final mensagem = await viewModelLogin.login();
              if (mensagem != null) {
                FlushBarWidget.mostrar(
                  context,
                  mensagem,
                  mensagem == 'Acesso realizado com sucesso'
                      ? Icons.check_circle_rounded
                      : Icons.warning_amber,
                  mensagem == 'Acesso realizado com sucesso'
                      ? AppColors.verdePadrao
                      : AppColors.vermelhoPadrao,
                );

                if (mensagem == 'Acesso realizado com sucesso') {
                  Navigator.pushReplacementNamed(context, Routes.hiddenDrawer);
                }
              }
            },
      child: viewModelLogin.isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text('Login'),
    );
  }
}
