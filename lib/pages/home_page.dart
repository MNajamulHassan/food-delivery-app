import 'package:flutter/material.dart';

import '../models/app_store.dart';
import '../routes.dart';
import '../services/auth_service.dart';
import '../theme/app_colors.dart';
import '../widgets/app_drawer.dart';
import 'tabs/favourites_tab.dart';
import 'tabs/menu_tab.dart';
import 'tabs/orders_tab.dart';
import 'tabs/profile_tab.dart';

/// Main screen after login. Holds the drawer, the notched BottomAppBar with
/// four tabs, and the cart button docked in the notch.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AppStore _store = AppStore();
  int _tab = 0;

  static const List<String> _titles = ['Menu', 'Favourites', 'My Orders', 'Profile'];

  @override
  void initState() {
    super.initState();
    // Rebuild whenever the cart, favourites or orders change
    _store.addListener(_onStoreChanged);
  }

  @override
  void dispose() {
    _store.removeListener(_onStoreChanged);
    super.dispose();
  }

  void _onStoreChanged() {
    if (mounted) setState(() {});
  }

  void _selectTab(int index) => setState(() => _tab = index);

  /// Opens the cart. The cart page returns `true` when an order was placed,
  /// and then we jump to the Orders tab.
  Future<void> _openCart() async {
    final orderPlaced = await Navigator.of(context).pushNamed(AppRoutes.cart);
    if (orderPlaced == true) {
      _selectTab(2);
    }
  }

  /// The address page pops with the chosen address (a String).
  Future<void> _pickAddress() async {
    final picked = await Navigator.of(context).pushNamed(AppRoutes.address);
    if (picked is String) {
      _store.setDeliveryAddress(picked);
    }
  }

  Future<void> _logout() async {
    await AuthService.logout();
    _store.reset();
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
  }

  Widget _currentTab() {
    switch (_tab) {
      case 1:
        return FavouritesTab(onBrowseMenu: () => _selectTab(0));
      case 2:
        return const OrdersTab();
      case 3:
        return ProfileTab(onLogout: _logout, onSelectTab: _selectTab);
      default:
        return const MenuTab();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _tab == 0 ? _buildLocationTitle() : Text(_titles[_tab]),
      ),
      drawer: AppDrawer(
        currentTab: _tab,
        onSelectTab: _selectTab,
        onOpenCart: _openCart,
        onLogout: _logout,
      ),
      body: _currentTab(),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCart,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: Badge(
          isLabelVisible: !_store.cart.isEmpty,
          label: Text('${_store.cart.itemCount}'),
          backgroundColor: AppColors.dark,
          child: const Icon(Icons.shopping_bag),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: AppColors.card,
        padding: EdgeInsets.zero,
        height: 68,
        child: Row(
          children: [
            _navItem(Icons.restaurant_menu, 'Menu', 0),
            _navItem(Icons.favorite_border, 'Favourites', 1),
            const SizedBox(width: 64), // space for the notch
            _navItem(Icons.receipt_long_outlined, 'Orders', 2),
            _navItem(Icons.person_outline, 'Profile', 3),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final selected = _tab == index;
    final color = selected ? AppColors.primary : AppColors.grey;
    return Expanded(
      child: TextButton(
        onPressed: () => _selectTab(index),
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationTitle() {
    return GestureDetector(
      onTap: _pickAddress,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Deliver to',
            style: TextStyle(fontSize: 12, color: AppColors.grey),
          ),
          Row(
            children: [
              const Icon(Icons.location_on, size: 18, color: AppColors.primary),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  _store.deliveryAddress,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
              const Icon(Icons.keyboard_arrow_down),
            ],
          ),
        ],
      ),
    );
  }
}
