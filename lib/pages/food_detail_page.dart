import 'package:flutter/material.dart';

import '../models/app_store.dart';
import '../models/menu_item.dart';
import '../theme/app_colors.dart';
import '../widgets/food_card.dart' show foodHeroTag;

class FoodDetailPage extends StatefulWidget {
  final FoodItem item;

  const FoodDetailPage({super.key, required this.item});

  @override
  State<FoodDetailPage> createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  int _quantity = 1;
  bool _showIngredients = false; // toggles the AnimatedCrossFade
  final AppStore _store = AppStore();
  bool _showAddedMessage = false; // drives the AnimatedOpacity

  void _addToCart() {
    _store.addToCart(widget.item, quantity: _quantity);
    setState(() => _showAddedMessage = true);

    // Hide the confirmation again after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showAddedMessage = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final total = item.price * _quantity;
    final isFavourite = _store.isFavourite(item);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => setState(() => _store.toggleFavourite(item)),
            icon: Icon(
              isFavourite ? Icons.favorite : Icons.favorite_border,
              color: isFavourite ? Colors.red : AppColors.dark,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Big emoji "photo" - Hero flies in from the food card
              Hero(
                tag: foodHeroTag(item),
                child: Material(
                  type: MaterialType.transparency,
                  child: Container(
                    height: 220,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: FittedBox(
                      child: Text(item.emoji, style: const TextStyle(fontSize: 110)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                item.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                'by ${item.restaurantName}',
                style: const TextStyle(color: AppColors.grey),
              ),
              const SizedBox(height: 12),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: item.priceLabel,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    const TextSpan(
                      text: '  / serving',
                      style: TextStyle(fontSize: 14, color: AppColors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _InfoPill(icon: Icons.star_rounded, text: '${item.rating}', color: AppColors.star),
                  const SizedBox(width: 10),
                  _InfoPill(icon: Icons.access_time, text: '${item.prepMinutes} min', color: AppColors.primary),
                  const SizedBox(width: 10),
                  if (item.isSpicy)
                    const _InfoPill(icon: Icons.local_fire_department, text: 'Spicy', color: Colors.red),
                ],
              ),
              const SizedBox(height: 24),
              _buildTabButtons(),
              const SizedBox(height: 12),
              // Cross-fade between description and ingredients
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 350),
                crossFadeState: _showIngredients
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                firstChild: Text(
                  item.description,
                  style: const TextStyle(height: 1.6, color: Color(0xFF555555)),
                ),
                secondChild: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final ingredient in item.ingredients)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, size: 18, color: AppColors.green),
                            const SizedBox(width: 8),
                            Text(ingredient),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildQuantitySelector(),
              const SizedBox(height: 16),
              // Confirmation that fades in/out
              AnimatedOpacity(
                opacity: _showAddedMessage ? 1 : 0,
                duration: const Duration(milliseconds: 400),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F5EA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.check_circle, color: AppColors.green),
                      SizedBox(width: 8),
                      Text(
                        'Added to cart!',
                        style: TextStyle(
                          color: AppColors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: ElevatedButton(
            onPressed: _addToCart,
            child: Text(
              'Add to cart  •  Rs. ${total.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabButtons() {
    return Row(
      children: [
        _tabButton('Description', !_showIngredients, () {
          setState(() => _showIngredients = false);
        }),
        const SizedBox(width: 8),
        _tabButton('Ingredients', _showIngredients, () {
          setState(() => _showIngredients = true);
        }),
      ],
    );
  }

  Widget _tabButton(String label, bool active, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: active ? AppColors.primary : AppColors.primaryLight,
        foregroundColor: active ? Colors.white : AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildQuantitySelector() {
    return Row(
      children: [
        const Text(
          'Quantity',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const Spacer(),
        OutlinedButton(
          onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
          style: OutlinedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(8),
          ),
          child: const Icon(Icons.remove),
        ),
        SizedBox(
          width: 40,
          child: Text(
            '$_quantity',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        OutlinedButton(
          onPressed: () => setState(() => _quantity++),
          style: OutlinedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(8),
          ),
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}

/// Small rounded label with an icon, used for rating / time / spicy.
class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _InfoPill({required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
