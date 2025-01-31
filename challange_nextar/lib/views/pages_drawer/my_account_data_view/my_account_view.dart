import 'package:challange_nextar/components/flush_bar_component.dart';
import 'package:challange_nextar/components/native_dialog.dart';
import 'package:challange_nextar/routes/pages.dart';
import 'package:challange_nextar/utils/colors.dart';
import 'package:challange_nextar/utils/images.dart';
import 'package:challange_nextar/viewmodels/login_viewmodel.dart';
import 'package:challange_nextar/views/pages_drawer/my_account_data_view/my_data_view.dart';
import 'package:challange_nextar/views/pages_drawer/my_account_data_view/my_email_view.dart';
import 'package:challange_nextar/views/pages_drawer/my_account_data_view/my_password_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    // Atualize a variável 'orientation' apenas aqui.
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
          Card(
            color: AppColors.corBotao,
            // Define the shape of the card
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            // Define how the card's content should be clipped
            clipBehavior: Clip.antiAliasWithSaveLayer,
            // Define the child widget of the card
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
                    // Add padding around the row widget
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Add an image widget to display an image
                          ClipOval(
                            child: Image.asset(
                              AppImages.logoEmpresa,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Add some spacing between the image and the text
                          Container(width: 20),
                          // Add an expanded widget to take up the remaining horizontal space
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                // Add some spacing between the top of the card and the title
                                Container(height: 5),
                                // Add a title widget

                                Text(
                                  maxLines: 2,
                                  "Nextar",
                                  style: GoogleFonts.dmSans(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white),
                                ),

                                // Add some spacing between the title and the subtitle
                                Container(height: 5),
                                // Add a subtitle widget
                                Text(maxLines: 2, 'Super empresa'),
                                // Add some spacing between the subtitle and the text
                                Container(height: 10),
                                // Add a text widget to display some text
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
          )
        else
          Card(
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
              ),
            ),
          ),
        SettingsGroup(
          items: [
            SettingsItem(
              onTap: () {
                showCupertinoModalBottomSheet(
                  expand: false,
                  isDismissible: false,
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const MeusDados(),
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
                  builder: (context) => const MudarSenha(),
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
                  builder: (context) => const MudarEmail(),
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
          // +settingsGroupTitle: AppLocalizations.of(context).conta,
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
                      await logoffEmpresa(context, viewModelLogin);
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

  Future<void> logoffEmpresa(
      BuildContext context, LoginViewModel viewModelLogin) async {
    // Exibe o diálogo de carregamento
    showDialog(
      context: context,
      barrierDismissible: false, // Impede que o usuário feche o diálogo
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
      final resposta = await viewModelLogin.signOut();

      if (!context.mounted) return; // Evita exceção se o contexto for destruído

      Navigator.pop(context); // Fecha o diálogo de carregamento

      if (resposta != null) {
        Navigator.pushReplacementNamed(context, Routes.login);
      } else {
        FlushBarComponent.mostrar(
          context,
          "Erro ao sair da conta",
          Icons.warning_amber,
          AppColors.vermelhoPadrao,
        );
      }
    } catch (exception) {
      if (context.mounted) {
        Navigator.pop(context); // Fecha o diálogo de carregamento

        FlushBarComponent.mostrar(
          context,
          "Erro ao desconectar. Tente novamente.",
          Icons.warning_amber,
          AppColors.vermelhoPadrao,
        );
      }
    }
  }
}
