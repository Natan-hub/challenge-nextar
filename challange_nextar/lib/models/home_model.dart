class HomeItem {
  final String image;
  final String? product;

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
}

class HomeModel {
  final String name;
  final String type;
  final List<HomeItem> items;

  HomeModel({
    required this.name,
    required this.type,
    required this.items,
  });

  factory HomeModel.fromFirestore(Map<String, dynamic> data) {
    final items = (data['items'] as List)
        .map((item) => HomeItem.fromMap(item as Map<String, dynamic>))
        .toList();

    return HomeModel(
      name: data['name'] ?? '',
      type: data['type'] ?? '',
      items: items,
    );
  }
}
