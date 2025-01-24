import 'package:challange_nextar/models/product_model.dart';
import 'package:challange_nextar/services/product_service.dart';
import 'package:flutter/material.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductService _productService = ProductService();

  List<ProductModel> _products = [];
  bool _isLoading = false;

  String? _selectedFilter;

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;
  String? get selectedFilter => _selectedFilter;

  ProductViewModel() {
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _productService.loadAllProducts();
      _products = _productService.allProducts;
    } catch (e) {
      debugPrint('Erro ao carregar produtos: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void applyFilter(String filter) {
    if (_selectedFilter == filter) {
      // Se o filtro já está ativo, limpa o filtro
      _selectedFilter = null;
      _loadProducts(); // Recarrega os produtos sem filtros
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
}
