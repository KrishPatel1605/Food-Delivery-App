
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order.dart';
import '../services/services_providers.dart';

final myOrdersProvider = StreamProvider<List<OrderModel>>((ref) {
  final service = ref.watch(orderServiceProvider);
  return service.myOrders();
});

final allOrdersProvider = StreamProvider<List<OrderModel>>((ref) {
  final service = ref.watch(orderServiceProvider);
  return service.allOrders();
});
