import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? _user;
  User? get user => _user;
  bool get isAuthenticated => _user != null;

  AuthService() {
    _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  // تسجيل الدخول بـ Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      await _updateUserData(userCredential.user!);
      return userCredential;
    } catch (e) {
      print("Google Sign-In Error: $e");
      rethrow;
    }
  }

  // تسجيل الدخول برقم الهاتف (سوداني)
  Future<void> verifyPhone(String phone, {
    required Function(String) onCodeSent,
    required Function(FirebaseAuthException) onFailed,
  }) async {
    // تحويل الرقم للصيغة الدولية
    String formattedPhone = phone;
    if (phone.startsWith('0')) {
      formattedPhone = '+249' + phone.substring(1);
    }

    await _auth.verifyPhoneNumber(
      phoneNumber: formattedPhone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: onFailed,
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> signInWithOTP(String verificationId, String smsCode) async {
    AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    final UserCredential userCredential = await _auth.signInWithCredential(credential);
    await _updateUserData(userCredential.user!);
  }

  // تحديث بيانات المستخدم في Firestore
  Future<void> _updateUserData(User user) async {
    DocumentReference userRef = _db.collection('users').doc(user.uid);
    await userRef.set({
      'openId': user.uid,
      'email': user.email,
      'name': user.displayName,
      'lastSignedIn': FieldValue.serverTimestamp(),
      'role': 'user', // افتراضي
    }, SetOptions(merge: true));
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
