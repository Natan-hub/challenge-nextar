import 'package:challange_nextar/models/home_model.dart';
import 'package:challange_nextar/services/home_service.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeService _homeService = HomeService();

  List<HomeModel> _sections = [];

  List<HomeModel> get sections => _sections;

  HomeViewModel() {
    _listenToSections();
  }

  void _listenToSections() {
    _homeService.listenToSections().listen((updatedSections) {
      _sections = updatedSections;
      notifyListeners(); // Notifica a UI sobre as mudanças
    });
  }
}
