import 'dart:io';
import 'package:flutter/material.dart';

class HomeItem {
  final dynamic image; // Pode ser String (URL) ou File (arquivo local)
  String? product; // 🔹 Remove o "final" para permitir atualização

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
      'image': image is File ? '' : image, // Armazena apenas URL no Firestore
      'product': product,
    };
  }

  HomeItem copyWith({dynamic image, String? product}) {
    return HomeItem(
      image: image ?? this.image,
      product: product, // 🔹 Permite definir `null` corretamente
    );
  }
}


class HomeModel extends ChangeNotifier {
  String? name;
  final String type;
  List<HomeItem> items = [];

  HomeModel({
    this.name,
    required this.type,
    required this.items,
  });

  factory HomeModel.fromFirestore(Map<String, dynamic> data) {
    return HomeModel(
      name: data['name'] ?? '',
      type: data['type'] ?? '',
      items: (data['items'] as List)
          .map((item) => HomeItem.fromMap(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'items': items.map((item) => item.toMap()).toList(),
    };
  }

  HomeModel copyWith({String? name, String? type, List<HomeItem>? items}) {
    return HomeModel(
      name: name ?? this.name,
      type: type ?? this.type,
      items: items ?? List.from(this.items),
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
}
