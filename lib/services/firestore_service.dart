import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // جلب المنتجات
  Stream<List<ProductModel>> getProducts({bool? isFeatured}) {
    Query query = _db.collection('products');
    if (isFeatured != null) {
      query = query.where('isFeatured', isEqualTo: isFeatured);
    }
    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList());
  }

  // جلب التصنيفات
  Stream<List<CategoryModel>> getCategories() {
    return _db.collection('categories').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => CategoryModel.fromFirestore(doc)).toList());
  }

  // جلب البانرات
  Stream<List<Map<String, dynamic>>> getBanners() {
    return _db.collection('banners').where('isActive', isEqualTo: true).snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList());
  }

  // إنشاء طلب جديد
  Future<String> createOrder(Map<String, dynamic> orderData) async {
    DocumentReference docRef = await _db.collection('orders').add({
      ...orderData,
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'pending',
      'paymentStatus': 'unpaid',
    });
    return docRef.id;
  }

  // جلب طلبات المستخدم
  Stream<List<OrderModel>> getUserOrders(String userId) {
    return _db
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList());
  }
}
