
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/cart_item.dart';
import '../models/order.dart';

class OrderService {
  final FirebaseFirestore _fs;
  final FirebaseAuth _auth;
  OrderService(this._fs, this._auth);

  Future<void> placeOrder({
    required String restaurantId,
    required List<CartItem> items,
    required double total,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    await _fs.collection('orders').add({
      'userId': user.uid,
      'restaurantId': restaurantId,
      'total': total,
      'items': items
          .map((e) => {
                'foodItemId': e.item.id,
                'name': e.item.name,
                'price': e.item.price,
                'quantity': e.quantity,
              })
          .toList(),
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<OrderModel>> myOrders() {
    final user = _auth.currentUser;
    if (user == null) {
      return const Stream.empty();
    }
    return _fs
        .collection('orders')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => OrderModel.fromDoc(d)).toList());
  }

  Stream<List<OrderModel>> allOrders() {
    return _fs
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => OrderModel.fromDoc(d)).toList());
  }

  Future<void> markComplete(String orderId) async {
    await _fs.collection('orders').doc(orderId).update({'status': 'completed'});
  }
}
