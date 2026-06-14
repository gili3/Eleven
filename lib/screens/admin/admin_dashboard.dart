import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../utils/theme.dart';
import '../../models/models.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("لوحة تحكم المدير")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          
          final orders = snapshot.data!.docs;
          
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final data = order.data() as Map<String, dynamic>;
              
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text("طلب رقم: ${data['orderNumber']}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("الإجمالي: ${data['total']} SDG"),
                      Text("الحالة: ${data['status']}", style: TextStyle(color: _getStatusColor(data['status']))),
                    ],
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showOrderDetails(context, order.id, data),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending': return Colors.orange;
      case 'completed': return Colors.green;
      case 'cancelled': return Colors.red;
      default: return Colors.grey;
    }
  }

  void _showOrderDetails(BuildContext context, String orderId, Map<String, dynamic> data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("تفاصيل الطلب", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Divider(),
            Text("العنوان: ${data['address']}"),
            const SizedBox(height: 16),
            const Text("المنتجات:"),
            ...(data['items'] as List).map((item) => Text("- ${item['name']} (x${item['quantity']})")),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      FirebaseFirestore.instance.collection('orders').doc(orderId).update({'status': 'completed'});
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text("إكمال الطلب"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      FirebaseFirestore.instance.collection('orders').doc(orderId).update({'status': 'cancelled'});
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text("إلغاء الطلب"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
