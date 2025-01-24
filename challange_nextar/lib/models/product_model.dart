class ProductModel {
  final String id; 
  final String name;
  final String description;
  final String price;
  final List<String> images;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
  });

  // Método para criar um objeto ProductModel a partir do Firestore
  factory ProductModel.fromFirestore(Map<String, dynamic> data) {
    return ProductModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: data['price'] ?? '',
      images: List<String>.from(data['images'] ?? []),
    );
  }
}
