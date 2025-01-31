import 'package:challange_nextar/components/floatin_button_component.dart';
import 'package:challange_nextar/routes/pages.dart';
import 'package:challange_nextar/utils/colors.dart';
import 'package:challange_nextar/utils/images.dart';
import 'package:challange_nextar/utils/styles.dart';
import 'package:challange_nextar/viewmodels/products_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final Set<String> _selectedProducts = {}; // Armazena os produtos selecionados

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ProductViewModel>(
        builder: (context, productViewModel, child) {
          return NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent &&
                  productViewModel.hasMoreProducts &&
                  !productViewModel.isLoading) {
                productViewModel.loadMoreProducts();
              }
              return false;
            },
            child: _buildBody(productViewModel),
          );
        },
      ),
      floatingActionButton: Consumer<ProductViewModel>(
        builder: (context, productViewModel, child) {
          return FabMenuButton(
            onPressed: () => _showFilterDialog(context, productViewModel),
            onPressed2: () async {
              await Navigator.pushNamed(context, Routes.editAddProduct);
            },
          );
        },
      ),
    );
  }

  /// Constrói o corpo principal da tela
  Widget _buildBody(ProductViewModel productViewModel) {
    if (productViewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (productViewModel.products.isEmpty) {
      return _buildEmptyList();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        itemCount: productViewModel.products.length +
            (productViewModel.hasMoreProducts ? 1 : 0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.65,
        ),
        itemBuilder: (context, index) {
          if (index == productViewModel.products.length) {
            return const Center(child: CircularProgressIndicator());
          }

          final product = productViewModel.products[index];
          return _buildProductCard(context, product);
        },
      ),
    );
  }

  Widget _buildProductCard(context, product) {
    final bool isSelected = _selectedProducts.contains(product.id);

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.detailsProduct,
          arguments: {
            'product': product,
          },
        );
      },
      onLongPress: () {
        setState(() {
          if (_selectedProducts.contains(product.id)) {
            _selectedProducts.remove(product.id);
          } else {
            _selectedProducts.add(product.id);
          }
        });
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 3,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 📌Imagem do Produto com sobreposição para "Sem Estoque"
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        Image.network(
                          product.images.first,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey,
                            );
                          },
                        ),

                        // Exibe a faixa de "Sem Estoque" se o estoque for 0
                        if (product.stock == 0)
                          Positioned(
                            top: 50,
                            left: 0,
                            right: 0,
                            child: Transform.rotate(
                              angle: -0.7, // Inclinação da faixa
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary2,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'SEM ESTOQUE',
                                  textAlign: TextAlign.center,
                                  style: normalTextStyleBold(Colors.white),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // Título do Produto
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: normalTextStyleBold(Colors.black),
                  ),
                ),

                // Informações adicionais
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'R\$ ${product.price}',
                        style: subTextStyle(),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'em até 10x sem juros',
                        style: subTextStyle(),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ],
            ),
             if (isSelected) _buildSelectionOverlay(),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context, ProductViewModel viewModel) {
    final filters = [
      {'label': 'Mais recente', 'icon': Icons.date_range},
      {'label': 'Mais antigo', 'icon': Icons.date_range},
      {'label': 'Preço: Mais barato', 'icon': Icons.attach_money},
      {'label': 'Ordem Alfabética', 'icon': Icons.sort_by_alpha},
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filtrar Produtos',
              style: normalTextStyleBold(Colors.black)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: filters.map((filter) {
              return ListTile(
                leading: Icon(
                  filter['icon'] as IconData,
                  color: viewModel.selectedFilter == filter['label']
                      ? AppColors.primary2
                      : Colors.black,
                ),
                title: Text(
                  filter['label'] as String,
                  style: TextStyle(
                    color: viewModel.selectedFilter == filter['label']
                        ? AppColors.primary2
                        : Colors.black,
                  ),
                ),
                onTap: () {
                  viewModel.applyFilter(filter['label'] as String);
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildEmptyList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppImages.listaVazia,
            height: 210,
            width: 210,
          ),
          const SizedBox(height: 20),
          Text(
            "Nenhum produto criado, clique no botão '+' e adicione.",
            style: principalTextStyle(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

    /// Exibe a sobreposição quando o produto está selecionado
  Widget _buildSelectionOverlay() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Icon(Icons.check_circle, color: Colors.white, size: 40),
      ),
    );
  }

  /// Exibe o botão de excluir quando há produtos selecionados
  Widget? _buildFloatingActionButton() {
    if (_selectedProducts.isNotEmpty) {
      return FloatingActionButton(
        onPressed: _confirmDelete,
        backgroundColor: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      );
    }
    return null;
  }

  /// Mostra um diálogo de confirmação para exclusão
  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Excluir produtos"),
          content: Text("Tem certeza que deseja excluir ${_selectedProducts.length} produto(s)?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                _deleteSelectedProducts();
                Navigator.pop(context);
              },
              child: const Text("Excluir", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  /// Exclui os produtos selecionados
  void _deleteSelectedProducts() {
    final productViewModel = context.read<ProductViewModel>();

    for (final productId in _selectedProducts) {
      final product = productViewModel.products.firstWhere((p) => p.id == productId);
      productViewModel.deleteProduct(product);
    }

    setState(() {
      _selectedProducts.clear();
    });
  }

}
