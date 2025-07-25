
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'order_service.dart';

final orderServiceProvider = Provider<OrderService>((ref) {
  return OrderService(FirebaseFirestore.instance, FirebaseAuth.instance);
});
