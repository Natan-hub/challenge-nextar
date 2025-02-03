import 'dart:io';
import 'package:challange_nextar/models/product_model.dart';
import 'package:challange_nextar/viewmodels/products_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:uuid/uuid.dart';

class EditAddProductViewModel extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();
  final ProductViewModel? productViewModel;

  late ProductModel product;
  bool isEditing = false;
  bool isSaving = false;
  int currentIndex = 0;

  EditAddProductViewModel(
      [this.productViewModel, ProductModel? initialProduct]) {
    isEditing = initialProduct != null;
    product = initialProduct?.copyWith() ??
        ProductModel(
          id: const Uuid().v4(),
          name: '',
          description: '',
          price: '',
          stock: 0,
          images: [],
        );
  }

  void updateCurrentIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  Future<bool> saveProduct() async {
    if (!formKey.currentState!.validate()) return false;
    formKey.currentState!.save();

    isSaving = true;
    notifyListeners();

    await productViewModel?.saveProduct(product, isEditing);

    isSaving = false;
    notifyListeners();

    return true;
  }

  Future<bool> deleteProduct() async {
    if (!formKey.currentState!.validate()) return false;
    formKey.currentState!.save();

    await productViewModel?.deleteProduct(product);
    return true;
  }

  void onImageSelected(File file) {
    product.localImages.add(file);
    notifyListeners();
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? file = await picker.pickImage(source: source);
    if (file != null) {
      await _editImage(File(file.path));
    }
  }

  Future<void> _editImage(File file) async {
    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Editar Imagem',
          lockAspectRatio: true,
        ),
      ],
    );

    if (croppedFile != null) {
      onImageSelected(File(croppedFile.path));
    }
  }

  void removeImage(dynamic image) {
    if (image is String) {
      product.images.remove(image);
    } else {
      product.localImages.remove(image);
    }
    notifyListeners();
  }
}
