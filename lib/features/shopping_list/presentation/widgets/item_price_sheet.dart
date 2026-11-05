import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/format_rupiah.dart';
import '../../domain/models/shopping_item.dart';

class ItemPriceBottomSheet extends StatefulWidget {
  final ShoppingItem item;
  final ValueChanged<int> onConfirm;

  const ItemPriceBottomSheet({
    super.key,
    required this.item,
    required this.onConfirm,
  });

  static Future<int?> show(BuildContext context, ShoppingItem item) {
    return showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ItemPriceBottomSheet(
        item: item,
        onConfirm: (price) => Navigator.of(ctx).pop(price),
      ),
    );
  }

  @override
  State<ItemPriceBottomSheet> createState() => _ItemPriceBottomSheetState();
}

class _ItemPriceBottomSheetState extends State<ItemPriceBottomSheet> {
  late int currentPrice;

  @override
  void initState() {
    super.initState();
    currentPrice = widget.item.actualPrice ?? widget.item.estimatedPrice;
  }

  void _adjust(int delta) {
    setState(() {
      final updated = currentPrice + delta;
      if (updated >= 0) {
        currentPrice = updated;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Nama Barang & Estimasi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Estimasi: ${AppFormatters.rupiah(widget.item.estimatedPrice)} (${widget.item.quantity}x)',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.lavenderPill,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.item.category,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Tampilan Harga Riil Saat Ini
          Center(
            child: Column(
              children: [
                const Text(
                  'Harga Riil yang Dibeli:',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  AppFormatters.rupiah(currentPrice),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Tombol Cepat: "- Rp 1.000", "Pas", "+ Rp 1.000"
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _adjust(-1000),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.divider),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    '- Rp 1.000',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentPrice = widget.item.estimatedPrice;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lavenderPill,
                    foregroundColor: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Pas',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _adjust(1000),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.divider),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    '+ Rp 1.000',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Tombol Konfirmasi Simpan & Centang
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => widget.onConfirm(currentPrice),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                'Simpan & Centang Barang',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

