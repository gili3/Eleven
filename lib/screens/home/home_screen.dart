import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../services/firestore_service.dart';
import '../../models/models.dart';
import '../../utils/theme.dart';
import '../product/product_detail_screen.dart';
import '../cart/cart_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestore = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Eleven Store"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "ابحث عن منتجات...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                ),
              ),
            ),
            // 1. Hero Banners
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: firestore.getBanners(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox(height: 200);
                return CarouselSlider(
                  options: CarouselOptions(height: 200, autoPlay: true, viewportFraction: 0.9, enlargeCenterPage: true),
                  items: snapshot.data!.map((banner) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(image: NetworkImage(banner['image']), fit: BoxFit.cover),
                      ),
                    );
                  }).toList(),
                );
              },
            ),

            // 2. Categories
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("التصنيفات", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 100,
              child: StreamBuilder<List<CategoryModel>>(
                stream: firestore.getCategories(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final cat = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          children: [
                            CircleAvatar(radius: 30, backgroundImage: cat.image != null ? NetworkImage(cat.image!) : null),
                            const SizedBox(height: 8),
                            Text(cat.name, style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // 3. Featured Products
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("منتجات مميزة", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            StreamBuilder<List<ProductModel>>(
              stream: firestore.getProducts(isFeatured: true),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final product = snapshot.data![index];
                    return GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product))),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: CachedNetworkImage(
                                imageUrl: product.images[0],
                                width: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(color: Colors.grey[200]),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text("${product.price} SDG", style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
