import 'package:challange_nextar/models/product_model.dart';
import 'package:challange_nextar/services/product_service.dart';
import 'package:flutter/material.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductService _productService = ProductService();

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  List<ProductModel> _products = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMoreProducts = true; // 📌Indica se há mais produtos para carregar
  bool _selectionMode = false; //📌 Indica se a seleção múltipla está ativada
  bool shouldCloseDialog = false;
  Set<String> _selectedProducts = {};

  String? _selectedFilter;
  String? successMessage;
  String? errorMessage;

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMoreProducts => _hasMoreProducts;
  bool get selectionMode => _selectionMode;
  Set<String> get selectedProducts => _selectedProducts;

  String? get selectedFilter => _selectedFilter;

  ProductViewModel() {
    loadInitialProducts();
  }

  /// 📌Salva um produto no banco de dados, podendo ser uma nova adição ou edição.
  /// 📌Atualiza a lista após a operação.
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

  ///📌 Exclui um produto logicamente (marcando como deletado).
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

  ///📌 Carrega a lista inicial de produtos, resetando a paginação.
  Future<void> loadInitialProducts() async {
    if (_products.isNotEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      final loadedProducts = await _productService.getProducts();
      _products = loadedProducts;
      _hasMoreProducts = loadedProducts.length >= _productService.batchSize;
    } catch (e) {
      debugPrint("Erro ao carregar produtos: $e");
      errorMessage = "Erro ao carregar produtos.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreProducts() async {
    if (_isLoadingMore || !_hasMoreProducts) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final newProducts = await _productService.loadNextBatch();

      // 🔹 Evita duplicação
      final uniqueProducts = newProducts.where(
        (newP) => !_products.any((existingP) => existingP.id == newP.id),
      );

      _products.addAll(uniqueProducts);

      if (newProducts.length < _productService.batchSize) {
        _hasMoreProducts = false;
      }
    } catch (e) {
      debugPrint('Erro ao carregar mais produtos: $e');
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// 📌Carrega o próximo lote de produtos do Firestore.
  Future<void> _loadNextBatch() async {
    _isLoading = true;
    notifyListeners();

    try {
      final newProducts = await _productService.loadNextBatch();
      _products.addAll(newProducts.where((p) => !p.deleted));
      // 📌Filtra produtos deletados

      // 📌Verifica se há mais produtos
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

  /// 📌Alterna o modo de seleção múltipla
  void toggleSelectionMode() {
    _selectionMode = !_selectionMode;
    _selectedProducts.clear();
    notifyListeners();
  }

  /// 📌Alterna a seleção de um produto
  void toggleProductSelection(String productId) {
    if (_selectedProducts.contains(productId)) {
      _selectedProducts.remove(productId);
    } else {
      _selectedProducts.add(productId);
    }
    notifyListeners();
  }

  /// 📌Exclui os produtos selecionados
  Future<void> deleteSelectedProducts() async {
    _isSaving = true;
    notifyListeners();

    try {
      for (String productId in _selectedProducts) {
        final product = _products.firstWhere((p) => p.id == productId);
        await _productService.deleteProduct(product);

        // Define mensagem de sucesso
        successMessage = 'Produto deletado';
        shouldCloseDialog = true;
      }

      await loadInitialProducts();
    } catch (e) {
      errorMessage = "Erro ao excluir produtos: $e.";
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  void applyFilter(String filter) {
    if (_selectedFilter == filter) {
      //📌 Se o filtro já está ativo, limpa o filtro
      _selectedFilter = null;
      loadInitialProducts(); // Recarrega os produtos sem filtros
    } else {
      //📌 Aplica o filtro
      _selectedFilter = filter;

      if (filter == 'Mais recente') {
        _products = List.from(_products.reversed);
      } else if (filter == 'Mais antigo') {
        _products.sort(
            (a, b) => _products.indexOf(a).compareTo(_products.indexOf(b)));
      } else if (filter == 'Ordem Alfabética') {
        _products.sort((a, b) => a.name.compareTo(b.name));
      } else if (filter == 'Preço: Mais barato') {
        _products.sort((a, b) {
          double priceA = _convertToDouble(a.price);
          double priceB = _convertToDouble(b.price);
          return priceA.compareTo(priceB);
        });
      }
    }
    notifyListeners();
  }

  double _convertToDouble(String? price) {
    if (price == null || price.trim().isEmpty) return 0.0;

    // Remove qualquer espaço extra
    String cleanedPrice = price.trim();

    // Verifica se o preço está no formato "4.700,00"
    if (cleanedPrice.contains('.') && cleanedPrice.contains(',')) {
      cleanedPrice = cleanedPrice.replaceAll('.', '').replaceAll(',', '.');
    } else if (cleanedPrice.contains(',')) {
      cleanedPrice = cleanedPrice.replaceAll(',', '.');
    }

    return double.tryParse(cleanedPrice) ?? 0.0;
  }

  /// 📌Busca um produto pelo ID.
  ProductModel? findProductById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      debugPrint("Produto não encontrado: $e");
      return null;
    }
  }
}
