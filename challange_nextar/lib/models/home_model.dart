import 'dart:io';
import 'package:flutter/material.dart';

class HomeItem {
  final dynamic image; 
  String? product;

  HomeItem({
    required this.image,
    this.product,
  });

  factory HomeItem.fromMap(Map<String, dynamic> data) {
    return HomeItem(
      image: data['image'] ?? '',
      product: data['product'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image is File ? '' : image,
      'product': product,
    };
  }

  HomeItem copyWith({dynamic image, String? product}) {
    return HomeItem(
      image: image ?? this.image,
      product: product, 
    );
  }
}

class HomeModel extends ChangeNotifier {
  String? id;
  String name;
  final String type;
  List<HomeItem> items;
  int pos;
  String? _error;

  HomeModel({
    this.id,
    required this.name,
    required this.type,
    required this.items,
    required this.pos,
  });

  factory HomeModel.fromFirestore(
      Map<String, dynamic> data, String documentId) {
    return HomeModel(
      id: documentId,
      name: data['name'],
      type: data['type'] ?? 'List',
      items: (data['items'] as List<dynamic>? ?? [])
          .map((item) => HomeItem.fromMap(item as Map<String, dynamic>))
          .toList(),
      pos: data['pos'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'items': items.map((item) => item.toMap()).toList(),
      'pos': pos,
    };
  }

  HomeModel copyWith(
      {String? name, String? type, List<HomeItem>? items, int? pos}) {
    return HomeModel(
      id: id,
      name: name ?? this.name,
      type: type ?? this.type,
      items: items ?? List.from(this.items),
      pos: pos ?? this.pos,
    );
  }

  void addItem(HomeItem item) {
    items.add(item);
    notifyListeners();
  }

  void removeItem(HomeItem item) {
    items.remove(item);
    notifyListeners();
  }

  bool valid() {
    if (name.trim().isEmpty) {
      _error = "Título inválido";
      return false;
    } else if (items.isEmpty) {
      _error = "Insira ao menos uma imagem";
      return false;
    } else {
      _error = null;
      return true;
    }
  }

  String? get error => _error;
}
