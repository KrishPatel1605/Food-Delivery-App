
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/cart_provider.dart';
import '../services/services_providers.dart';
import 'order_success_screen.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final total = ref.watch(cartTotalProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: cart.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final c = cart[index];
                      return ListTile(
                        leading: c.item.imageUrl.isNotEmpty
                            ? Image.network(c.item.imageUrl, width: 56, height: 56, fit: BoxFit.cover)
                            : null,
                        title: Text(c.item.name),
                        subtitle: Text('₹ ${c.item.price.toStringAsFixed(2)} x ${c.quantity}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => ref.read(cartProvider.notifier).remove(c.item),
                            ),
                            Text('${c.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => ref.read(cartProvider.notifier).add(c.item),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => ref.read(cartProvider.notifier).removeCompletely(c.item),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Total: ₹ ${total.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      FilledButton(
                        onPressed: cart.isEmpty
                            ? null
                            : () async {
                                try {
                                  final orderService = ref.read(orderServiceProvider);
                                  final restaurantId = cart.first.item.restaurantId; // simplistic assumption
                                  await orderService.placeOrder(
                                    restaurantId: restaurantId,
                                    items: cart,
                                    total: total,
                                  );
                                  ref.read(cartProvider.notifier).clear();
                                  if (context.mounted) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (_) => const OrderSuccessScreen()),
                                    );
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                                }
                              },
                        child: const Text('Place Order'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
