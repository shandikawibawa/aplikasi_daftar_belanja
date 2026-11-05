import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/format_rupiah.dart';
import '../../../../core/widgets/custom_badge.dart';
import '../../domain/models/shopping_list.dart';

class HistoryListCard extends StatelessWidget {
  final ShoppingList list;
  final VoidCallback onDuplicate;
  final VoidCallback onViewDetail;

  const HistoryListCard({
    super.key,
    required this.list,
    required this.onDuplicate,
    required this.onViewDetail,
  });

  @override
  Widget build(BuildContext context) {
    // Format tanggal: jika hari dan bulan ingin seperti gambar
    final dateStr = list.id == 'hist_3'
        ? AppFormatters.dateShort(list.createdAt)
        : AppFormatters.dateStandard(list.createdAt);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFF1F5F9),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Kategori Chip + Hemat / Pas Budget Chip + Ikon Centang Ganda
          Row(
            children: [
              // Chip Kategori
              CustomBadge(
                label: list.category,
                backgroundColor: const Color(0xFFF1F5F9),
                textColor: const Color(0xFF475569),
                fontSize: 11,
                fontWeight: FontWeight.w600,
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              ),
              const SizedBox(width: 8),

              // Chip Status Budget (Hemat atau Pas Budget)
              if (list.id == 'hist_2' || list.isPasBudget)
                CustomBadge(
                  icon: const Text('🎯', style: TextStyle(fontSize: 10)),
                  label: 'Pas Budget',
                  backgroundColor: AppColors.orangeChipBg,
                  textColor: AppColors.orangeText,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                )
              else
                CustomBadge(
                  icon: const Text('🎉', style: TextStyle(fontSize: 10)),
                  label: 'Hemat ${AppFormatters.rupiah(list.penghematan)}',
                  backgroundColor: AppColors.mintChip,
                  textColor: AppColors.mintText,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),

              const Spacer(),

              // Ikon Centang Ganda Hijau
              Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: AppColors.mintBackground,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.done_all_rounded,
                  color: Color(0xFF059669),
                  size: 19,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Judul Daftar Riwayat
          Text(
            list.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.2,
            ),
          ),

          const SizedBox(height: 5),

          // Tanggal dan Jumlah Barang
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 13,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 5),
              Text(
                '$dateStr • ${list.totalBarang} barang',
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Realisasi Belanja & Tombol Aksi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Kolom Realisasi Belanja
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Realisasi Belanja',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: AppFormatters.rupiah(list.totalTerpakai),
                          style: const TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.2,
                          ),
                        ),
                        TextSpan(
                          text: ' / ${AppFormatters.rupiah(list.budget)}',
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Tombol "Salin" dan Tombol Detail Mata
              Row(
                children: [
                  // Tombol "Salin"
                  InkWell(
                    onTap: onDuplicate,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      decoration: BoxDecoration(
                        color: AppColors.lavenderPill,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.copy_rounded,
                            size: 13,
                            color: Color(0xFF334155),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Salin',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF334155),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Tombol Ikon Mata
                  InkWell(
                    onTap: onViewDetail,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      decoration: BoxDecoration(
                        color: AppColors.lavenderPill,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.visibility_outlined,
                        size: 16,
                        color: Color(0xFF475569),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

