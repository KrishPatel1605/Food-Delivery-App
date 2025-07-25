
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/restaurant.dart';
import '../providers/restaurant_provider.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';

class RestaurantDetailScreen extends ConsumerWidget {
  final Restaurant restaurant;
  const RestaurantDetailScreen({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foodListAsync = ref.watch(foodItemsByRestaurantProvider(restaurant.id));
    final cartCount = ref.watch(cartCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.name),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
                icon: const Icon(Icons.shopping_cart),
              ),
              if (cartCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      cartCount.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: foodListAsync.when(
        data: (foods) => ListView.builder(
          itemCount: foods.length,
          itemBuilder: (context, index) {
            final f = foods[index];
            return Card(
              margin: const EdgeInsets.all(12),
              child: ListTile(
                leading: f.imageUrl.isNotEmpty ? Image.network(f.imageUrl, width: 56, height: 56, fit: BoxFit.cover) : null,
                title: Text(f.name),
                subtitle: Text('₹ ${f.price.toStringAsFixed(2)}'),
                trailing: FilledButton(
                  onPressed: () => ref.read(cartProvider.notifier).add(f),
                  child: const Text('Add'),
                ),
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
