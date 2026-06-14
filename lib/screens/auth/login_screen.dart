import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../utils/theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isOTPSent = false;
  String? _verificationId;
  bool _isLoading = false;
  bool _obscurePassword = true;

  void _handlePhoneLogin() async {
    if (_passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("يرجى إدخال كلمة المرور")));
      return;
    }

    final auth = Provider.of<AuthService>(context, listen: false);
    setState(() => _isLoading = true);
    
    try {
      if (!_isOTPSent) {
        await auth.verifyPhone(
          _phoneController.text,
          onCodeSent: (id) {
            setState(() {
              _verificationId = id;
              _isOTPSent = true;
              _isLoading = false;
            });
          },
          onFailed: (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? "فشل التحقق")));
            setState(() => _isLoading = false);
          },
        );
      } else {
        await auth.signInWithOTP(_verificationId!, _otpController.text);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                  ),
                  child: const Center(
                    child: Text("11", style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text("Eleven Store", textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              
              if (!_isOTPSent) ...[
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  textAlign: TextAlign.right,
                  decoration: const InputDecoration(
                    hintText: "09XXXXXXXX أو 01XXXXXXXX",
                    prefixIcon: Icon(Icons.phone),
                    labelText: "رقم الهاتف السوداني",
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    labelText: "كلمة المرور",
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                ),
              ] else ...[
                const Text("أدخل رمز التحقق المرسل لهاتفك", textAlign: TextAlign.center),
                const SizedBox(height: 16),
                TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    hintText: "رمز التحقق (OTP)",
                    labelText: "رمز OTP",
                  ),
                ),
              ],
              
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _handlePhoneLogin,
                child: _isLoading 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                  : Text(_isOTPSent ? "تحقق ودخول" : "تسجيل الدخول"),
              ),
              
              const SizedBox(height: 32),
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text("أو")),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 32),
              
              OutlinedButton.icon(
                onPressed: () => Provider.of<AuthService>(context, listen: false).signInWithGoogle(),
                icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red),
                label: const Text("الدخول عبر Google"),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.email_outlined),
                label: const Text("الدخول عبر البريد الإلكتروني"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
