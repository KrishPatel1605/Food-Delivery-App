
import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant {
  final String id;
  final String name;
  final String imageUrl;
  final String cuisine;
  final double rating;

  Restaurant({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.cuisine,
    required this.rating,
  });

  factory Restaurant.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Restaurant(
      id: doc.id,
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      cuisine: data['cuisine'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
    );
  }
}
