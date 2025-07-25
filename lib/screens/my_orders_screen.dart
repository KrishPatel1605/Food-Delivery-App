
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/order_providers.dart';

class MyOrdersScreen extends ConsumerWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(myOrdersProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: ordersAsync.when(
        data: (orders) => orders.isEmpty
            ? const Center(child: Text('No orders yet'))
            : ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final o = orders[index];
                  final created = o.createdAt?.toDate();
                  final dateStr =
                      created != null ? DateFormat('dd MMM yyyy, hh:mm a').format(created) : '-';
                  return Card(
                    margin: const EdgeInsets.all(12),
                    child: ListTile(
                      title: Text('₹ ${o.total.toStringAsFixed(2)} • ${o.status.toUpperCase()}'),
                      subtitle: Text(dateStr),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (_) => _OrderItemsSheet(order: o.items),
                        );
                      },
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _OrderItemsSheet extends StatelessWidget {
  final List<Map<String, dynamic>> order;
  const _OrderItemsSheet({required this.order});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Items', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...order.map((e) => ListTile(
                  title: Text(e['name'] ?? ''),
                  subtitle:
                      Text('₹ ${(e['price'] ?? 0).toStringAsFixed(2)} x ${e['quantity'] ?? 1}'),
                )),
          ],
        ),
      ),
    );
  }
}
