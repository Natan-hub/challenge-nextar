import 'package:challange_nextar/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<ProductModel> _allProducts = [];

  List<ProductModel> get allProducts => _allProducts;

  ProductService() {
    loadAllProducts();
  }

  // Carrega todos os produtos do Firestore
  Future<void> loadAllProducts() async {
    try {
      final QuerySnapshot snapProducts =
          await _firestore.collection('products').get();

      _allProducts = snapProducts.docs
          .map((doc) => ProductModel.fromFirestore(
              doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erro ao carregar produtos: ${e.toString()}');
    }
  }
}
