import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/format_rupiah.dart';
import '../../../core/widgets/custom_badge.dart';
import '../../budget/domain/budget_checker.dart';
import '../domain/models/shopping_item.dart';
import 'providers/shopping_provider.dart';
import 'widgets/item_price_sheet.dart';

class ShoppingDetailScreen extends ConsumerWidget {
  final String listId;

  const ShoppingDetailScreen({
    super.key,
    required this.listId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lists = ref.watch(shoppingListsProvider);
    final list = lists.firstWhere(
      (l) => l.id == listId,
      orElse: () => lists.first,
    );

    final budgetStatus = BudgetChecker.checkStatus(
      terpakai: list.totalTerpakai,
      budget: list.budget,
    );
    final progressBarColor = BudgetChecker.getProgressBarColor(
      terpakai: list.totalTerpakai,
      budget: list.budget,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          list.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        actions: [
          // Tombol Auto Adjust
          IconButton(
            tooltip: 'Auto-Adjust Budget',
            icon: const Icon(Icons.auto_fix_high_rounded, color: AppColors.primary),
            onPressed: () async {
              final result = await ref
                  .read(shoppingListsProvider.notifier)
                  .autoAdjustBudget(list.id);

              if (!context.mounted) return;
              if (result == null || result.steps.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Budget sudah aman atau tidak ada barang yang perlu disesuaikan.'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Auto-adjust berhasil menghemat ${AppFormatters.rupiah(result.totalSaved)} (${result.steps.length} penyesuaian)!',
                    ),
                    backgroundColor: AppColors.primary,
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Kartu Ringkasan Budget Real-time
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFF1F5F9)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x08000000),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Terpakai Saat Ini',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          AppFormatters.rupiah(list.totalTerpakai),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Sisa Budget',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          AppFormatters.rupiah(list.sisaBudget),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: list.sisaBudget < 0 ? AppColors.danger : AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: list.persentaseBudget.clamp(0.0, 1.0),
                    minHeight: 8,
                    backgroundColor: const Color(0xFFE2E8F0),
                    valueColor: AlwaysStoppedAnimation<Color>(progressBarColor),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      budgetStatus.message,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: budgetStatus.color,
                      ),
                    ),
                    Text(
                      '${list.jumlahTercentang} dari ${list.totalBarang} barang (${list.persentaseBarangInt}%)',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Daftar Barang Belanja
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: list.items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = list.items[index];
                return _ItemCard(
                  item: item,
                  onToggle: () async {
                    if (item.isChecked) {
                      // Uncheck item
                      await ref.read(shoppingListsProvider.notifier).toggleItemCheck(
                            listId: list.id,
                            itemId: item.id,
                          );
                    } else {
                      // Buka modal input harga riil
                      final price = await ItemPriceBottomSheet.show(context, item);
                      if (price != null) {
                        await ref.read(shoppingListsProvider.notifier).toggleItemCheck(
                              listId: list.id,
                              itemId: item.id,
                              actualPrice: price,
                            );
                      }
                    }
                  },
                );
              },
            ),
          ),

          // Bottom Bar Selesai Belanja
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    await ref.read(shoppingListsProvider.notifier).completeShopping(list.id);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Belanja selesai! Daftar telah dipindahkan ke Riwayat.'),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                    context.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Selesai Belanja',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final ShoppingItem item;
  final VoidCallback onToggle;

  const _ItemCard({
    required this.item,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final effectivePrice = item.actualPrice ?? item.estimatedPrice;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: item.isChecked ? const Color(0xFFF8FAFC) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.isChecked ? const Color(0xFFE2E8F0) : const Color(0xFFF1F5F9),
        ),
      ),
      child: Row(
        children: [
          // Checkbox bulat kustom
          GestureDetector(
            onTap: onToggle,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: item.isChecked ? AppColors.primary : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: item.isChecked ? AppColors.primary : AppColors.textSecondary,
                  width: 2,
                ),
              ),
              child: item.isChecked
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 14),

          // Detail Nama Barang & Kategori
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: item.isChecked ? AppColors.textSecondary : AppColors.textPrimary,
                    decoration: item.isChecked ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    CustomBadge(
                      label: item.category,
                      backgroundColor: const Color(0xFFF1F5F9),
                      textColor: const Color(0xFF475569),
                      fontSize: 10.5,
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${item.quantity}x',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (item.isInStock) ...[
                      const SizedBox(width: 6),
                      const CustomBadge(
                        label: 'Ada di rumah',
                        backgroundColor: AppColors.mintLight,
                        textColor: AppColors.mintText,
                        fontSize: 10.5,
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Harga
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                AppFormatters.rupiah(item.quantity * effectivePrice),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: item.isChecked ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
              if (item.actualPrice != null && item.actualPrice != item.estimatedPrice)
                Text(
                  'Est: ${AppFormatters.rupiah(item.quantity * item.estimatedPrice)}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
