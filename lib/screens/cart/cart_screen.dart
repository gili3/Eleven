import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/cart_provider.dart';
import '../../utils/theme.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final cartItems = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(title: const Text("سلة المشتريات")),
      body: cart.itemCount == 0
          ? const Center(child: Text("السلة فارغة حالياً"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return ListTile(
                        leading: Image.network(item.product.images[0], width: 50, height: 50, fit: BoxFit.cover),
                        title: Text(item.product.name),
                        subtitle: Text("${item.product.price} SDG"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.remove), onPressed: () => cart.decrementItem(item.product.id)),
                            Text("${item.quantity}"),
                            IconButton(icon: const Icon(Icons.add), onPressed: () => cart.addItem(item.product)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.between,
                        children: [
                          const Text("الإجمالي:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text("${cart.totalAmount} SDG", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutScreen())),
                          child: const Text("إتمام الطلب"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
