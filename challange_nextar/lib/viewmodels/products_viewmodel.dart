import 'package:challange_nextar/models/product_model.dart';
import 'package:challange_nextar/services/product_service.dart';
import 'package:flutter/material.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductService _productService = ProductService();

  bool _isSaving = false;
  bool get isSaving => _isSaving;

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

  /// Salva um produto no banco de dados, podendo ser uma nova adição ou edição.
  /// Atualiza a lista após a operação.
  Future<void> saveProduct(ProductModel product, bool isEditing) async {
    _isSaving = true;
    notifyListeners();

    try {
      await _productService.saveProduct(product, isEditing);
      await loadInitialProducts();
    } catch (e) {
      debugPrint("Erro ao salvar produto: $e");
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  /// Exclui um produto logicamente (marcando como deletado).
  /// Podeira chamar só o .delete e deletar o produto mas aí correria o risco de excluir onde eu uso ele
  /// que é associado a uma imagem na home.
  /// Marcado como false posso dizer que ele está indísponível para o usupario cliente.
  Future<void> deleteProduct(ProductModel product) async {
    _isSaving = true;
    notifyListeners();

    try {
      await _productService.deleteProduct(product);
      await loadInitialProducts(); // 🔹 Recarrega a lista para garantir que o produto sumiu
    } catch (e) {
      debugPrint("Erro ao deletar produto: $e");
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  /// Carrega a lista inicial de produtos, resetando a paginação.
  Future<void> loadInitialProducts() async {
    _productService.resetPagination();
    _products.clear();
    _hasMoreProducts = true;
    await _loadNextBatch();
  }

  Future<void> loadMoreProducts() async {
    if (_isLoading || !_hasMoreProducts) return;
    await _loadNextBatch();
  }

  /// Carrega o próximo lote de produtos do Firestore.
  Future<void> _loadNextBatch() async {
    _isLoading = true;
    notifyListeners();

    try {
      final newProducts = await _productService.loadNextBatch();
      _products = newProducts
          .where((p) => !p.deleted)
          .toList(); // Filtra produtos deletados

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
        _products.sort(
            (a, b) => double.parse(a.price).compareTo(double.parse(b.price)));
      }
    }
    notifyListeners();
  }

  /// Busca um produto pelo ID.
  ProductModel? findProductById(String id) {
    _products = _productService.allProducts;
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
}
