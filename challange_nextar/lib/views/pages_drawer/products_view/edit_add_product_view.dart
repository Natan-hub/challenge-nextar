import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:challange_nextar/core/theme/colors.dart';
import 'package:challange_nextar/core/theme/styles.dart';
import 'package:challange_nextar/core/widgets/app_bar_widget.dart';
import 'package:challange_nextar/core/widgets/botao_widget.dart';
import 'package:challange_nextar/core/widgets/flush_bar_widget.dart';
import 'package:challange_nextar/core/widgets/form_field_widget.dart';
import 'package:challange_nextar/helper/formater_helper.dart';
import 'package:challange_nextar/models/product_model.dart';
import 'package:challange_nextar/utils/validators/validacoes_mixin.dart';
import 'package:challange_nextar/viewmodels/edit_add_product_viewmodel.dart';
import 'package:challange_nextar/viewmodels/products_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProductView extends StatelessWidget with ValidacoesMixin {
  final ProductModel? product;

  const EditProductView({super.key, this.product});

  @override
  Widget build(BuildContext context) {
    final productViewModel =
        Provider.of<ProductViewModel>(context, listen: false);

    return ChangeNotifierProvider(
      create: (_) => EditAddProductViewModel(productViewModel, product),
      child: Consumer<EditAddProductViewModel>(
        builder: (context, viewModel, child) {
          final allImages = [
            ...viewModel.product.images,
            ...viewModel.product.localImages
          ];

          return Scaffold(
            appBar: _buildAppBar(context, viewModel),
            body: Form(
              key: viewModel.formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildImageCarousel(viewModel, allImages, context),
                  const SizedBox(height: 15),
                  _buildTextField(
                    label: "Nome",
                    initialValue: viewModel.product.name,
                    onSaved: (text) => viewModel.product.name = text!,
                    validator: (text) => combine([
                      () => isNotEmpty(text, context),
                      () => hasSixCharsTitleProduct(text, context),
                    ]),
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    label: "Preço",
                    initialValue: viewModel.product.price,
                    keyboardType: TextInputType.number,
                    onSaved: (text) => viewModel.product.price = text!,
                    validator: (text) => combine([
                      () => isNotEmpty(text, context),
                      () => isGreaterThanZero(text, context),
                    ]),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CurrencyPtBrInputFormatter()
                    ],
                    maxLength: 7,
                  ),
                  const SizedBox(height: 15),
                  _buildBiggerTextForm(context),
                  const SizedBox(height: 15),
                  _buildTextField(
                    label: "Estoque",
                    initialValue: viewModel.product.stock.toString(),
                    keyboardType: TextInputType.number,
                    onSaved: (text) =>
                        viewModel.product.stock = int.parse(text!),
                    validator: (text) => combine([
                      () => isNotEmpty(text, context),
                    ]),
                  ),
                  const SizedBox(height: 20),
                  Consumer<EditAddProductViewModel>(
                      builder: (context, productManager, __) {
                    if (productManager.error != null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        FlushBarWidget.mostrar(
                          context,
                          productManager.error!,
                          Icons.error_outline,
                          AppColors.vermelhoPadrao,
                        );
                        productManager.error = null;
                      });
                    }
                    return DefaultButton(
                      borderRadius: BorderRadius.circular(10),
                      cor: AppColors.corBotao,
                      padding: const EdgeInsets.fromLTRB(115, 20, 115, 20),
                      nomeBotao: 'Salvar',
                      onPressed: viewModel.isSaving
                          ? null
                          : () async {
                              bool success = await viewModel.saveProduct();
                              if (success) {
                                Navigator.pop(context);

                                FlushBarWidget.mostrar(
                                  context,
                                  'Produto salvo com sucesso!',
                                  Icons.check_circle_rounded,
                                  AppColors.verdePadrao,
                                );
                              }
                            },
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageCarousel(EditAddProductViewModel viewModel,
      List<dynamic> allImages, BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: CarouselSlider.builder(
            itemCount: allImages.length + 1,
            itemBuilder: (context, index, _) {
              if (index == allImages.length) {
                return IconButton(
                  icon: const Icon(Icons.add_a_photo, size: 50),
                  onPressed: () => _showImagePicker(context, viewModel),
                );
              }
              final image = allImages[index];
              return Stack(
                children: [
                  if (image is String)
                    CachedNetworkImage(imageUrl: image, fit: BoxFit.cover)
                  else if (image is File)
                    Image.file(image, fit: BoxFit.cover),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => viewModel.removeImage(image),
                    ),
                  ),
                ],
              );
            },
            options: CarouselOptions(
              height: 250,
              enableInfiniteScroll: false,
              onPageChanged: (index, _) => viewModel.updateCurrentIndex(index),
            ),
          ),
        ),
      ],
    );
  }

  void _showImagePicker(
      BuildContext context, EditAddProductViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
              onPressed: () => viewModel.pickImage(ImageSource.camera),
              child: const Text('Câmera')),
          TextButton(
              onPressed: () => viewModel.pickImage(ImageSource.gallery),
              child: const Text('Galeria')),
        ],
      ),
    );
  }

  AppBarWidget _buildAppBar(
      BuildContext context, EditAddProductViewModel viewModel) {
    return AppBarWidget(
      isTitulo: viewModel.isEditing ? 'Editando Produto' : 'Novo Produto',
      isVoltar: true,
      actions: viewModel.isEditing
          ? [
              IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.black,
                  ),
                  onPressed: () async {
                    bool success = await viewModel.deleteProduct();
                    if (success) {
                      Navigator.pop(context);
                      FlushBarWidget.mostrar(
                        context,
                        'Produto excluído com sucesso!',
                        Icons.delete,
                        AppColors.vermelhoPadrao,
                      );
                    }
                  })
            ]
          : null,
    );
  }

  Widget _buildBiggerTextForm(
    BuildContext context,
  ) {
    return TextFormField(
      validator: (val) => combine([
        () => isNotEmpty(val, context),
      ]),
      onSaved: (text) => product?.description = text!,
      initialValue: product?.description,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLength: 5000,
      maxLines: 10,
      cursorColor: AppColors.primary,
      decoration: InputDecoration(
        labelText: "Descrição do seu produto",
        alignLabelWithHint: true,
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.vermelhoPadrao),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.vermelhoPadrao),
        ),
        labelStyle: textFieldsLettersTextStyle(Colors.black),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
      ),
    );
  }
}

Widget _buildTextField(
    {required String label,
    String? initialValue,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
    String? Function(String?)? validator,
    required Function(String?) onSaved}) {
  return FormFieldWidget(
    labelText: label,
    initialValue: initialValue,
    keyboardType: keyboardType,
    onSaved: onSaved,
    hintText: '',
    padding: EdgeInsets.zero,
    validator: validator,
    maxLength: maxLength,
    inputFormatters: inputFormatters,
  );
}
