import 'package:flutter/foundation.dart';

import '../data/sample_data.dart';
import 'app_user.dart';
import 'cart.dart';
import 'menu_item.dart';
import 'order.dart';

/// Holds the app's shared state: user, cart, favourites, orders, address.
///
/// It's a singleton (only one instance ever exists): `AppStore()` always
/// returns the same object. It extends ChangeNotifier so the home screen can
/// listen and rebuild when something changes.
class AppStore extends ChangeNotifier {
  AppStore._internal();
  static final AppStore _instance = AppStore._internal();
  factory AppStore() => _instance;

  AppUser? user;
  final Cart cart = Cart();
  final Set<String> _favouriteIds = {};
  final List<Order> _orders = [];

  final List<String> savedAddresses = [
    'House 12, Street 5, Satellite Town, Rawalpindi',
    'Riphah International University, I-14, Islamabad',
  ];
  late String deliveryAddress = savedAddresses.first;

  // ---------- User ----------
  void setUser(AppUser? newUser) {
    user = newUser;
    notifyListeners();
  }

  // ---------- Cart ----------
  void addToCart(FoodItem item, {int quantity = 1}) {
    cart.add(item, quantity: quantity);
    notifyListeners();
  }

  void decreaseInCart(FoodItem item) {
    cart.decrease(item);
    notifyListeners();
  }

  void clearCart() {
    cart.clear();
    notifyListeners();
  }

  // ---------- Favourites ----------
  bool isFavourite(FoodItem item) => _favouriteIds.contains(item.id);

  void toggleFavourite(FoodItem item) {
    if (isFavourite(item)) {
      _favouriteIds.remove(item.id);
    } else {
      _favouriteIds.add(item.id);
    }
    notifyListeners();
  }

  List<FoodItem> get favourites =>
      foodItems.where((item) => _favouriteIds.contains(item.id)).toList();

  // ---------- Address ----------
  void setDeliveryAddress(String address) {
    if (!savedAddresses.contains(address)) {
      savedAddresses.add(address);
    }
    deliveryAddress = address;
    notifyListeners();
  }

  // ---------- Orders ----------
  List<Order> get activeOrders => _orders.where((o) => o.isActive).toList();
  List<Order> get pastOrders => _orders.where((o) => !o.isActive).toList();
  int get orderCount => _orders.length;

  /// Turns the cart into an order and empties the cart.
  Order placeOrder() {
    final order = Order(
      id: 'FE-${1001 + _orders.length}',
      lines: cart.lines
          .map((line) => CartLine(line.item, quantity: line.quantity))
          .toList(),
      total: cart.total,
      address: deliveryAddress,
      placedAt: DateTime.now(),
    );
    _orders.insert(0, order); // newest first
    cart.clear();
    notifyListeners();
    return order;
  }

  void advanceOrder(Order order) {
    order.advance();
    notifyListeners();
  }

  /// Called on logout.
  void reset() {
    user = null;
    cart.clear();
    _favouriteIds.clear();
    _orders.clear();
    notifyListeners();
  }
}
