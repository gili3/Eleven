import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/models.dart';
import '../../utils/theme.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Images
            SizedBox(
              height: 300,
              width: double.infinity,
              child: PageView.builder(
                itemCount: product.images.length,
                itemBuilder: (context, index) => Image.network(product.images[index], fit: BoxFit.cover),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.between,
                    children: [
                      Text("${product.price} SDG", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.share_outlined),
                            onPressed: () => Share.share("تحقق من هذا المنتج الرائع في Eleven Store: ${product.name}"),
                          ),
                          IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // WhatsApp Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final url = "https://wa.me/249912345678?text=أريد الاستفسار عن منتج: ${product.name}";
                        if (await canLaunchUrl(Uri.parse(url))) await launchUrl(Uri.parse(url));
                      },
                      icon: const Icon(Icons.whatsapp, color: Colors.green),
                      label: const Text("استفسار عبر واتساب", style: TextStyle(color: Colors.green)),
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.green)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(product.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(product.description, style: const TextStyle(fontSize: 16, color: AppTheme.mutedTextColor)),
                  const SizedBox(height: 24),
                  
                  // Delivery Info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
                    child: const Row(
                      children: [
                        Icon(Icons.local_shipping_outlined, color: AppTheme.primaryColor),
                        SizedBox(width: 12),
                        Text("توصيل سريع لجميع ولايات السودان"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                child: const Text("أضف للسلة"),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("اشتري الآن"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
