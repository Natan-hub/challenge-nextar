import 'dart:io';
import 'package:flutter/material.dart';
import '../models/home_model.dart';
import '../services/home_service.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeService _homeService = HomeService();

  List<HomeModel> _sections = [];
  List<HomeModel> _editingSections = [];
  bool _editing = false;

  bool get editing => _editing;
  List<HomeModel> get sections => _editing ? _editingSections : _sections;

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

  void saveEditing() {
    _editing = false;
    _sections = List.from(_editingSections);
    notifyListeners();
    _homeService.saveSections(_sections);
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
  int sectionIndex = _editingSections.indexWhere((s) => s.name == section.name);
  
  if (sectionIndex != -1) {
    List<HomeItem> updatedItems = List.from(_editingSections[sectionIndex].items);
    
    int itemIndex = updatedItems.indexWhere((item) => item.image == updatedItem.image);

    if (itemIndex != -1) {
      updatedItems[itemIndex] = updatedItem; 
      _editingSections[sectionIndex] = section.copyWith(items: updatedItems);
      
      notifyListeners(); 
    }
  }
}

}
