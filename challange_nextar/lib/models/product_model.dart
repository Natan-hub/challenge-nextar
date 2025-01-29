import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  String name;
  String description;
  String price;
  int stock;
  List<String> images;
  List<File> localImages = []; // Armazena imagens locais temporariamente

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.images,
  });

  // Criar um clone do produto para edição
  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    String? price,
    int? stock,
    List<String>? images,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      images: images ?? List.from(this.images),
    );
  }

  // Método para converter do Firestore
  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: data['price'] ?? '',
      stock: data['stock'] ?? 0,
      images: List<String>.from(data['images'] ?? []),
    );
  }

  // Método para converter para um Map para salvar no Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'images': images,
    };
  }
}
