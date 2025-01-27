import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:challange_nextar/components/app_bar_component.dart';
import 'package:challange_nextar/models/product_model.dart';
import 'package:challange_nextar/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class EditProductView extends StatefulWidget {
  final ProductModel product;

  const EditProductView({
    super.key,
    required this.product,
  });

  @override
  State<EditProductView> createState() => _EditProductViewState();
}

class _EditProductViewState extends State<EditProductView> {
  int _currentIndex = 0;

  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarComponente(
        isTitulo: 'Editando produto',
      ),
      body: ListView(
        children: [
          FormField<List<dynamic>>(
            initialValue: List.from(widget.product.images),
            builder: (state) {
              void onImageSelected(File file) {
                state.value?.add(file);
                state.didChange(state.value);
                Navigator.of(context).pop();
              }

              return Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: CarouselSlider.builder(
                      itemCount: (state.value?.length ?? 0) +
                          1, // Adiciona um item extra para o botão
                      itemBuilder: (context, index, realIndex) {
                        if (index == state.value?.length) {
                          // Último item: botão para adicionar foto
                          return Material(
                            child: IconButton(
                              icon: const Icon(Icons.add_a_photo),
                              color: Theme.of(context).primaryColor,
                              iconSize: 50,
                              onPressed: () {
                                // Mostra o modal para selecionar imagem
                                showModalBottomSheet(
                                  context: context,
                                  builder: (_) => imageSourceSheet(
                                    context,
                                    onImageSelected,
                                  ),
                                );
                              },
                            ),
                          );
                        }

                        final image = state.value![index];
                        return Stack(
                          // fit: StackFit.expand,
                          children: <Widget>[
                            if (image is String)
                              Image.network(
                                image,
                                fit: BoxFit.cover,
                              )
                            else
                              Image.file(
                                image,
                                fit: BoxFit.cover,
                              ),
                            // Botão de remover a imagem
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                icon: const Icon(Icons.delete_rounded),
                                color: AppColors.vermelhoPadrao,
                                onPressed: () {
                                  state.value?.remove(image);
                                  state.didChange(state.value);
                                },
                              ),
                            ),
                          ],
                        );
                      },
                      options: CarouselOptions(
                        height: 250, // Altura do carrossel
                        enableInfiniteScroll: false,
                        enlargeCenterPage: true,
                        autoPlay: false,
                        viewportFraction: 0.9,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                      ),
                    ),
                  ),
                  // Indicador de posição do carrossel
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      (state.value?.length ?? 0) +
                          1, // Inclui o indicador do botão
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentIndex == index ? 16 : 8,
                        decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? Colors.teal
                              : Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  imageSourceSheet(BuildContext contex, Function(File) onImageSelected) {
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
                editImage(file.path, onImageSelected, context);
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
                editImage(file.path, onImageSelected, context);
              }
            },
            child: const Text('Galeria'),
          ),
        ],
      ),
    );
  }

  Future<void> editImage(
    String path,
    Function(File) onImageSelected,
    BuildContext context,
  ) async {
    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: path,
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
