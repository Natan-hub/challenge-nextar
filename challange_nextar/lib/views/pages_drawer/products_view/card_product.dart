import 'package:challange_nextar/core/theme/colors.dart';
import 'package:challange_nextar/core/theme/styles.dart';
import 'package:challange_nextar/models/product_model.dart';
import 'package:challange_nextar/routes/routes.dart';
import 'package:challange_nextar/viewmodels/products_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductCardWidget extends StatelessWidget {
  final ProductModel product;
  final ProductViewModel productViewModel;

  const ProductCardWidget({
    super.key,
    required this.product,
    required this.productViewModel,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected =
        productViewModel.selectedProducts.contains(product.id);

    return InkWell(
      onTap: () {
        if (!isSelected) {
          Navigator.pushNamed(
            context,
            Routes.detailsProduct,
            arguments: {'product': product},
          );
        }
      },
      onLongPress: () {
        if (productViewModel.selectionMode) {
          productViewModel.toggleProductSelection(product.id);
        } else {
          productViewModel.toggleSelectionMode();
          productViewModel.toggleProductSelection(product.id);
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: isSelected
              ? const BorderSide(color: AppColors.primary, width: 3)
              : BorderSide.none,
        ),
        elevation: 3,
        child: Stack(
          children: [
            IntrinsicHeight(
              child: Column(
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
                          CachedNetworkImage(
                            imageUrl: product.images.first,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Center(
                              child: SizedBox(
                                width: 40,
                                height: 40,
                                child: CircularProgressIndicator(
                                  value: downloadProgress.progress,
                                  strokeWidth: 3,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.error,
                              color: AppColors.vermelhoPadrao,
                            ),
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),

                          if (isSelected)
                            const Positioned(
                              top: 5,
                              right: 5,
                              child: Icon(
                                Icons.check_circle,
                                color: AppColors.primary,
                              ),
                            ),

                          // 📌Exibe a faixa de "Sem Estoque" se o estoque for 0
                          if (product.stock == 0)
                            Positioned(
                              top: 50,
                              left: 0,
                              right: 0,
                              child: Transform.rotate(
                                angle: -0.7,
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

                  // 📌Título do Produto
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

                  // 📌Informações adicionais
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 10),
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
            ),
          ],
        ),
      ),
    );
  }
}
