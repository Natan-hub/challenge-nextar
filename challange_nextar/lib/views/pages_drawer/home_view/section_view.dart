import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:challange_nextar/core/theme/colors.dart';
import 'package:challange_nextar/core/widgets/flush_bar_widget.dart';
import 'package:challange_nextar/core/widgets/form_field_widget.dart';
import 'package:challange_nextar/core/widgets/native_dialog_widget.dart';
import 'package:challange_nextar/models/home_model.dart';
import 'package:challange_nextar/models/product_model.dart';
import 'package:challange_nextar/routes/routes.dart';
import 'package:challange_nextar/viewmodels/home_viewmodel.dart';
import 'package:challange_nextar/viewmodels/products_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SectionWidget extends StatelessWidget {
  final HomeViewModel homeManager;
  final HomeModel section;

  SectionWidget({
    super.key,
    required this.homeManager,
    required this.section,
  });

  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return section.type == 'List'
        ? _buildSectionList(context, section)
        : _buildSectionStaggered(context, section);
  }

  Widget _buildSectionList(BuildContext context, HomeModel section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleSection(context, section),
        SizedBox(
          height: 150,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: homeManager.editing
                  ? section.items.length + 1
                  : section.items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 4),
              itemBuilder: (_, index) {
                final bool isLastItem = index >= section.items.length;
                final HomeProduct? item =
                    isLastItem ? null : section.items[index];

                return isLastItem
                    ? _buildButtonAdd(context, section)
                    : _buildItemOptions(context, section, item);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionStaggered(BuildContext context, HomeModel section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleSection(context, section),
        GridView.custom(
          padding: const EdgeInsets.all(8),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverQuiltedGridDelegate(
            crossAxisCount: 4,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
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
              final bool isLastItem = index >= section.items.length;
              final HomeProduct? item =
                  isLastItem ? null : section.items[index];

              return isLastItem
                  ? _buildButtonAdd(context, section)
                  : _buildItemOptions(context, section, item);
            },
            childCount: homeManager.editing
                ? section.items.length + 1
                : section.items.length,
          ),
        ),
      ],
    );
  }

  Widget _buildTitleSection(BuildContext context, HomeModel section) {
    if (homeManager.editing) {
      return Row(
        children: [
          Expanded(
            child: FormFieldWidget(
              initialValue: section.name,
              onChanged: (text) {
                section.name = text!;
                homeManager.updateUI();
              },
              labelText: 'Título',
              hintText: '',
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_rounded, color: Colors.red),
            onPressed: () => homeManager.removeSection(section),
          ),
        ],
      );
    } else {
      return Text(
        section.name,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      );
    }
  }

  Widget _buildItemOptions(
      BuildContext context, HomeModel section, HomeProduct? item) {
    return InkWell(
      onTap: () {
        if (item.product != null) {
          final product =
              context.read<ProductViewModel>().findProductById(item.product!);
          if (product != null) {
            Navigator.of(context).pushNamed(
              Routes.detailsProduct,
              arguments: {'product': product},
            );
          }
        } else {
          NativeDialog.showAlert(
            context: context,
            title: "Aviso!",
            message: 'Nenhum produto vinculado.',
            confirmButtonText: "Ok",
          );
        }
      },
      onLongPress: homeManager.editing && item != null
          ? () => _buildDialogLinkProduct(context, section, item)
          : null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CachedNetworkImage(
          imageUrl: item!.image,
          fit: BoxFit.cover,
          errorWidget: (_, __, ___) => const Icon(Icons.image_not_supported,
              size: 50, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildButtonAdd(BuildContext context, HomeModel section) {
    return InkWell(
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
    );
  }

  void _buildDialogLinkProduct(
      BuildContext context, HomeModel section, HomeProduct item) {
    showDialog(
      context: context,
      builder: (_) {
        final product = context
            .read<ProductViewModel>()
            .findProductById(item.product ?? "");

        return AlertDialog(
          title: const Text('Editar Item'),
          content: product != null
              ? ListTile(
                  leading: CachedNetworkImage(imageUrl: product.images.first),
                  title: Text(product.name),
                  subtitle: Text("R\$ ${product.price}"),
                )
              : const Text("Nenhum produto vinculado."),
          actions: [
            TextButton(
              onPressed: () {
                homeManager.removeItem(section, item);
                Navigator.of(context).pop();
              },
              child: const Text('Excluir', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () async {
                if (product != null) {
                  homeManager.updateItem(section, item.copyWith(product: null));
                } else {
                  final selectedProduct = await Navigator.of(context)
                      .pushNamed(Routes.selectedProduct) as ProductModel?;
                  if (selectedProduct != null) {
                    homeManager.updateItem(
                      section,
                      item.copyWith(product: selectedProduct.id),
                    );
                  }
                }
                Navigator.of(context).pop();
              },
              child: Text(product != null ? "Desvincular" : "Vincular"),
            ),
          ],
        );
      },
    );
  }

  void onImageSelected(
      File file, BuildContext context, HomeModel section) async {
    final homeViewModel = context.read<HomeViewModel>();

    homeViewModel.setUploading(true);

    await homeViewModel.addItemToSection(section, file);

    homeViewModel.setUploading(false);

    Navigator.of(context).pop();

    FlushBarWidget.mostrar(
      context,
      'Imagem adicionado',
      Icons.check_circle_rounded,
      AppColors.verdePadrao,
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
      onImageSelected(File(croppedFile.path));
    }
  }
}
