import 'package:challange_nextar/components/app_bar_component.dart';
import 'package:challange_nextar/viewmodels/products_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelecetedProductView extends StatelessWidget {
  const SelecetedProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarComponente(
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
                leading: Image.network(product.images.first),
                title: Text(product.name),
                subtitle: Text('R\$ ${product.price}'),
                onTap: () {
                  Navigator.of(context).pop(product);
                },
              );
            },
          );
        },
      ),
    );
  }
}
