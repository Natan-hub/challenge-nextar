import 'package:challange_nextar/components/floatin_button_component.dart';
import 'package:challange_nextar/routes/pages.dart';
import 'package:challange_nextar/utils/colors.dart';
import 'package:challange_nextar/viewmodels/products_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductView extends StatelessWidget {
  const ProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final productViewModel = Provider.of<ProductViewModel>(context);

    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              productViewModel.hasMoreProducts &&
              !productViewModel.isLoading) {
            productViewModel.loadMoreProducts();
          }
          return false;
        },
        child: Consumer<ProductViewModel>(
            builder: (context, productViewModel, child) {
          return Column(
            children: [
              Expanded(
                child: productViewModel.isLoading &&
                        productViewModel.products.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          itemCount: productViewModel.products.length +
                              (productViewModel.hasMoreProducts ? 1 : 0),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.65,
                          ),
                          itemBuilder: (context, index) {
                            if (index == productViewModel.products.length) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            final product = productViewModel.products[index];
                            return _buildProductCard(context, product);
                          },
                        ),
                      ),
              ),
            ],
          );
        }),
      ),
      floatingActionButton: FabMenuButton(
        onPressed: () {
          _showFilterDialog(context, productViewModel);
        },
        onPressed2: () async {
          // Adiciona um produto e notifica ao voltar
          await Navigator.pushNamed(
            context,
            Routes.editProduct,
          );
        },
      ),
    );
  }

  Widget _buildProductCard(context, product) {
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
                // Imagem do Produto com sobreposição para "Sem Estoque"
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
                                child: const Text(
                                  'SEM ESTOQUE',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),

                // Informações adicionais
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'R\$ ${product.price}', // Pode ser dinâmico se os dados forem fornecidos
                        style:
                            const TextStyle(fontSize: 13, color: Colors.black),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'em até 10x sem juros',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context, ProductViewModel viewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filtrar Produtos'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  Icons.date_range,
                  color: viewModel.selectedFilter == 'Mais recente'
                      ? Colors.blue
                      : Colors.black,
                ),
                title: Text(
                  'Mais recente',
                  style: TextStyle(
                    color: viewModel.selectedFilter == 'Mais recente'
                        ? Colors.blue
                        : Colors.black,
                  ),
                ),
                onTap: () {
                  viewModel.applyFilter('Mais recente');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.date_range,
                  color: viewModel.selectedFilter == 'Mais antigo'
                      ? Colors.blue
                      : Colors.black,
                ),
                title: Text(
                  'Mais antigo',
                  style: TextStyle(
                    color: viewModel.selectedFilter == 'Mais antigo'
                        ? Colors.blue
                        : Colors.black,
                  ),
                ),
                onTap: () {
                  viewModel.applyFilter('Mais antigo');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.attach_money,
                  color: viewModel.selectedFilter == 'Preço: Mais barato'
                      ? Colors.blue
                      : Colors.black,
                ),
                title: Text(
                  'Preço: Mais barato',
                  style: TextStyle(
                    color: viewModel.selectedFilter == 'Preço: Mais barato'
                        ? Colors.blue
                        : Colors.black,
                  ),
                ),
                onTap: () {
                  viewModel.applyFilter('Preço: Mais barato');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.sort_by_alpha,
                  color: viewModel.selectedFilter == 'Ordem Alfabética'
                      ? Colors.blue
                      : Colors.black,
                ),
                title: Text(
                  'Ordem Alfabética',
                  style: TextStyle(
                    color: viewModel.selectedFilter == 'Ordem Alfabética'
                        ? Colors.blue
                        : Colors.black,
                  ),
                ),
                onTap: () {
                  viewModel.applyFilter('Ordem Alfabética');
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
