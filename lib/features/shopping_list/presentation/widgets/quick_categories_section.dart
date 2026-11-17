import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/models/shopping_item.dart';
import '../providers/shopping_provider.dart';

class QuickCategoriesSection extends ConsumerWidget {
  const QuickCategoriesSection({super.key});

  Future<void> _createPreset(
    BuildContext context,
    WidgetRef ref,
    _CategoryItemData category,
  ) async {
    try {
      final list = await ref
          .read(shoppingListsProvider.notifier)
          .createList(
            name: 'Belanja ${category.label}',
            category: category.label,
            budget: category.budget,
            items: category.items
                .map(
                  (item) => ShoppingItem(
                    id: const Uuid().v4(),
                    name: item.name,
                    category: category.label,
                    estimatedPrice: item.price,
                  ),
                )
                .toList(),
          );
      if (context.mounted) context.push('/detail/${list.id}');
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal membuat daftar: $error')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = [
      _CategoryItemData(
        label: 'Sayuran',
        bgColor: AppColors.catSayuranBg,
        iconColor: AppColors.catSayuranIcon,
        icon: Icons.spa_outlined,
        budget: 50000,
        items: const [
          _PresetItem('Bayam 1 ikat', 5000),
          _PresetItem('Wortel 500g', 8000),
          _PresetItem('Kangkung 1 ikat', 4000),
          _PresetItem('Tomat 500g', 8000),
          _PresetItem('Kentang 1kg', 16000),
        ],
      ),
      _CategoryItemData(
        label: 'Protein',
        bgColor: AppColors.catProteinBg,
        iconColor: AppColors.catProteinIcon,
        icon: Icons.egg_outlined,
        budget: 75000,
        items: const [
          _PresetItem('Telur Ayam 1kg', 30000),
          _PresetItem('Ayam 500g', 20000),
          _PresetItem('Tempe 2 papan', 8000),
          _PresetItem('Tahu 10 potong', 10000),
        ],
      ),
      _CategoryItemData(
        label: 'Kebersihan',
        bgColor: AppColors.catKebersihanBg,
        iconColor: AppColors.catKebersihanIcon,
        icon: Icons.sanitizer_outlined,
        budget: 80000,
        items: const [
          _PresetItem('Deterjen 1kg', 22000),
          _PresetItem('Sabun cuci piring 700ml', 15000),
          _PresetItem('Tisu 1 pak', 12000),
          _PresetItem('Spons cuci piring 2 buah', 6000),
          _PresetItem('Pembersih lantai 700ml', 15000),
        ],
      ),
      _CategoryItemData(
        label: 'Bumbu',
        bgColor: AppColors.catBumbuBg,
        iconColor: AppColors.catBumbuIcon,
        icon: Icons.soup_kitchen_outlined,
        budget: 75000,
        items: const [
          _PresetItem('Bawang merah 250g', 10000),
          _PresetItem('Bawang putih 250g', 10000),
          _PresetItem('Cabai 100g', 8000),
          _PresetItem('Garam 500g', 5000),
          _PresetItem('Minyak goreng 1L', 18000),
          _PresetItem('Kecap manis 1 botol', 15000),
        ],
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kategori Cepat',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.2,
            ),
          ),

          const SizedBox(height: 12),

          // Kartu kategori membuat daftar preset lalu membuka detailnya.
          Row(
            children: categories.map((cat) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Material(
                    color: Colors.white,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: const BorderSide(
                        color: Color(0xFFF1F5F9),
                        width: 1,
                      ),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () => _createPreset(context, ref, cat),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
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
  final int budget;
  final List<_PresetItem> items;

  const _CategoryItemData({
    required this.label,
    required this.bgColor,
    required this.iconColor,
    required this.icon,
    required this.budget,
    required this.items,
  });
}

class _PresetItem {
  final String name;
  final int price;

  const _PresetItem(this.name, this.price);
}
