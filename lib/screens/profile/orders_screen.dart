import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/firestore_service.dart';
import '../../services/auth_service.dart';
import '../../models/models.dart';
import '../../utils/theme.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final firestore = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: const Text("طلباتي")),
      body: StreamBuilder<List<OrderModel>>(
        stream: firestore.getUserOrders(auth.user?.uid ?? ""),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          if (snapshot.data!.isEmpty) return const Center(child: Text("لا توجد طلبات سابقة"));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final order = snapshot.data![index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  title: Text("طلب رقم: ${order.orderNumber}"),
                  subtitle: Text("التاريخ: ${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}"),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(_getStatusText(order.status), style: TextStyle(color: _getStatusColor(order.status), fontSize: 12)),
                  ),
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

  String _getStatusText(String status) {
    switch (status) {
      case 'pending': return "قيد الانتظار";
      case 'completed': return "تم التوصيل";
      case 'cancelled': return "ملغي";
      default: return status;
    }
  }
}
