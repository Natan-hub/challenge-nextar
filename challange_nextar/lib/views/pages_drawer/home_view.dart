import 'package:challange_nextar/models/home_model.dart';
import 'package:challange_nextar/routes/pages.dart';
import 'package:challange_nextar/utils/colors.dart';
import 'package:challange_nextar/utils/images.dart';
import 'package:challange_nextar/viewmodels/home_viewmodel.dart';
import 'package:challange_nextar/viewmodels/login_viewmodel.dart';
import 'package:challange_nextar/viewmodels/products_viewmodel.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseView extends StatelessWidget {
  const BaseView({super.key});

  @override
  Widget build(BuildContext context) {
    // Acessa o LoginViewModel para obter os dados do usuário
    final loginViewModel = Provider.of<LoginViewModel>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Bem-vindo(a) a sua loja ${loginViewModel.dataUser?.name ?? 'Erro ao acessar o nome da conta'}",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
              bannerCard(context),
              Consumer<HomeViewModel>(
                builder: (_, homeManager, __) {
                  final List<Widget> children =
                      homeManager.sections.map<Widget>((section) {
                    switch (section.type) {
                      case 'List':
                        return sectionList(context, section);
                      case 'Staggered':
                        return sectionStaggered(context, section);
                      default:
                        return Container();
                    }
                  }).toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: children,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bannerCard(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 170, 255),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Imagem alinhada à esquerda
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Image.asset(
              AppImages.modeloRoupa, // Substitua pelo caminho da sua imagem
              fit: BoxFit.cover,
              width: 150, // Largura da imagem
              height: double.infinity,
            ),
          ),
          // Texto e botão alinhados à direita
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Escolha as melhores roupas para levar para sua casa.',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0, // Remove a sombra do botão
                    ),
                    child: const Text('Explore'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionList(BuildContext context, HomeModel section) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            section.name,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
          SizedBox(
            height: 150,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) {
                final item =
                    section.items[index]; // Obtenha o objeto HomeItem atual
                return AspectRatio(
                  aspectRatio: 1,
                  child: InkWell(
                    onTap: () {
                      if (item.product != null) {
                        final product = context
                            .read<ProductViewModel>()
                            .findProductById(item.product!);
                        if (product != null) {
                          Navigator.pushNamed(
                            context,
                            Routes.detailsProduct,
                            arguments: {
                              'product': product,
                            },
                          );
                        }
                      }
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: FadeInImage.memoryNetwork(
                          image: item
                              .image, // Acesse o campo 'image' do objeto HomeItem
                          fit: BoxFit.cover,
                          placeholder: kTransparentImage,
                          imageErrorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 50,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(
                width: 4,
              ),
              itemCount: section.items.length,
            ),
          )
        ],
      ),
    );
  }

  Widget sectionStaggered(BuildContext context, HomeModel section) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            section.name,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
          GridView.custom(
            padding: const EdgeInsets.all(8),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverQuiltedGridDelegate(
              crossAxisCount: 4, // Quantidade de colunas
              mainAxisSpacing: 4, // Espaço entre linhas
              crossAxisSpacing: 4, // Espaço entre colunas
              pattern: const [
                QuiltedGridTile(2, 2),
                QuiltedGridTile(1, 2),
                QuiltedGridTile(1, 1),
                QuiltedGridTile(1, 1),
                QuiltedGridTile(2, 4),
              ],
            ),
            childrenDelegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index >= section.items.length) return null;
                final item = section.items[index];
                return InkWell(
                  onTap: () {
                    if (item.product != null) {
                      final product = context
                          .read<ProductViewModel>()
                          .findProductById(item.product!);
                      if (product != null) {
                        Navigator.of(context).pushNamed(
                          Routes.detailsProduct,
                          arguments: {
                            'product': product,
                          },
                        );
                      }
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: FadeInImage.memoryNetwork(
                        image: item
                            .image, // Acesse o campo 'image' do objeto HomeItem
                        fit: BoxFit.cover,
                        placeholder: kTransparentImage,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
              childCount: section.items.length,
            ),
          ),
        ],
      ),
    );
  }
}
