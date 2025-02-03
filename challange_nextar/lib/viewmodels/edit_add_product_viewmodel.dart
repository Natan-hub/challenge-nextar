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
  String? _error;

  String? get error => _error;

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

  set error(String? value) {
    _error = value;
    notifyListeners();
  }

  bool validateProduct() {
    if (!formKey.currentState!.validate()) return false;
    formKey.currentState!.save();

    if (product.images.isEmpty && product.localImages.isEmpty) {
      error = "Adicione pelo menos uma imagem ao produto.";
      return false;
    }

    error = null;
    return true;
  }

  Future<bool> saveProduct() async {
    if (!validateProduct()) {
      notifyListeners();
      return false;
    }

    isSaving = true;
    notifyListeners();

    try {
      await productViewModel?.saveProduct(product, isEditing);
    } catch (e) {
      debugPrint("Erro ao salvar produto: $e");
      error = "Erro ao salvar o produto. Tente novamente.";
      notifyListeners();
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }

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
