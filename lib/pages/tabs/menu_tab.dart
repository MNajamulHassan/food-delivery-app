import 'package:flutter/material.dart';

import '../../data/sample_data.dart';
import '../../models/app_store.dart';
import '../../models/menu_item.dart';
import '../../routes.dart';
import '../../theme/app_colors.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/food_card.dart';
import '../../widgets/restaurant_card.dart';
import '../../widgets/section_title.dart';

class MenuTab extends StatefulWidget {
  const MenuTab({super.key});

  @override
  State<MenuTab> createState() => _MenuTabState();
}

class _MenuTabState extends State<MenuTab> {
  final AppStore _store = AppStore();
  FoodCategory? _selectedCategory; // null means "All"
  String _query = '';
  bool _showPromo = true;

  /// Items filtered by the selected category and the search text.
  List<FoodItem> get _visibleItems {
    return foodItems.where((item) {
      final matchesCategory =
          _selectedCategory == null || item.category == _selectedCategory;
      final matchesSearch =
          item.name.toLowerCase().contains(_query.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _addToCart(FoodItem item) {
    _store.addToCart(item);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${item.name} added to cart'),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final items = _visibleItems;
    final firstName = _store.user?.firstName ?? 'there';

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting using RichText (two styles in one line)
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.dark,
                  height: 1.3,
                ),
                children: [
                  TextSpan(text: 'Hi $firstName, hungry?\n'),
                  const TextSpan(
                    text: 'Order & eat. ',
                    style: TextStyle(color: AppColors.primary),
                  ),
                  const TextSpan(text: '😋'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSearchBar(),
            const SizedBox(height: 16),
            _buildPromoBanner(),
            const SectionTitle(title: 'Categories'),
            _buildCategoryRow(),
            const SectionTitle(title: 'Popular restaurants'),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final r in restaurants) RestaurantCard(restaurant: r),
                ],
              ),
            ),
            SectionTitle(
              title: _selectedCategory == null
                  ? 'All food'
                  : categoryLabel(_selectedCategory!),
              trailing: '${items.length} items',
            ),
            if (items.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text(
                    'Nothing found 🤷\nTry another search.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.grey),
                  ),
                ),
              )
            else
              Column(
                children: [
                  for (final item in items)
                    FoodCard(
                      item: item,
                      quantityInCart: _store.cart.quantityOf(item),
                      onTap: () => Navigator.of(context)
                          .pushNamed(AppRoutes.details, arguments: item),
                      onAdd: () => _addToCart(item),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      onChanged: (value) => setState(() => _query = value),
      decoration: const InputDecoration(
        hintText: 'Search burgers, biryani, shakes...',
        prefixIcon: Icon(Icons.search, color: AppColors.grey),
      ),
    );
  }

  /// Promo banner. AnimatedCrossFade swaps it for an empty box when closed,
  /// fading out and shrinking the space at the same time.
  Widget _buildPromoBanner() {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 400),
      crossFadeState:
          _showPromo ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstChild: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, Color(0xFFFF9F43)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Free delivery',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'On all orders above Rs. 1500',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const Text('🎉', style: TextStyle(fontSize: 40)),
            IconButton(
              onPressed: () => setState(() => _showPromo = false),
              icon: const Icon(Icons.close, color: Colors.white),
            ),
          ],
        ),
      ),
      secondChild: const SizedBox(width: double.infinity),
    );
  }

  Widget _buildCategoryRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          CategoryChip(
            emoji: '🍽️',
            label: 'All',
            selected: _selectedCategory == null,
            onTap: () => setState(() => _selectedCategory = null),
          ),
          for (final category in FoodCategory.values)
            CategoryChip(
              emoji: categoryEmoji(category),
              label: categoryLabel(category),
              selected: _selectedCategory == category,
              onTap: () => setState(() => _selectedCategory = category),
            ),
        ],
      ),
    );
  }
}
