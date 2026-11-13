import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// A heading with an optional small text on the right, e.g. "Menu   10 items".
class SectionTitle extends StatelessWidget {
  final String title;
  final String? trailing;

  const SectionTitle({super.key, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.dark,
            ),
          ),
          if (trailing != null)
            Text(
              trailing!,
              style: const TextStyle(fontSize: 13, color: AppColors.grey),
            ),
        ],
      ),
    );
  }
}
