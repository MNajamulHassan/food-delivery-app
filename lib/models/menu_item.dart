/// Food categories shown as filter chips on the home page.
enum FoodCategory { burger, pizza, desi, drinks, dessert }

/// Returns a readable label for a category (selection statement: switch).
String categoryLabel(FoodCategory category) {
  switch (category) {
    case FoodCategory.burger:
      return 'Burgers';
    case FoodCategory.pizza:
      return 'Pizza';
    case FoodCategory.desi:
      return 'Desi';
    case FoodCategory.drinks:
      return 'Drinks';
    case FoodCategory.dessert:
      return 'Desserts';
  }
}

/// Returns an emoji icon for a category.
String categoryEmoji(FoodCategory category) {
  switch (category) {
    case FoodCategory.burger:
      return '🍔';
    case FoodCategory.pizza:
      return '🍕';
    case FoodCategory.desi:
      return '🍛';
    case FoodCategory.drinks:
      return '🥤';
    case FoodCategory.dessert:
      return '🍰';
  }
}

/// Base class for anything that can be sold on the menu.
/// Abstract: you cannot create a MenuItem directly, only its subclasses.
abstract class MenuItem {
  final String id;
  final String name;
  double _price; // private field, accessed through getter/setter

  MenuItem({required this.id, required this.name, required double price})
      : _price = price;

  // Getter
  double get price => _price;

  // Setter with validation
  set price(double value) {
    if (value < 0) {
      throw ArgumentError('Price cannot be negative');
    }
    _price = value;
  }

  /// Formatted price, e.g. "Rs. 850".
  String get priceLabel => 'Rs. ${_price.toStringAsFixed(0)}';

  /// Each subclass decides how it is described.
  String describe();
}

/// A food item. Inherits id, name and price from MenuItem.
class FoodItem extends MenuItem {
  final FoodCategory category;
  final String description;
  final List<String> ingredients;
  final double rating;
  final int prepMinutes;
  final bool isSpicy;
  final String restaurantName;

  FoodItem({
    required super.id,
    required super.name,
    required super.price,
    required this.category,
    required this.description,
    required this.ingredients,
    required this.rating,
    required this.prepMinutes,
    required this.restaurantName,
    this.isSpicy = false,
  });

  String get emoji => categoryEmoji(category);

  @override
  String describe() {
    final spicyText = isSpicy ? ' (spicy)' : '';
    return '$name$spicyText from $restaurantName - $priceLabel';
  }
}
