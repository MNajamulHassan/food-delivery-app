import 'package:flutter/material.dart';

import '../../models/app_store.dart';
import '../../routes.dart';
import '../../theme/app_colors.dart';
import '../../widgets/food_card.dart';

/// Items the user hearted on the details page.
class FavouritesTab extends StatelessWidget {
  final VoidCallback onBrowseMenu;

  const FavouritesTab({super.key, required this.onBrowseMenu});

  @override
  Widget build(BuildContext context) {
    final store = AppStore();
    final favourites = store.favourites;

    if (favourites.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('💛', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 12),
              const Text(
                'No favourites yet',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              const Text(
                'Tap the heart on any dish to save it here.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.grey),
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: onBrowseMenu,
                icon: const Icon(Icons.restaurant_menu),
                label: const Text('Browse menu'),
              ),
            ],
          ),
        ),
      );
    }

    // ListView constructor: fine for a short list
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
      children: [
        for (final item in favourites)
          FoodCard(
            item: item,
            quantityInCart: store.cart.quantityOf(item),
            onTap: () =>
                Navigator.of(context).pushNamed(AppRoutes.details, arguments: item),
            onAdd: () => store.addToCart(item),
          ),
      ],
    );
  }
}
