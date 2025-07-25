
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/order_providers.dart';
import '../services/services_providers.dart';

class AdminOrdersScreen extends ConsumerWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(allOrdersProvider);
    final orderService = ref.watch(orderServiceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('All Orders (Admin)')),
      body: ordersAsync.when(
        data: (orders) => orders.isEmpty
            ? const Center(child: Text('No orders'))
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
                      subtitle: Text('User: ${o.userId}$dateStr'),
                      isThreeLine: true,
                      trailing: o.status == 'completed'
                          ? const Icon(Icons.check, color: Colors.green)
                          : FilledButton.tonal(
                              onPressed: () async {
                                await orderService.markComplete(o.id);
                              },
                              child: const Text('Mark complete'),
                            ),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (_) => _AdminOrderDetailSheet(order: o.items),
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

class _AdminOrderDetailSheet extends StatelessWidget {
  final List<Map<String, dynamic>> order;
  const _AdminOrderDetailSheet({required this.order});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Order Items', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
