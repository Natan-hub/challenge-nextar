import 'package:challange_nextar/core/theme/colors.dart';
import 'package:challange_nextar/core/theme/images.dart';
import 'package:challange_nextar/core/theme/styles.dart';
import 'package:challange_nextar/core/widgets/flush_bar_widget.dart';
import 'package:challange_nextar/viewmodels/home_viewmodel.dart';
import 'package:challange_nextar/viewmodels/login_viewmodel.dart';
import 'package:challange_nextar/viewmodels/products_viewmodel.dart';
import 'package:challange_nextar/views/pages_drawer/home_view/section_view.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ImagePicker picker = ImagePicker();

  @override
void initState() {
  super.initState();

  // Garante que os produtos sejam carregados ao entrar na tela
  Future.microtask(() {
    final productViewModel = context.read<ProductViewModel>();
    if (productViewModel.products.isEmpty) {
      productViewModel.loadInitialProducts();
    }
  });
}


  @override
  Widget build(BuildContext context) {
    final loginViewModel = context.watch<LoginViewModel>();

    return PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) async {
          if (didPop) {
            return;
          }
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Bem-vindo(a) a sua loja ${loginViewModel.dataUser?.name ?? 'Usuário'}",
                    style: highlightedText(
                      Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  bannerCard(context),
                  const SizedBox(height: 20),
                  Consumer<HomeViewModel>(
                    builder: (_, homeManager, __) {
                      if (homeManager.isUploading) {
                        Future.microtask(() => _buildLoadingImage(context));
                      }
                      final List<Widget> children =
                          homeManager.sections.map<Widget>((section) {
                        return SectionWidget(
                          homeManager: homeManager,
                          section: section,
                        );
                      }).toList();

                      if (homeManager.editing) {
                        children.add(addSectionWidget(homeManager));
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: children,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: Consumer<HomeViewModel>(
            builder: (context, homeManager, __) {
              if (homeManager.error != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  FlushBarWidget.mostrar(
                    context,
                    homeManager.error!,
                    Icons.error_outline,
                    AppColors.vermelhoPadrao,
                  );
                  homeManager.error = null;
                });
              }

              return FloatingActionButton(
                backgroundColor: AppColors.primary2,
                onPressed:
                    homeManager.editing ? null : homeManager.enterEditing,
                child: homeManager.editing
                    ? PopupMenuButton<String>(
                        onSelected: (e) => e == 'Salvar'
                            ? homeManager.saveEditing()
                            : homeManager.discardEditing(),
                        itemBuilder: (_) => ['Salvar', 'Descartar']
                            .map(
                              (e) => PopupMenuItem(
                                value: e,
                                child: Text(e),
                              ),
                            )
                            .toList(),
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )
                    : const Icon(Icons.edit_rounded),
              );
            },
          ),
        ));
  }

  Widget bannerCard(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 170, 255),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Image.asset(
              AppImages.modeloRoupa,
              fit: BoxFit.cover,
              width: 150,
              height: double.infinity,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'A roupa ideal feita pra você',
                    style: highlightedText(Colors.white),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Explorar',
                      style: normalTextStyleDefault(Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget addSectionWidget(HomeViewModel homeManager) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextButton(
            onPressed: () {
              homeManager.addSection(
                'List',
              );
            },
            child: Text(
              'Adicionar Lista',
              style: normalTextStyleBold(
                AppColors.primary2,
              ),
            ),
          ),
        ),
        Expanded(
          child: TextButton(
            onPressed: () {
              homeManager.addSection(
                'Staggered',
              );
            },
            child: Text(
              'Adicionar Grade',
              style: normalTextStyleBold(
                AppColors.primary2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _buildLoadingImage(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("Adicionando imagem"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(strokeWidth: 2),
            ],
          ),
        );
      },
    );
  }
}
