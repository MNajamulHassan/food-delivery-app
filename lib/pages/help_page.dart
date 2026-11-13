import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Simple FAQ page. Each question expands to show its answer.
class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  static const List<Map<String, String>> _faqs = [
    {
      'q': 'How do I place an order?',
      'a': 'Add dishes from the menu, open the cart with the orange button at the bottom, check your address and tap "Place order".',
    },
    {
      'q': 'Is delivery free?',
      'a': 'Delivery is free on orders above Rs. 1500. Below that a Rs. 150 delivery fee is added.',
    },
    {
      'q': 'How do I change my delivery address?',
      'a': 'Tap the address at the top of the Menu tab, or "Change" in the cart. You can pick a saved address or type a new one.',
    },
    {
      'q': 'Where can I see my orders?',
      'a': 'Open the Orders tab. Active orders are on the first tab and delivered ones on the second.',
    },
    {
      'q': 'How do I save a favourite dish?',
      'a': 'Open any dish and tap the heart at the top right. It will appear in the Favourites tab.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & FAQ'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          for (final faq in _faqs)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFEDEDED)),
              ),
              child: ExpansionTile(
                shape: const Border(),
                collapsedShape: const Border(),
                iconColor: AppColors.primary,
                title: Text(
                  faq['q']!,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: [Text(faq['a']!, style: const TextStyle(height: 1.5))],
              ),
            ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.support_agent, color: AppColors.primary, size: 32),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Still need help? Call us at 0300-0000000 (9am - 11pm).',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
