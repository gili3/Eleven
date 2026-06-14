import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/theme.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("اتصل بنا")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text("11", style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
            ),
            const SizedBox(height: 32),
            const Text("Eleven Store - متجر إيليفن", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text("نحن هنا لخدمتكم وتوفير أفضل المنتجات بأعلى جودة وأفضل الأسعار في السودان."),
            const SizedBox(height: 32),
            _buildContactItem(Icons.phone, "رقم الهاتف", "+249 912 345 678", () => launchUrl(Uri.parse("tel:+249912345678"))),
            _buildContactItem(Icons.email, "البريد الإلكتروني", "support@elevenstore.com", () => launchUrl(Uri.parse("mailto:support@elevenstore.com"))),
            _buildContactItem(Icons.location_on, "الموقع", "الخرطوم، السودان", null),
            const Spacer(),
            const Center(child: Text("إصدار التطبيق 1.0.0", style: TextStyle(color: Colors.grey))),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String title, String value, VoidCallback? onTap) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value),
      onTap: onTap,
    );
  }
}
