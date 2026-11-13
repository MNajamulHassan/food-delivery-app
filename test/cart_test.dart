import 'package:flutter_test/flutter_test.dart';
import 'package:food_delivery_app/models/cart.dart';
import 'package:food_delivery_app/models/menu_item.dart';

void main() {
  final burger = FoodItem(
    id: 't1',
    name: 'Test Burger',
    price: 500,
    category: FoodCategory.burger,
    description: 'test',
    ingredients: const ['bun'],
    rating: 4,
    prepMinutes: 10,
    restaurantName: 'Test Kitchen',
  );

  test('adding the same item twice increases quantity', () {
    final cart = Cart();
    cart.add(burger);
    cart.add(burger);
    expect(cart.lines.length, 1);
    expect(cart.itemCount, 2);
    expect(cart.subtotal, 1000);
  });

  test('delivery is charged below the free limit and free above it', () {
    final cart = Cart();
    cart.add(burger); // 500
    expect(cart.delivery, Cart.deliveryFee);
    cart.add(burger, quantity: 2); // 1500
    expect(cart.delivery, 0);
  });

  test('decreasing to zero removes the line', () {
    final cart = Cart();
    cart.add(burger);
    cart.decrease(burger);
    expect(cart.isEmpty, true);
  });

  test('price setter rejects negative values', () {
    expect(() => burger.price = -1, throwsArgumentError);
  });
}
