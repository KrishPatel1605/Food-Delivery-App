
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/restaurant.dart';
import '../models/food_item.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final restaurantsProvider = StreamProvider<List<Restaurant>>((ref) {
  final fs = ref.watch(firestoreProvider);
  return fs.collection('restaurants').snapshots().map(
        (snap) => snap.docs.map((d) => Restaurant.fromDoc(d)).toList(),
      );
});

final foodItemsByRestaurantProvider = StreamProvider.family<List<FoodItem>, String>((ref, restaurantId) {
  final fs = ref.watch(firestoreProvider);
  return fs
      .collection('food_items')
      .where('restaurantId', isEqualTo: restaurantId)
      .snapshots()
      .map((snap) => snap.docs.map((d) => FoodItem.fromDoc(d)).toList());
});
