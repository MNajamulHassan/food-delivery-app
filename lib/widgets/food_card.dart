import 'package:flutter/material.dart';

import '../models/menu_item.dart';
import '../theme/app_colors.dart';

/// Hero tag shared by the food card and the details page.
String foodHeroTag(FoodItem item) => 'food-${item.id}';

/// A row card for one food item: emoji, name, rating, price and an add button.
class FoodCard extends StatelessWidget {
  final FoodItem item;
  final int quantityInCart;
  final VoidCallback onTap;
  final VoidCallback onAdd;

  const FoodCard({
    super.key,
    required this.item,
    required this.quantityInCart,
    required this.onTap,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(color: AppColors.shadow, blurRadius: 12, offset: Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            // Emoji "image". The Hero flies to the same tag on the details page.
            Hero(
              tag: foodHeroTag(item),
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  width: 80,
                  height: 80,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: FittedBox(
                    child: Text(item.emoji, style: const TextStyle(fontSize: 40)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Text info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.restaurantName,
                    style: const TextStyle(fontSize: 12, color: AppColors.grey),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 16, color: AppColors.star),
                      Text(' ${item.rating}', style: const TextStyle(fontSize: 12)),
                      const SizedBox(width: 10),
                      const Icon(Icons.access_time, size: 14, color: AppColors.grey),
                      Text(
                        ' ${item.prepMinutes} min',
                        style: const TextStyle(fontSize: 12, color: AppColors.grey),
                      ),
                      if (item.isSpicy) ...[
                        const SizedBox(width: 8),
                        const Text('🌶️', style: TextStyle(fontSize: 12)),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.priceLabel,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            // Add button (shows quantity once the item is in the cart)
            Column(
              children: [
                IconButton.filled(
                  onPressed: onAdd,
                  style: IconButton.styleFrom(backgroundColor: AppColors.primary),
                  icon: const Icon(Icons.add, color: Colors.white),
                ),
                if (quantityInCart > 0)
                  Text(
                    'x$quantityInCart',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
