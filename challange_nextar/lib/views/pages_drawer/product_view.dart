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
      body: productViewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemCount: productViewModel.products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Dois itens por linha
                  crossAxisSpacing: 10, // Espaço horizontal entre os itens
                  mainAxisSpacing: 10, // Espaço vertical entre os itens
                  childAspectRatio: 0.65, // Proporção largura/altura
                ),
                itemBuilder: (context, index) {
                  final product = productViewModel.products[index];
                  return _buildProductCard(context, product);
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary2,
        onPressed: () {
          _showFilterDialog(context, productViewModel);
        },
        child: const Icon(Icons.filter_list),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem do Produto
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                child: Image.network(
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
              ),
            ),

            // Título do Produto
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
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
                    style: const TextStyle(fontSize: 13, color: Colors.black),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Text(
                    'em até 10x sem juros',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                ],
              ),
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
