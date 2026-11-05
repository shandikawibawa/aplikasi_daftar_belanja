import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class QuickCategoriesSection extends StatelessWidget {
  const QuickCategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      _CategoryItemData(
        label: 'Sayuran',
        bgColor: AppColors.catSayuranBg,
        iconColor: AppColors.catSayuranIcon,
        icon: Icons.spa_outlined,
      ),
      _CategoryItemData(
        label: 'Protein',
        bgColor: AppColors.catProteinBg,
        iconColor: AppColors.catProteinIcon,
        icon: Icons.egg_outlined,
      ),
      _CategoryItemData(
        label: 'Kebersihan',
        bgColor: AppColors.catKebersihanBg,
        iconColor: AppColors.catKebersihanIcon,
        icon: Icons.sanitizer_outlined,
      ),
      _CategoryItemData(
        label: 'Bumbu',
        bgColor: AppColors.catBumbuBg,
        iconColor: AppColors.catBumbuIcon,
        icon: Icons.soup_kitchen_outlined,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Kategori Cepat
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Kategori Cepat',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
              Text(
                'Inspirasi belanja',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Baris 4 Kartu Kategori
          Row(
            children: categories.map((cat) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xFFF1F5F9),
                        width: 1,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x06000000),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Ikon dalam lingkaran berwarna
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: cat.bgColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            cat.icon,
                            color: cat.iconColor,
                            size: 22,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          cat.label,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _CategoryItemData {
  final String label;
  final Color bgColor;
  final Color iconColor;
  final IconData icon;

  const _CategoryItemData({
    required this.label,
    required this.bgColor,
    required this.iconColor,
    required this.icon,
  });
}

