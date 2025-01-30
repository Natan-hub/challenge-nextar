import 'dart:io';
import 'package:flutter/material.dart';
import '../models/home_model.dart';
import '../services/home_service.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeService _homeService = HomeService();

  List<HomeModel> _sections = [];
  List<HomeModel> _editingSections = [];

  bool _editing = false;
  bool _loading = false;

  String? _error;

  String? get error => _error;

  bool get editing => _editing;
  bool get loading => _loading;

  List<HomeModel> get sections => _editing ? _editingSections : _sections;

  set error(String? value) {
    _error = value;
    notifyListeners();
  }

  HomeViewModel() {
    _listenToSections();
  }

  void _listenToSections() {
    _homeService.listenToSections().listen((updatedSections) {
      _sections = updatedSections;
      if (!_editing) {
        _editingSections = _sections.map((s) => s.copyWith()).toList();
      }
      notifyListeners();
    });
  }

  void enterEditing() {
    _editing = true;
    _editingSections = _sections.map((s) => s.copyWith()).toList();
    notifyListeners();
  }

  Future<void> saveEditing() async {
    bool isValid = true;

    for (final section in _editingSections) {
      if (!section.valid()) {
        isValid = false;
      }
    }

    if (!isValid) {
      error = "Erro ao salvar. Verifique os campos!";
      notifyListeners();
      return;
    }

    _loading = true;
    notifyListeners();

    int pos = 0;
    for (final section in _editingSections) {
      await _homeService.saveSection(section, pos);
      pos++;
    }

    // 🔹 Remover seções que não existem mais
    for (final section in List.from(_sections)) {
      if (!_editingSections.any((element) => element.id == section.id)) {
        await _homeService.deleteSection(section);
      }
    }

    _loading = false;
    _editing = false;
    _sections = List.from(_editingSections);
    notifyListeners();
  }

  void discardEditing() {
    _editing = false;
    _editingSections = _sections.map((s) => s.copyWith()).toList();
    notifyListeners();
  }

  void addSection(HomeModel section) {
    _editingSections.add(section);
    notifyListeners();
  }

  void removeSection(HomeModel section) {
    _editingSections.remove(section);
    notifyListeners();
    _homeService.deleteSection(section);
  }

  Future<void> addItemToSection(HomeModel section, File imageFile) async {
    try {
      String imageUrl = await _homeService.uploadImage(imageFile);

      int index = _editingSections.indexWhere((s) => s.name == section.name);
      if (index != -1) {
        _editingSections[index] = section.copyWith(
          items: [...section.items, HomeItem(image: imageUrl)],
        );
        notifyListeners();
      }
    } catch (e) {
      print("Erro ao adicionar imagem: $e");
    }
  }

  Future<void> removeItem(HomeModel section, HomeItem item) async {
    int index = _editingSections.indexWhere((s) => s.name == section.name);
    if (index != -1) {
      if (item.image is String) {
        await _homeService.deleteImage(item.image as String);
      }
      _editingSections[index].items.remove(item);
      notifyListeners();
    }
  }

  void updateItem(HomeModel section, HomeItem updatedItem) {
    int sectionIndex =
        _editingSections.indexWhere((s) => s.name == section.name);

    if (sectionIndex != -1) {
      List<HomeItem> updatedItems =
          List.from(_editingSections[sectionIndex].items);

      int itemIndex =
          updatedItems.indexWhere((item) => item.image == updatedItem.image);

      if (itemIndex != -1) {
        updatedItems[itemIndex] = updatedItem;
        _editingSections[sectionIndex] = section.copyWith(items: updatedItems);

        notifyListeners();
      }
    }
  }
}
