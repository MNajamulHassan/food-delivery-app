import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Container(
              width: 110,
              height: 110,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Text('🛵', style: TextStyle(fontSize: 56)),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Foodie Express',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          const Text(
            'Version 1.0.0',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.grey),
          ),
          const SizedBox(height: 24),
          const Text(
            'Foodie Express lets you browse local restaurants, add dishes to a cart '
            'and order them to your door. It is being built step by step as the '
            'semester project for Mobile Application Development.',
            style: TextStyle(height: 1.6),
          ),
          const SizedBox(height: 24),
          _infoRow(Icons.school_outlined, 'Course', 'Mobile Application Development'),
          _infoRow(Icons.account_balance_outlined, 'University',
              'Riphah International University, Faculty of Computing'),
          _infoRow(Icons.person_outline, 'Instructor', 'Mr. Muhammad Usman'),
          _infoRow(Icons.code, 'Built with', 'Flutter & Dart'),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: AppColors.grey)),
                Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
