import 'package:carousel_slider/carousel_slider.dart';
import 'package:challange_nextar/components/app_bar_component.dart';
import 'package:challange_nextar/models/product_model.dart';
import 'package:flutter/material.dart';

class DetailsProduct extends StatelessWidget {
  final ProductModel product;

  const DetailsProduct({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponente(
        isTitulo: product.name,
        isVoltar: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Carrossel de imagens
            CarouselSlider.builder(
              itemCount: product.images.length,
              itemBuilder: (context, index, realIndex) {
                final imageUrl = product.images[index];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
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
                );
              },
              options: CarouselOptions(
                height: 250,
                enableInfiniteScroll: true,
                enlargeCenterPage: true,
                autoPlay: false,
              ),
            ),

            // Informações detalhadas
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
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
                    product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Informações rápidas
                  Row(
                    children: const [
                      Icon(Icons.local_fire_department, size: 18),
                      SizedBox(width: 4),
                      Text("120 Cal"),
                      SizedBox(width: 16),
                      Icon(Icons.timer, size: 18),
                      SizedBox(width: 4),
                      Text("15 Min"),
                    ],
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
                  const SizedBox(height: 16),

                  // Ingredientes
                  const Text(
                    "Ingredients",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Lista de Ingredientes (Exemplo estático)
                  Column(
                    children: [
                      _buildIngredientRow("Noodles", "400g"),
                      _buildIngredientRow("Egg", "360g"),
                      _buildIngredientRow("Meat & Vegetables", "300g"),
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
    );
  }

  // Widget para linha de ingredientes
  Widget _buildIngredientRow(String name, String quantity) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            quantity,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
