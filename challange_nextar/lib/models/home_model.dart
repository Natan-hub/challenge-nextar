import 'dart:io';
import 'package:flutter/material.dart';

class HomeProduct {
  final dynamic image;
  final String? product;

  HomeProduct({
    required this.image,
    this.product,
  });

  factory HomeProduct.fromMap(Map<String, dynamic> data) {
    return HomeProduct(
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

  HomeProduct copyWith({dynamic image, String? product}) {
    return HomeProduct(
      image: image ?? this.image,
      product: product,
    );
  }
}

class HomeModel extends ChangeNotifier {
  String? id;
  String name;
  String type;
  final List<HomeProduct> items;
  final int pos;
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
          .map((item) => HomeProduct.fromMap(item as Map<String, dynamic>))
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
      {String? name, String? type, List<HomeProduct>? items, int? pos}) {
    return HomeModel(
      id: id,
      name: name ?? this.name,
      type: type ?? this.type,
      items: items ?? List.from(this.items),
      pos: pos ?? this.pos,
    );
  }

  void addItem(HomeProduct item) {
    items.add(item);
    notifyListeners();
  }

  void removeItem(HomeProduct item) {
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
