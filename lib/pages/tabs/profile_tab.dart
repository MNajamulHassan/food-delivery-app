import 'package:flutter/material.dart';

import '../../models/app_store.dart';
import '../../routes.dart';
import '../../theme/app_colors.dart';

class ProfileTab extends StatelessWidget {
  final VoidCallback onLogout;
  final ValueChanged<int> onSelectTab;

  const ProfileTab({super.key, required this.onLogout, required this.onSelectTab});

  @override
  Widget build(BuildContext context) {
    final store = AppStore();
    final user = store.user;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
      children: [
        // Avatar + name
        Center(
          child: CircleAvatar(
            radius: 44,
            backgroundColor: AppColors.primary,
            child: Text(
              user?.initials ?? '?',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          user?.name ?? 'Guest',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        Text(
          user?.email ?? '',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.grey),
        ),
        const SizedBox(height: 20),
        // Stats row
        Row(
          children: [
            _stat('${store.orderCount}', 'Orders', () => onSelectTab(2)),
            const SizedBox(width: 12),
            _stat('${store.favourites.length}', 'Favourites', () => onSelectTab(1)),
            const SizedBox(width: 12),
            _stat('${store.cart.itemCount}', 'In cart',
                () => Navigator.of(context).pushNamed(AppRoutes.cart)),
          ],
        ),
        const SizedBox(height: 20),
        _tile(
          icon: Icons.location_on_outlined,
          title: 'Delivery address',
          subtitle: store.deliveryAddress,
          onTap: () async {
            final picked = await Navigator.of(context).pushNamed(AppRoutes.address);
            if (picked is String) store.setDeliveryAddress(picked);
          },
        ),
        _tile(
          icon: Icons.help_outline,
          title: 'Help & FAQ',
          onTap: () => Navigator.of(context).pushNamed(AppRoutes.help),
        ),
        _tile(
          icon: Icons.info_outline,
          title: 'About Foodie Express',
          onTap: () => Navigator.of(context).pushNamed(AppRoutes.about),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: onLogout,
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          icon: const Icon(Icons.logout),
          label: const Text('Log out'),
        ),
      ],
    );
  }

  Widget _stat(String value, String label, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              Text(label, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: subtitle == null
            ? null
            : Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
