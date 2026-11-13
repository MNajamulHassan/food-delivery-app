/// A restaurant partner shown on the home page.
class Restaurant {
  final String name;
  final String cuisine;
  final double rating;
  final int deliveryMinutes;
  final String emoji;
  final bool freeDelivery;

  const Restaurant({
    required this.name,
    required this.cuisine,
    required this.rating,
    required this.deliveryMinutes,
    required this.emoji,
    this.freeDelivery = false,
  });

  /// Named constructor: a quick way to make a placeholder restaurant.
  const Restaurant.unknown()
      : name = 'Unknown',
        cuisine = '-',
        rating = 0,
        deliveryMinutes = 0,
        emoji = '🍽️',
        freeDelivery = false;

  String get deliveryLabel => '$deliveryMinutes-${deliveryMinutes + 10} min';
}
