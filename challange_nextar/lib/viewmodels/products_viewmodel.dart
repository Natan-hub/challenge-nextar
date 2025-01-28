import 'package:challange_nextar/models/product_model.dart';
import 'package:challange_nextar/services/product_service.dart';
import 'package:flutter/material.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductService _productService = ProductService();

  List<ProductModel> _products = [];
  bool _isLoading = false;
  bool _hasMoreProducts = true; // Indica se há mais produtos para carregar

  String? _selectedFilter;

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;
  bool get hasMoreProducts => _hasMoreProducts;

  String? get selectedFilter => _selectedFilter;

  ProductViewModel() {
    loadInitialProducts();
  }

  Future<void> loadInitialProducts() async {
    _productService.resetPagination(); // Reseta a paginação
    _products.clear();
    _hasMoreProducts = true;
    await _loadNextBatch();
  }

  Future<void> loadMoreProducts() async {
    if (_isLoading || !_hasMoreProducts) return;
    await _loadNextBatch();
  }

    Future<void> _loadNextBatch() async {
    _isLoading = true;
    notifyListeners();

    try {
      final newProducts = await _productService.loadNextBatch();
      _products.addAll(newProducts);

      // Verifica se há mais produtos
      if (newProducts.length < _productService.batchSize) {
        _hasMoreProducts = false;
      }
    } catch (e) {
      debugPrint('Erro ao carregar mais produtos: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }



  void applyFilter(String filter) {
    if (_selectedFilter == filter) {
      // Se o filtro já está ativo, limpa o filtro
      _selectedFilter = null;
      loadInitialProducts(); // Recarrega os produtos sem filtros
    } else {
      // Aplica o filtro
      _selectedFilter = filter;

      if (filter == 'Mais recente') {
        _products = List.from(_products.reversed);
      } else if (filter == 'Mais antigo') {
        _products.sort(
            (a, b) => _products.indexOf(a).compareTo(_products.indexOf(b)));
      } else if (filter == 'Ordem Alfabética') {
        _products.sort((a, b) => a.name.compareTo(b.name));
      } else if (filter == 'Preço: Mais barato') {
        _products
            .sort((a, b) => a.price.compareTo(b.price)); // Ordena por preço
      }
    }
    notifyListeners();
  }

  ProductModel? findProductById(String id) {
    _products = _productService.allProducts;
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
}
