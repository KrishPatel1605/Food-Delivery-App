
import 'package:cloud_firestore/cloud_firestore.dart';

class FoodItem {
  final String id;
  final String restaurantId;
  final String name;
  final double price;
  final String imageUrl;

  FoodItem({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  factory FoodItem.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FoodItem(
      id: doc.id,
      restaurantId: data['restaurantId'] ?? '',
      name: data['name'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'restaurantId': restaurantId,
    'name': name,
    'price': price,
    'imageUrl': imageUrl,
  };
}
