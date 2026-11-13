import 'package:flutter/material.dart';

import '../models/app_store.dart';
import '../routes.dart';
import '../theme/app_colors.dart';

/// Side menu. A ListView inside a Drawer, with a custom header for the user.
class AppDrawer extends StatelessWidget {
  final int currentTab;
  final ValueChanged<int> onSelectTab;
  final VoidCallback onOpenCart;
  final VoidCallback onLogout;

  const AppDrawer({
    super.key,
    required this.currentTab,
    required this.onSelectTab,
    required this.onOpenCart,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final store = AppStore();
    final user = store.user;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header
          Container(
            padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.of(context).padding.top + 24,
              20,
              24,
            ),
            color: AppColors.primary,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Text(
                    user?.initials ?? '?',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? 'Guest',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        user?.email ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _tabTile(context, Icons.restaurant_menu, 'Menu', 0),
          _tabTile(context, Icons.favorite_border, 'Favourites', 1),
          _tabTile(context, Icons.receipt_long_outlined, 'My orders', 2),
          _tabTile(context, Icons.person_outline, 'Profile', 3),
          ListTile(
            leading: const Icon(Icons.shopping_bag_outlined),
            title: const Text('Cart'),
            trailing: store.cart.isEmpty
                ? null
                : Text('${store.cart.itemCount}',
                    style: const TextStyle(
                        color: AppColors.primary, fontWeight: FontWeight.w700)),
            onTap: () {
              Navigator.of(context).pop(); // close drawer first
              onOpenCart();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & FAQ'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(AppRoutes.help);
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(AppRoutes.about);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Log out', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.of(context).pop();
              onLogout();
            },
          ),
        ],
      ),
    );
  }

  Widget _tabTile(BuildContext context, IconData icon, String title, int index) {
    final selected = currentTab == index;
    return ListTile(
      leading: Icon(icon, color: selected ? AppColors.primary : null),
      title: Text(
        title,
        style: TextStyle(
          color: selected ? AppColors.primary : null,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      selected: selected,
      selectedTileColor: AppColors.primaryLight,
      onTap: () {
        Navigator.of(context).pop();
        onSelectTab(index);
      },
    );
  }
}
