class ProductModel {
  final String id;
  final String name;
  final String description;
  final String price;
  final int stock;
  final List<String> images;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.images,
  });

  // Método para criar um objeto ProductModel a partir do Firestore
  factory ProductModel.fromFirestore(String id, Map<String, dynamic> data) {
    return ProductModel(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: data['price'] ?? '',
      stock: data['stock'] ?? 0,
      images: List<String>.from(data['images'] ?? []),
    );
  }
}
