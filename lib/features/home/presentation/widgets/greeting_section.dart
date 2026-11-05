import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_badge.dart';

class GreetingSection extends StatelessWidget {
  final String userName;
  final String savingLevel;

  const GreetingSection({
    super.key,
    this.userName = 'Siti Rahma!',
    this.savingLevel = 'Level Hemat: Bijak',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Teks Sapaan & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        'Halo, $userName',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.4,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      '👋',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Mau belanja hemat apa hari ini?',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Badge "Level Hemat: Bijak"
          CustomBadge(
            icon: const Icon(
              Icons.eco_rounded,
              size: 15,
              color: AppColors.mintText,
            ),
            label: savingLevel,
            backgroundColor: AppColors.mintChip,
            textColor: AppColors.mintText,
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          ),
        ],
      ),
    );
  }
}

