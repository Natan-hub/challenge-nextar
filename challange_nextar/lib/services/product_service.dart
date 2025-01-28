import 'package:challange_nextar/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<ProductModel> _allProducts = [];
  DocumentSnapshot? _lastDocument; // Rastreamento do último documento
  final int batchSize = 10; // Tamanho do lote

  List<ProductModel> get allProducts => _allProducts;

  // Carrega o próximo lote de produtos
  Future<List<ProductModel>> loadNextBatch() async {
    try {
      Query query = _firestore.collection('products').limit(batchSize);

      // Adiciona a condição de início se houver um último documento
      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      final QuerySnapshot snapProducts = await query.get();

      if (snapProducts.docs.isNotEmpty) {
        _lastDocument = snapProducts.docs.last; // Atualiza o último documento
      }

      final products = snapProducts.docs
          .map((doc) => ProductModel.fromFirestore(
                doc.id,
                doc.data() as Map<String, dynamic>,
              ))
          .toList();

      _allProducts.addAll(products); // Atualiza a lista de produtos carregados
      return products;
    } catch (e) {
      throw Exception('Erro ao carregar produtos: ${e.toString()}');
    }
  }

  // Reseta a paginação
  void resetPagination() {
    _lastDocument = null;
    _allProducts.clear();
  }
}
