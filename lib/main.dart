import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'utils/theme.dart';
import 'services/auth_service.dart';
import 'services/cart_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // تهيئة Firebase
  // ملاحظة: ستحتاج لملفات google-services.json ليعمل هذا الكود على جهازك
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print("Firebase initialization skipped: $e");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const ElevenStoreApp(),
    ),
  );
}

class ElevenStoreApp extends StatelessWidget {
  const ElevenStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eleven Store',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      
      // دعم اللغة العربية والـ RTL
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'SD'), // العربية (السودان)
      ],
      locale: const Locale('ar', 'SD'),
      
      // التوجيه التلقائي بناءً على حالة تسجيل الدخول
      home: Consumer<AuthService>(
        builder: (context, auth, _) {
          if (auth.isAuthenticated) {
            return const HomeScreen();
          }
          return const LoginScreen();
        },
      ),
    );
  }
}
