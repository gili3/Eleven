import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String openId;
  final String? name;
  final String? email;
  final String? phone;
  final String role;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.openId,
    this.name,
    this.email,
    this.phone,
    required this.role,
    this.createdAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return UserModel(
      id: doc.id,
      openId: data['openId'] ?? '',
      name: data['name'],
      email: data['email'],
      phone: data['phone'],
      role: data['role'] ?? 'user',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final List<String> images;
  final String categoryId;
  final int stock;
  final bool isFeatured;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.images,
    required this.categoryId,
    required this.stock,
    this.isFeatured = false,
  });

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return ProductModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      originalPrice: (data['originalPrice'] as num?)?.toDouble(),
      images: List<String>.from(data['images'] ?? []),
      categoryId: data['categoryId'] ?? '',
      stock: data['stock'] ?? 0,
      isFeatured: data['isFeatured'] ?? false,
    );
  }
}

class CategoryModel {
  final String id;
  final String name;
  final String? image;

  CategoryModel({required this.id, required this.name, this.image});

  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return CategoryModel(
      id: doc.id,
      name: data['name'] ?? '',
      image: data['image'],
    );
  }
}

class OrderModel {
  final String id;
  final String orderNumber;
  final String userId;
  final List<dynamic> items;
  final double total;
  final String status;
  final String paymentStatus;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.userId,
    required this.items,
    required this.total,
    required this.status,
    required this.paymentStatus,
    required this.createdAt,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return OrderModel(
      id: doc.id,
      orderNumber: data['orderNumber'] ?? '',
      userId: data['userId'] ?? '',
      items: data['items'] ?? [],
      total: (data['total'] ?? 0).toDouble(),
      status: data['status'] ?? 'pending',
      paymentStatus: data['paymentStatus'] ?? 'unpaid',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
