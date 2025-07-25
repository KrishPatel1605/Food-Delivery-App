
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String userId;
  final String restaurantId;
  final double total;
  final List<Map<String, dynamic>> items;
  final Timestamp? createdAt;
  final String status;

  OrderModel({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.total,
    required this.items,
    required this.createdAt,
    required this.status,
  });

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'restaurantId': restaurantId,
        'total': total,
        'items': items,
        'createdAt': createdAt,
        'status': status,
      };

  factory OrderModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      restaurantId: data['restaurantId'] ?? '',
      total: (data['total'] ?? 0).toDouble(),
      items: (data['items'] as List?)?.map((e) => Map<String, dynamic>.from(e)).toList() ?? [],
      createdAt: data['createdAt'],
      status: data['status'] ?? 'pending',
    );
  }
}
