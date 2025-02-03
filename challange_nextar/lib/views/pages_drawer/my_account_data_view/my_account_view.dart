import 'package:challange_nextar/core/widgets/flush_bar_widget.dart';
import 'package:challange_nextar/core/widgets/native_dialog_widget.dart';
import 'package:challange_nextar/routes/routes.dart';
import 'package:challange_nextar/core/theme/colors.dart';
import 'package:challange_nextar/core/theme/images.dart';
import 'package:challange_nextar/core/theme/styles.dart';
import 'package:challange_nextar/viewmodels/login_viewmodel.dart';
import 'package:challange_nextar/views/pages_drawer/my_account_data_view/my_data_view.dart';
import 'package:challange_nextar/views/pages_drawer/my_account_data_view/my_email_view.dart';
import 'package:challange_nextar/views/pages_drawer/my_account_data_view/my_password_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:provider/provider.dart';

class MyAccountView extends StatefulWidget {
  const MyAccountView({super.key});

  @override
  State<MyAccountView> createState() => _MyAccountViewState();
}

class _MyAccountViewState extends State<MyAccountView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: SafeArea(
          child: ConfigAccount(),
        ),
      ),
    );
  }
}

class ConfigAccount extends StatefulWidget {
  const ConfigAccount({
    super.key,
  });

  @override
  State<ConfigAccount> createState() => _ConfigAccountState();
}

class _ConfigAccountState extends State<ConfigAccount> {
  late Orientation orientation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    orientation = MediaQuery.of(context).orientation;
  }

  @override
  Widget build(BuildContext context) {
    final viewModelLogin = Provider.of<LoginViewModel>(context);
    orientation = MediaQuery.of(context).orientation;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (orientation == Orientation.portrait)
          _buildPrincipalCard()
        else
          _buildCardHorizontal(),
        SettingsGroup(
          items: [
            SettingsItem(
              onTap: () {
                showCupertinoModalBottomSheet(
                  expand: false,
                  isDismissible: false,
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const MyDataView(),
                );
              },
              icons: CupertinoIcons.pencil_outline,
              iconStyle: IconStyle(
                iconsColor: Colors.white,
                withBackground: true,
                backgroundColor: AppColors.primary,
              ),
              title: "Meus dados",
              subtitle: 'Nome e telefone',
              titleMaxLine: 1,
              subtitleMaxLine: 1,
            ),
            SettingsItem(
              onTap: () {
                showCupertinoModalBottomSheet(
                  expand: false,
                  isDismissible: false,
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const ChangePasswordView(),
                );
              },
              icons: Icons.password,
              iconStyle: IconStyle(
                iconsColor: Colors.white,
                withBackground: true,
                backgroundColor: AppColors.primary,
              ),
              title: "Privacidade",
              subtitle: "Alterar senha",
            ),
            SettingsItem(
              onTap: () {
                showCupertinoModalBottomSheet(
                  expand: false,
                  isDismissible: false,
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const ChangeEmailView(),
                );
              },
              icons: CupertinoIcons.repeat,
              iconStyle: IconStyle(
                iconsColor: Colors.white,
                withBackground: true,
                backgroundColor: AppColors.primary,
              ),
              title: "Endereço de email",
            ),
          ],
        ),
        SettingsGroup(
          items: [
            SettingsItem(
              onTap: () {
                NativeDialog.showConfirmation(
                    context: context,
                    title: "Sair da conta?",
                    message: '',
                    confirmButtonText: "Sim",
                    cancelButtonText: "Cancelar",
                    onConfirm: () async {
                      await logoff(context, viewModelLogin);
                    });
              },
              icons: Icons.exit_to_app_rounded,
              title: "Sair da conta",
            ),
          ],
        ),
      ],
    );
  }

  ///📌 Esse card foi construido acessando o código do package que estou usando o babstrap_settings_screen
  ///e copiando ele, pois queria usufrir do design mas queria mudar o jeito que é utilizado a imagem de perfil
  ///já que o padrão do package não consigo manipular ela muito bem, então essa foi a solução que encontrei

  Widget _buildPrincipalCard() {
    return Card(
      color: AppColors.corBotao,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: CircleAvatar(
              radius: 65,
              backgroundColor: Colors.white.withOpacity(.2),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: CircleAvatar(
              radius: 65,
              backgroundColor: Colors.white.withOpacity(.09),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: CircleAvatar(
              radius: 65,
              backgroundColor: Colors.white.withOpacity(.05),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipOval(
                      child: Image.asset(
                        AppImages.logoEmpresa,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(height: 5),
                          Text(
                              maxLines: 2,
                              "Nextar",
                              style: highlightedText(Colors.white)),
                          Container(height: 5),
                          Text(
                            maxLines: 2,
                            'A empresa de maior refêrencia no Brasil',
                            style: normalTextStyleDefault(
                              Colors.white,
                            ),
                          ),
                          Container(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///📌 Quando colocamos a tela vertical de lado o card acaba ocupando um espaço maior que o necessário
  ///pensando nisso adaptei a tela para mostrar um card mais simples com a tela horizontal onde o usuário consiga
  ///ter visualização boa da tela e escolhi essa forma para demonstrar meu conhecimento de orientação
  Widget _buildCardHorizontal() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      child: ListTile(
        leading: Container(
            clipBehavior: Clip.hardEdge,
            width: 40,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: Image.asset(
              AppImages.logoEmpresa,
            )),
        title: Text(
          "Nextar",
          style: highlightedText(Colors.black),
        ),
      ),
    );
  }

  Future<void> logoff(
      BuildContext context, LoginViewModel viewModelLogin) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("Desconectando..."),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(strokeWidth: 2),
            ],
          ),
        );
      },
    );

    try {
      final response = await viewModelLogin.signOut();

      if (!context.mounted) return;

      Navigator.pop(context);
      if (response) {
        Navigator.pushReplacementNamed(context, Routes.login);
      } else {
        FlushBarWidget.mostrar(
          context,
          "Erro ao sair da conta",
          Icons.warning_amber,
          AppColors.vermelhoPadrao,
        );
      }
    } catch (exception) {
      if (context.mounted) {
        Navigator.pop(context);

        FlushBarWidget.mostrar(
          context,
          "Erro ao desconectar. Tente novamente.",
          Icons.warning_amber,
          AppColors.vermelhoPadrao,
        );
      }
    }
  }
}
