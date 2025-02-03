import 'package:challange_nextar/core/widgets/floatin_button_widget.dart';
import 'package:challange_nextar/core/widgets/flush_bar_widget.dart';
import 'package:challange_nextar/core/widgets/native_dialog_widget.dart';
import 'package:challange_nextar/core/widgets/shimmer_loading_widget.dart';
import 'package:challange_nextar/routes/routes.dart';
import 'package:challange_nextar/core/theme/colors.dart';
import 'package:challange_nextar/core/theme/images.dart';
import 'package:challange_nextar/core/theme/styles.dart';
import 'package:challange_nextar/viewmodels/products_viewmodel.dart';
import 'package:challange_nextar/views/pages_drawer/products_view/card_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  late ProductViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = context.read<ProductViewModel>();

    viewModel.addListener(() {
      if (viewModel.successMessage != null) {
        FlushBarWidget.mostrar(
          context,
          viewModel.successMessage!,
          Icons.check_circle_rounded,
          AppColors.verdePadrao,
        );
      }

      if (viewModel.errorMessage != null) {
        FlushBarWidget.mostrar(
          context,
          viewModel.errorMessage!,
          Icons.warning_amber,
          AppColors.vermelhoPadrao,
        );
      }

      if (viewModel.shouldCloseDialog) {
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    viewModel.removeListener(() {});
    super.dispose();
  }

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
                  !productViewModel.isLoadingMore) {
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
            onPressed3: productViewModel.selectedProducts.isNotEmpty
                ? () => _confirmDelete(context, productViewModel)
                : () => _warningSelect(context),
          );
        },
      ),
    );
  }

  /// 📌Constrói o corpo principal da tela
  Widget _buildBody(ProductViewModel productViewModel) {
    if (productViewModel.isLoading) {
      return Center(child: shimerColor(context));
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
            return productViewModel.isLoadingMore
                ? const Center(child: CircularProgressIndicator())
                : const SizedBox.shrink();
          }

          final product = productViewModel.products[index];
          return ProductCardWidget(
            product: product,
            productViewModel: productViewModel,
          );
        },
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
            "Nenhum produto criado, \nclique no botão inferior direito e adicione.",
            style: principalTextStyle(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// Exibe um alerta de confirmação para excluir os produtos selecionados
  void _confirmDelete(BuildContext context, ProductViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Excluir produtos?"),
        content: const Text(
            "Tem certeza que deseja excluir os produtos selecionados?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar")),
          TextButton(
            onPressed: () {
              viewModel.deleteSelectedProducts();
            },
            child: const Text("Excluir", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _warningSelect(BuildContext context) {
    NativeDialog.showAlert(
      context: context,
      title: "Aviso!",
      message: 'Você deve selecionar um produto antes.',
      confirmButtonText: "Ok",
    );
  }
}
