import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../services/cart_provider.dart';
import '../../services/firestore_service.dart';
import '../../services/auth_service.dart';
import '../../utils/theme.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _addressController = TextEditingController();
  String _deliveryType = 'delivery'; // or 'pickup'
  bool _isProcessing = false;
  File? _receiptImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _receiptImage = File(pickedFile.path));
    }
  }

  void _submitOrder() async {
    setState(() => _isProcessing = true);
    final cart = Provider.of<CartProvider>(context, listen: false);
    final auth = Provider.of<AuthService>(context, listen: false);
    final firestore = FirestoreService();

    try {
      final orderData = {
        'userId': auth.user?.uid,
        'items': cart.items.values.map((item) => {
          'productId': item.product.id,
          'name': item.product.name,
          'price': item.product.price,
          'quantity': item.quantity,
        }).toList(),
        'total': cart.totalAmount,
        'address': _addressController.text,
        'deliveryType': _deliveryType,
        'orderNumber': "ORD-${DateTime.now().millisecondsSinceEpoch}",
      };

      await firestore.createOrder(orderData);
      cart.clearCart();
      
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("تم الطلب بنجاح"),
          content: const Text("تم استلام طلبك وسنقوم بالتواصل معك قريباً."),
          actions: [TextButton(onPressed: () => Navigator.popUntil(context, (route) => route.isFirst), child: const Text("موافق"))],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("فشل إرسال الطلب")));
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("إتمام الدفع")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("معلومات التوصيل", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: "العنوان بالتفصيل (المدينة، الحي، الشارع)", hintText: "مثلاً: الخرطوم، المعمورة، شارع الستين"),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            const Text("طريقة الاستلام", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            RadioListTile(
              title: const Text("توصيل للمنزل"),
              value: 'delivery',
              groupValue: _deliveryType,
              onChanged: (val) => setState(() => _deliveryType = val.toString()),
            ),
            RadioListTile(
              title: const Text("استلام من الفرع"),
              value: 'pickup',
              groupValue: _deliveryType,
              onChanged: (val) => setState(() => _deliveryType = val.toString()),
            ),
            const SizedBox(height: 32),
            const Text("طريقة الدفع", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const ListTile(
              leading: Icon(Icons.account_balance_wallet_outlined, color: AppTheme.primaryColor),
              title: Text("تحويل بنكي (بنكك / فوري)"),
              subtitle: Text("يرجى إرفاق صورة إيصال التحويل"),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: _receiptImage == null
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Icon(Icons.add_a_photo_outlined, size: 40, color: Colors.grey), Text("اضغط لإضافة صورة الإيصال")],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(_receiptImage!, fit: BoxFit.cover),
                      ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _submitOrder,
                child: _isProcessing ? const CircularProgressIndicator(color: Colors.white) : const Text("تأكيد الطلب الآن"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
