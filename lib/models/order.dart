import 'cart.dart';

enum OrderStatus { preparing, onTheWay, delivered }

String statusLabel(OrderStatus status) {
  switch (status) {
    case OrderStatus.preparing:
      return 'Preparing';
    case OrderStatus.onTheWay:
      return 'On the way';
    case OrderStatus.delivered:
      return 'Delivered';
  }
}

/// A placed order. Keeps its own copy of the cart lines.
class Order {
  final String id;
  final List<CartLine> lines;
  final double total;
  final String address;
  final DateTime placedAt;
  OrderStatus status;

  Order({
    required this.id,
    required this.lines,
    required this.total,
    required this.address,
    required this.placedAt,
    this.status = OrderStatus.preparing,
  });

  bool get isActive => status != OrderStatus.delivered;

  int get itemCount {
    int count = 0;
    for (final line in lines) {
      count += line.quantity;
    }
    return count;
  }

  /// e.g. "13/11/2026  11:05" (formatting by hand until we add the intl package)
  String get placedAtLabel {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${placedAt.day}/${placedAt.month}/${placedAt.year}  '
        '${two(placedAt.hour)}:${two(placedAt.minute)}';
  }

  /// Moves the order to the next status.
  void advance() {
    if (status == OrderStatus.preparing) {
      status = OrderStatus.onTheWay;
    } else if (status == OrderStatus.onTheWay) {
      status = OrderStatus.delivered;
    }
  }
}
