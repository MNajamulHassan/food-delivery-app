import 'package:flutter/material.dart';

import '../models/restaurant.dart';
import '../theme/app_colors.dart';

/// Small card for a restaurant in the horizontal "Popular restaurants" row.
class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantCard({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 70,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(restaurant.emoji, style: const TextStyle(fontSize: 36)),
          ),
          const SizedBox(height: 10),
          Text(
            restaurant.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          Text(
            restaurant.cuisine,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: AppColors.grey),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.star_rounded, size: 16, color: AppColors.star),
              Text(' ${restaurant.rating}', style: const TextStyle(fontSize: 12)),
              const Spacer(),
              const Icon(Icons.access_time, size: 14, color: AppColors.grey),
              Text(
                ' ${restaurant.deliveryLabel}',
                style: const TextStyle(fontSize: 11, color: AppColors.grey),
              ),
            ],
          ),
          if (restaurant.freeDelivery)
            const Padding(
              padding: EdgeInsets.only(top: 6),
              child: Text(
                'Free delivery',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
