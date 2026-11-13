import 'menu_item.dart';

/// One row in the cart: an item plus how many of it.
class CartLine {
  final FoodItem item;
  int quantity;

  CartLine(this.item, {this.quantity = 1});

  double get total => item.price * quantity;
}

/// The shopping cart. A single instance is created in main() and passed
/// to every page that needs it.
class Cart {
  static const double deliveryFee = 150;
  static const double freeDeliveryAbove = 1500;

  final List<CartLine> _lines = [];

  /// Read-only view so pages cannot change the list directly.
  List<CartLine> get lines => List.unmodifiable(_lines);

  bool get isEmpty => _lines.isEmpty;

  /// Total number of items (iteration with a for-in loop).
  int get itemCount {
    int count = 0;
    for (final line in _lines) {
      count += line.quantity;
    }
    return count;
  }

  double get subtotal {
    double sum = 0;
    for (final line in _lines) {
      sum += line.total;
    }
    return sum;
  }

  /// Delivery is free on big orders (if / else if / else).
  double get delivery {
    if (isEmpty) {
      return 0;
    } else if (subtotal >= freeDeliveryAbove) {
      return 0;
    } else {
      return deliveryFee;
    }
  }

  double get total => subtotal + delivery;

  /// Returns the line for an item, or null if it's not in the cart.
  CartLine? _findLine(FoodItem item) {
    for (final line in _lines) {
      if (line.item.id == item.id) return line;
    }
    return null;
  }

  int quantityOf(FoodItem item) => _findLine(item)?.quantity ?? 0;

  void add(FoodItem item, {int quantity = 1}) {
    if (quantity <= 0) return;
    final existing = _findLine(item);
    if (existing != null) {
      existing.quantity += quantity;
    } else {
      _lines.add(CartLine(item, quantity: quantity));
    }
  }

  void decrease(FoodItem item) {
    final existing = _findLine(item);
    if (existing == null) return;
    existing.quantity--;
    if (existing.quantity <= 0) {
      _lines.remove(existing);
    }
  }

  void remove(FoodItem item) {
    _lines.removeWhere((line) => line.item.id == item.id);
  }

  void clear() => _lines.clear();
}
