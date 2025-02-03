import 'package:cached_network_image/cached_network_image.dart';
import 'package:challange_nextar/core/widgets/app_bar_widget.dart';
import 'package:challange_nextar/core/widgets/flush_bar_widget.dart';
import 'package:challange_nextar/core/theme/colors.dart';
import 'package:challange_nextar/core/theme/styles.dart';
import 'package:challange_nextar/viewmodels/products_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelecetedProductView extends StatelessWidget {
  const SelecetedProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        isTitulo: 'Vincular Produto',
        isVoltar: true,
      ),
      backgroundColor: Colors.white,
      body: Consumer<ProductViewModel>(
        builder: (_, productManager, __) {
          return ListView.builder(
            itemCount: productManager.products.length,
            itemBuilder: (_, index) {
              final product = productManager.products[index];
              return ListTile(
                leading: CachedNetworkImage(
                  imageUrl: product.images.first,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                    value: downloadProgress.progress,
                    color: AppColors.primary,
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.error,
                    color: AppColors.vermelhoPadrao,
                  ),
                ),
                title: Text(
                  product.name,
                  style: normalTextStyleDefault(
                    Colors.black,
                  ),
                ),
                subtitle: Text(
                  'R\$ ${product.price}',
                  style: normalTextStyleDefault(
                    Colors.grey,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop(product);
                  FlushBarWidget.mostrar(
                    context,
                    'Produto vinculado',
                    Icons.check_circle_rounded,
                    AppColors.verdePadrao,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
