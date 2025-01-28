import 'package:carousel_slider/carousel_slider.dart';
import 'package:challange_nextar/components/app_bar_component.dart';
import 'package:challange_nextar/models/product_model.dart';
import 'package:challange_nextar/routes/pages.dart';
import 'package:challange_nextar/utils/colors.dart';
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
    int stock = widget.product.stock;

    return Scaffold(
      
      appBar: AppBarComponente(
        isTitulo: widget.product.name,
        isVoltar: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.edit_rounded,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(
                context,
                Routes.editProduct,
                arguments: {
                  'product': widget.product,
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).padding.top - 10),
          child: Column( 
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: CarouselSlider.builder(
                  itemCount: widget.product.images.length,
                  itemBuilder: (context, index, realIndex) {
                    final imageUrl = widget.product.images[index];
                    return ClipRRect( 
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox( 
                        width: MediaQuery.of(context)
                            .size
                            .width, // Ocupa toda a largura disponível
                        child: Image.network( 
                          imageUrl,
                          fit: BoxFit.contain, // Garante que a imagem preencha todo o card
                          errorBuilder: (context, error, stackTrace) {
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
                    );
                  },
                  options: CarouselOptions(
                    height: 250, // Altura do carrossel
                
                    enableInfiniteScroll: true,
                    viewportFraction: 0.9,
                    enlargeCenterPage: true,
                    autoPlay: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                ),
              ),

              // Indicadores do carrossel
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.product.images.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: _currentIndex == index ? 16 : 8,
                    decoration: BoxDecoration(
                      color: _currentIndex == index
                          ? Colors.teal
                          : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Informações detalhadas
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration:   BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // Nome do produto
                    Text(
                      widget.product.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Informações rápidas
                    Text(
                      'A partir de',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.product.price,
                      style: const TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Avaliações
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber),
                        const SizedBox(width: 4),
                        const Text(
                          "5.0/5",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "(23 Reviews)",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    const Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 8),
                      child: Text(
                        'Descrição',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Text(
                      widget.product.description,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      stock > 0 ? 'Estoque disponível' : 'Estoque indisponível',
                      style: TextStyle(
                        color: stock > 0
                            ? AppColors.verdePadrao
                            : AppColors.vermelhoPadrao,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'Quantidade: ',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          widget.product.stock.toString(),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Botão de ação
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Função de iniciar receita
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Start Cooking",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
