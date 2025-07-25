
import 'food_item.dart';

class CartItem {
  final FoodItem item;
  final int quantity;

  CartItem({required this.item, required this.quantity});

  CartItem copyWith({FoodItem? item, int? quantity}) =>
      CartItem(item: item ?? this.item, quantity: quantity ?? this.quantity);

  double get total => item.price * quantity;

  Map<String, dynamic> toJson() => {
        'item': item.toMap(),
        'quantity': quantity,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      item: FoodItem(
        id: json['item']['id'],
        restaurantId: json['item']['restaurantId'],
        name: json['item']['name'],
        price: (json['item']['price'] ?? 0).toDouble(),
        imageUrl: json['item']['imageUrl'] ?? '',
      ),
      quantity: json['quantity'] ?? 1,
    );
  }
}
