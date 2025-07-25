
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_item.dart';
import '../models/food_item.dart';
import 'auth_providers.dart';

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);
  return CartNotifier(prefs);
});

final cartTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0.0, (sum, item) => sum + item.total);
});

final cartCountProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0, (sum, item) => sum + item.quantity);
});

class CartNotifier extends StateNotifier<List<CartItem>> {
  static const _prefsKey = 'cart_items';
  final SharedPreferences _prefs;

  CartNotifier(this._prefs) : super([]) {
    _load();
  }

  void _load() {
    final jsonStr = _prefs.getString(_prefsKey);
    if (jsonStr != null) {
      final list = (json.decode(jsonStr) as List)
          .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList();
      state = list;
    }
  }

  void _save() {
    final list = state.map((e) => e.toJson()).toList();
    _prefs.setString(_prefsKey, json.encode(list));
  }

  void add(FoodItem item) {
    final idx = state.indexWhere((e) => e.item.id == item.id);
    if (idx == -1) {
      state = [...state, CartItem(item: item, quantity: 1)];
    } else {
      final old = state[idx];
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == idx) old.copyWith(quantity: old.quantity + 1) else state[i]
      ];
    }
    _save();
  }

  void remove(FoodItem item) {
    final idx = state.indexWhere((e) => e.item.id == item.id);
    if (idx != -1) {
      final old = state[idx];
      if (old.quantity == 1) {
        state = [
          for (int i = 0; i < state.length; i++)
            if (i != idx) state[i]
        ];
      } else {
        state = [
          for (int i = 0; i < state.length; i++)
            if (i == idx) old.copyWith(quantity: old.quantity - 1) else state[i]
        ];
      }
      _save();
    }
  }

  void removeCompletely(FoodItem item) {
    state = state.where((e) => e.item.id != item.id).toList();
    _save();
  }

  void clear() {
    state = [];
    _prefs.remove(_prefsKey);
  }
}
