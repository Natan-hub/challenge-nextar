import 'dart:io';

import 'package:challange_nextar/components/form_field_component.dart';
import 'package:challange_nextar/models/home_model.dart';
import 'package:challange_nextar/models/product_model.dart';
import 'package:challange_nextar/routes/pages.dart';
import 'package:challange_nextar/utils/colors.dart';
import 'package:challange_nextar/utils/images.dart';
import 'package:challange_nextar/viewmodels/home_viewmodel.dart';
import 'package:challange_nextar/viewmodels/login_viewmodel.dart';
import 'package:challange_nextar/viewmodels/products_viewmodel.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseView extends StatelessWidget {
  BaseView({super.key});

  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    // Acessa o LoginViewModel para obter os dados do usuário
    final loginViewModel = Provider.of<LoginViewModel>(context);

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
                  "Bem-vindo(a) a sua loja ${loginViewModel.dataUser?.name ?? 'Erro ao acessar o nome da conta'}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 20),
                bannerCard(context),
                Consumer<HomeViewModel>(
                  builder: (_, homeManager, __) {
                    final List<Widget> children =
                        homeManager.sections.map<Widget>((section) {
                      switch (section.type) {
                        case 'List':
                          return sectionList(context, section, homeManager);
                        case 'Staggered':
                          return sectionStaggered(
                              context, section, homeManager);
                        default:
                          return Container();
                      }
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
          builder: (_, homeManager, __) {
            if (homeManager.loading) {
              return Container(); // 🔹 Esconde o botão enquanto está carregando
            }
            return homeManager.editing
                ? FloatingActionButton(
                    backgroundColor: AppColors.primary2,
                    shape: const CircleBorder(),
                    onPressed: null,
                    child: PopupMenuButton<String>(
                      onSelected: (e) {
                        if (e == 'Salvar') {
                          homeManager.saveEditing();
                        } else {
                          homeManager.discardEditing();
                        }
                      },
                      itemBuilder: (_) => ['Salvar', 'Descartar']
                          .map((e) => PopupMenuItem(value: e, child: Text(e)))
                          .toList(),
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  )
                : FloatingActionButton(
                    onPressed: homeManager.enterEditing,
                    backgroundColor: AppColors.primary2,
                    child: const Icon(Icons.edit_rounded),
                  );
          },
        ),
      ),
    );
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
          // Imagem alinhada à esquerda
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Image.asset(
              AppImages.modeloRoupa, // Substitua pelo caminho da sua imagem
              fit: BoxFit.cover,
              width: 150, // Largura da imagem
              height: double.infinity,
            ),
          ),
          // Texto e botão alinhados à direita
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Escolha as melhores roupas para levar para sua casa.',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
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
                      elevation: 0, // Remove a sombra do botão
                    ),
                    child: const Text('Explore'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionList(BuildContext context, HomeModel section, homeManager) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          titleSection(context, section, homeManager),
          SizedBox(
            height: 150,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) {
                void onImageSelected(
                    File file, BuildContext context, HomeModel section) {
                  context.read<HomeViewModel>().addItemToSection(section, file);
                  Navigator.of(context).pop();
                }

                // Se for um índice válido, define a variável item
                final bool isLastItem = index >= section.items.length;
                final HomeItem? item = isLastItem ? null : section.items[index];

                // Se for o último item, retorna o botão de adicionar imagem
                if (isLastItem) {
                  return AspectRatio(
                    aspectRatio: 1,
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => imageSourceSheet(
                            context,
                            (file) => onImageSelected(file, context, section),
                          ),
                        );
                      },
                      child: Container(
                        color: Colors.grey.shade100,
                        child: const Icon(Icons.add, color: Colors.black),
                      ),
                    ),
                  );
                }

                // Se for um item válido, permite a exclusão ao pressionar longamente
                return AspectRatio(
                  aspectRatio: 1,
                  child: InkWell(
                    onTap: () {
                      if (item.product != null) {
                        final product = context
                            .read<ProductViewModel>()
                            .findProductById(item.product!);
                        if (product != null) {
                          Navigator.pushNamed(
                            context,
                            Routes.detailsProduct,
                            arguments: {'product': product},
                          );
                        }
                      }
                    },
                    onLongPress: homeManager.editing && item != null
                        ? () {
                            showDialog(
                              context: context,
                              builder: (_) {
                                final productId =
                                    item.product?.isNotEmpty == true
                                        ? item.product
                                        : null;
                                final product = productId != null
                                    ? context
                                        .read<ProductViewModel>()
                                        .findProductById(productId)
                                    : null;

                                return AlertDialog(
                                  title: const Text('Editar Item'),
                                  content: product != null
                                      ? ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          leading: Image.network(
                                              product.images.first),
                                          title: Text(product.name),
                                          subtitle:
                                              Text("R\$ ${product.price}"),
                                        )
                                      : const Text("Nenhum produto vinculado."),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        context
                                            .read<HomeViewModel>()
                                            .removeItem(section, item);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Excluir'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        if (product != null) {
                                          // 🔹 Desvincula o produto corretamente
                                          final newItem =
                                              item.copyWith(product: null);
                                          context
                                              .read<HomeViewModel>()
                                              .updateItem(section, newItem);
                                        } else {
                                          // 🔹 Abre a tela para selecionar um produto
                                          final selectedProduct =
                                              await Navigator.of(context)
                                                  .pushNamed(
                                            Routes.selectedProduct,
                                          ) as ProductModel?;

                                          if (selectedProduct != null) {
                                            final newItem = item.copyWith(
                                                product: selectedProduct.id);
                                            context
                                                .read<HomeViewModel>()
                                                .updateItem(section, newItem);
                                          }
                                        }
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        product != null
                                            ? "Desvincular"
                                            : "Vincular",
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        : null,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: FadeInImage.memoryNetwork(
                          image: item!.image, // Garantimos que item não é nulo
                          fit: BoxFit.cover,
                          placeholder: kTransparentImage,
                          imageErrorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 50,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 4),
              itemCount: homeManager.editing
                  ? section.items.length + 1
                  : section.items.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionStaggered(
      BuildContext context, HomeModel section, homeManager) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          titleSection(context, section, homeManager),
          GridView.custom(
            padding: const EdgeInsets.all(8),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverQuiltedGridDelegate(
              crossAxisCount: 4, // Quantidade de colunas
              mainAxisSpacing: 4, // Espaço entre linhas
              crossAxisSpacing: 4, // Espaço entre colunas
              pattern: const [
                QuiltedGridTile(2, 2),
                QuiltedGridTile(1, 2),
                QuiltedGridTile(1, 1),
                QuiltedGridTile(1, 1),
                QuiltedGridTile(2, 4),
              ],
            ),
            childrenDelegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index >= section.items.length) return null;
                final item = section.items[index];
                return InkWell(
                  onTap: () {
                    if (item.product != null) {
                      final product = context
                          .read<ProductViewModel>()
                          .findProductById(item.product!);
                      if (product != null) {
                        Navigator.of(context).pushNamed(
                          Routes.detailsProduct,
                          arguments: {
                            'product': product,
                          },
                        );
                      }
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: FadeInImage.memoryNetwork(
                        image: item
                            .image, // Acesse o campo 'image' do objeto HomeItem
                        fit: BoxFit.cover,
                        placeholder: kTransparentImage,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
              childCount: section.items.length,
            ),
          ),
        ],
      ),
    );
  }

  titleSection(context, section, homeManager) {
    if (homeManager.editing) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: <Widget>[
              Expanded(
                child: FormFieldComponent(
                  initialValue: section.name,
                  onChanged: (text) {
                    section.name = text;
                    homeManager.notifyListeners();
                  },
                  labelText: 'Título',
                  hintText: '',
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_rounded),
                color: AppColors.vermelhoPadrao,
                onPressed: () {
                  homeManager.removeSection(section);
                },
              ),
            ],
          ),
          if (section.error != null)
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 4),
              child: Text(
                section.error!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      );
    } else {
      return Text(
        section.name ?? "Erro ao retornar texto",
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w800,
          fontSize: 18,
        ),
      );
    }
  }

  Widget addSectionWidget(HomeViewModel homeManager) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextButton(
            onPressed: () {
              int newPos = homeManager.sections.isNotEmpty
                  ? homeManager.sections.last.pos + 1
                  : 0; // Se não houver seções, começa do 0

              homeManager.addSection(
                HomeModel(
                    name: 'Nova Seção', type: 'List', items: [], pos: newPos),
              );
            },
            child: const Text('Adicionar Lista'),
          ),
        ),
        Expanded(
          child: TextButton(
            onPressed: () {
              int newPos = homeManager.sections.isNotEmpty
                  ? homeManager.sections.last.pos + 1
                  : 0;

              homeManager.addSection(
                HomeModel(
                    name: 'Nova Grade',
                    type: 'Staggered',
                    items: [],
                    pos: newPos),
              );
            },
            child: const Text('Adicionar Grade'),
          ),
        ),
      ],
    );
  }

  imageSourceSheet(BuildContext context, Function(File) onImageSelected) {
    return BottomSheet(
      onClosing: () {},
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextButton(
            onPressed: () async {
              // Abre a câmera
              final XFile? file =
                  await picker.pickImage(source: ImageSource.camera);
              if (file != null) {
                editImage(File(file.path), onImageSelected, context);
              }
            },
            child: const Text('Câmera'),
          ),
          TextButton(
            onPressed: () async {
              // Abre a galeria
              final XFile? file =
                  await picker.pickImage(source: ImageSource.gallery);
              if (file != null) {
                editImage(File(file.path), onImageSelected, context);
              }
            },
            child: const Text('Galeria'),
          ),
        ],
      ),
    );
  }

  Future<void> editImage(
    File file,
    Function(File) onImageSelected,
    BuildContext context,
  ) async {
    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Editar Imagem',
          toolbarColor: Theme.of(context).primaryColor,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: true,
        ),
      ],
    );

    if (croppedFile != null) {
      onImageSelected(File(croppedFile.path)); // Agora é um `File`
    }
  }
}
