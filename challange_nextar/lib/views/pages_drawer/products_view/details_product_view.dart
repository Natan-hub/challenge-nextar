import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:challange_nextar/core/widgets/app_bar_widget.dart';
import 'package:challange_nextar/core/widgets/botao_widget.dart';
import 'package:challange_nextar/models/product_model.dart';
import 'package:challange_nextar/routes/routes.dart';
import 'package:challange_nextar/core/theme/colors.dart';
import 'package:challange_nextar/core/theme/styles.dart';
import 'package:flutter/material.dart';

class DetailsProduct extends StatefulWidget {
  final ProductModel product;

  const DetailsProduct({
    super.key,
    required this.product,
  });

  @override
  State<DetailsProduct> createState() => _DetailsProductState();
}

class _DetailsProductState extends State<DetailsProduct> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        isTitulo: widget.product.name,
        isVoltar: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(
                context,
                Routes.editAddProduct,
                arguments: {'product': widget.product},
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildImageCarousel(),
            const SizedBox(height: 8),
            _buildCarouselIndicators(),
            const SizedBox(height: 8),
            _buildProductDetails(),
          ],
        ),
      ),
    );
  }

  /// 🔹 Constrói o carrossel de imagens do produto.
  Widget _buildImageCarousel() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      width: double.infinity,
      child: CarouselSlider.builder(
        itemCount: widget.product.images.length,
        itemBuilder: (context, index, realIndex) {
          final imageUrl = widget.product.images[index];
          return CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
            errorWidget: (context, url, error) => const Icon(
              Icons.error,
              color: AppColors.vermelhoPadrao,
            ),
          );
        },
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height * 0.5,
          viewportFraction: 1.0,
          enableInfiniteScroll: true,
          autoPlay: false,
          enlargeCenterPage: false,
          onPageChanged: (index, reason) {
            setState(() => _currentIndex = index);
          },
        ),
      ),
    );
  }

  /// 🔹 Constrói os indicadores do carrossel.
  Widget _buildCarouselIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.product.images.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: _currentIndex == index ? 16 : 8,
          decoration: BoxDecoration(
            color: _currentIndex == index ? Colors.teal : Colors.grey.shade400,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  /// 🔹 Constrói os detalhes do produto, incluindo nome, preço, avaliações e descrição.
  Widget _buildProductDetails() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          _buildProductName(),
          const SizedBox(height: 8),
          _buildPriceSection(),
          const SizedBox(height: 8),
          _buildReviewSection(),
          const SizedBox(height: 10),
          _buildDescription(),
          const SizedBox(height: 8),
          _buildStockInfo(),
          const SizedBox(height: 16),
          _buildPurchaseButton(),
        ],
      ),
    );
  }

  /// 🔹 Exibe o nome do produto.
  Widget _buildProductName() {
    return Text(
      widget.product.name,
      style: highlightedText(Colors.black),
    );
  }

  /// 🔹 Exibe a seção de preço.
  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('A partir de', style: subTextStyle()),
        const SizedBox(height: 5),
        Text('R\$ ${widget.product.price}',
            style: priceDetaildProductTextStyle()),
      ],
    );
  }

  /// 🔹 Exibe a seção de avaliações do produto.
  Widget _buildReviewSection() {
    return Row(
      children: [
        const Icon(Icons.star_rounded, color: Colors.amber),
        const SizedBox(width: 5),
        Text("5.0/5", style: normalTextStyleBold(Colors.black)),
        const SizedBox(width: 5),
        Text("(23 Reviews)", style: normalTextStyleBold(Colors.grey.shade600)),
      ],
    );
  }

  /// 🔹 Exibe a descrição do produto dentro de um card elevado.
  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 10),
          child: Text('Descrição', style: normalTextStyle(Colors.black)),
        ),
        Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.product.description,
              style: normalTextStyleDefault(Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  /// 🔹 Exibe informações sobre o estoque do produto.
  Widget _buildStockInfo() {
    int stock = widget.product.stock;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          stock > 0 ? 'Estoque disponível' : 'Estoque indisponível',
          style: normalTextStyleDefault(
            stock > 0 ? AppColors.verdePadrao : AppColors.vermelhoPadrao,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Text('Quantidade: ', style: normalTextStyleDefault(Colors.black)),
            Text(widget.product.stock.toString(),
                style: normalTextStyleBold(AppColors.primary)),
          ],
        ),
      ],
    );
  }

  /// 🔹 Constrói o botão de compra.
  Widget _buildPurchaseButton() {
    int stock = widget.product.stock;
    return SizedBox(
      width: double.infinity,
      child: DefaultButton(
        borderRadius: BorderRadius.circular(10),
        nomeBotao: stock > 0 ? 'Comprar' : 'Estoque indisponível',
        cor: AppColors.corBotao,
        padding: const EdgeInsets.fromLTRB(115, 20, 115, 20),
        onPressed: () {},
      ),
    );
  }
}
