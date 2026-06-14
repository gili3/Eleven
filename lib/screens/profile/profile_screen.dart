import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../utils/theme.dart';
import 'orders_screen.dart';
import 'contact_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(title: const Text("الملف الشخصي")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppTheme.primaryColor,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(user?.displayName ?? "مستخدم", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(user?.email ?? user?.phoneNumber ?? "", style: const TextStyle(color: AppTheme.mutedTextColor)),
            const SizedBox(height: 32),
            
            _buildProfileItem(Icons.shopping_bag_outlined, "طلباتي", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrdersScreen()))),
            _buildProfileItem(Icons.location_on_outlined, "عناويني", () {}),
            _buildProfileItem(Icons.favorite_border, "المفضلة", () {}),
            _buildProfileItem(Icons.contact_support_outlined, "اتصل بنا", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactScreen()))),
            _buildProfileItem(Icons.settings_outlined, "الإعدادات", () {}),
            const Divider(),
            _buildProfileItem(Icons.logout, "تسجيل الخروج", () => auth.signOut(), isDestructive: true),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? Colors.red : AppTheme.primaryColor),
      title: Text(title, style: TextStyle(color: isDestructive ? Colors.red : AppTheme.textColor)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
