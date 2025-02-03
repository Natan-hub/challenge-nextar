import 'dart:io';

import 'package:challange_nextar/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  List<ProductModel> _allProducts = [];
  DocumentSnapshot? _lastDocument; // Rastreamento do último documento
  final int batchSize = 10; // Tamanho do lote

  List<ProductModel> get allProducts => _allProducts;

  /// Salva um produto no Firestore. Se for edição, atualiza o documento existente.
  Future<void> saveProduct(ProductModel product, bool isEditing) async {
    try {
      // 🔹 Atualiza a lista de imagens do produto
      final List<String> updatedImages = await _processImages(product);

      // 🔹 Se for edição, remove imagens antigas que foram excluídas
      if (isEditing) {
        await _removeOldImages(product.id, updatedImages);
      }

      // 🔹 Criamos um novo objeto ProductModel com as imagens atualizadas
      ProductModel updatedProduct = product.copyWith(images: updatedImages);

      // 🔹 Salva ou atualiza no Firestore
      await _saveToFirestore(updatedProduct, isEditing);
    } catch (e) {
      throw Exception("Erro ao salvar produto: $e");
    }
  }

  /// 🔹 Faz upload das imagens locais e mantém as já existentes
  Future<List<String>> _processImages(ProductModel product) async {
    List<String> updatedImages = List.from(product.images);

    for (final file in product.localImages) {
      String imageUrl = await _uploadImage(file, product.id);
      updatedImages.add(imageUrl);
    }

    return updatedImages;
  }

  /// 🔹 Remove imagens antigas que não estão mais no produto
  Future<void> _removeOldImages(
      String productId, List<String> updatedImages) async {
    DocumentSnapshot doc =
        await _firestore.collection('products').doc(productId).get();

    if (doc.exists) {
      List<String> oldImages = List<String>.from(doc['images'] ?? []);
      for (final oldImage in oldImages) {
        if (!updatedImages.contains(oldImage)) {
          await _deleteImageFromStorage(oldImage);
        }
      }
    }
  }

  /// 🔹 Salva ou atualiza o produto no Firestore
  Future<void> _saveToFirestore(ProductModel product, bool isEditing) async {
    final docRef = _firestore.collection('products').doc(product.id);
    if (isEditing) {
      await docRef.update(product.toMap());
    } else {
      await docRef.set(product.toMap());
    }
  }

  /// Realiza o upload de uma imagem para o Firebase Storage e retorna a URL.

  Future<String> _uploadImage(File imageFile, String productId) async {
    try {
      String fileName = 'products/$productId/${const Uuid().v4()}.jpg';
      Reference ref = _storage.ref().child(fileName);
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception("Erro ao fazer upload da imagem: $e");
    }
  }

  /// Marca um produto como deletado no Firestore.

  Future<void> deleteProduct(ProductModel product,
      {bool removeImages = false}) async {
    try {
      // Marcar como deletado no Firestore
      await _firestore.collection('products').doc(product.id).update({
        'deleted': true,
      });

      // ⚠️ Só remove imagens se realmente quiser deletá-las do Firebase
      if (removeImages) {
        for (final imageUrl in product.images) {
          await _deleteImageFromStorage(imageUrl);
        }
      }
    } catch (e) {
      throw Exception("Erro ao deletar produto: $e");
    }
  }

  Future<void> _deleteImageFromStorage(String imageUrl) async {
    try {
      Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      print("Erro ao excluir imagem do Firebase Storage: $e");
    }
  }

  // Adicionar produto ao Firestore
  Future<void> addProduct(ProductModel product) async {
    await _firestore
        .collection('products')
        .doc(product.id)
        .set(product.toMap());
  }

  // Atualizar produto existente
  Future<void> updateProduct(ProductModel product) async {
    await _firestore
        .collection('products')
        .doc(product.id)
        .update(product.toMap());
  }

  /// Carrega o próximo lote de produtos do Firestore.

  Future<List<ProductModel>> loadNextBatch() async {
    try {
      Query query = _firestore
          .collection('products')
          .where('deleted',
              isEqualTo: false) // 🔹 Filtra produtos não deletados
          .limit(batchSize);

      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      final QuerySnapshot snapProducts = await query.get();

      if (snapProducts.docs.isNotEmpty) {
        _lastDocument = snapProducts.docs.last;
      }

      final products = snapProducts.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();

      _allProducts.addAll(products);
      return products;
    } catch (e) {
      throw Exception('Erro ao carregar produtos: ${e.toString()}');
    }
  }

  /// Reseta a paginação e limpa a lista de produtos.

  void resetPagination() {
    _lastDocument = null;
    _allProducts.clear();
  }
}
