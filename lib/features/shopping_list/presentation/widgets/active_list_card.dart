import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/format_rupiah.dart';
import '../../../../core/widgets/custom_badge.dart';
import '../../../budget/domain/budget_checker.dart';
import '../../domain/models/shopping_list.dart';

class ActiveListCard extends StatelessWidget {
  final ShoppingList list;
  final VoidCallback onContinueShopping;

  const ActiveListCard({
    super.key,
    required this.list,
    required this.onContinueShopping,
  });

  @override
  Widget build(BuildContext context) {
    final budgetStatus = BudgetChecker.checkStatus(
      terpakai: list.totalTerpakai,
      budget: list.budget,
    );
    final progressBarColor = BudgetChecker.getProgressBarColor(
      terpakai: list.totalTerpakai,
      budget: list.budget,
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFF1F5F9),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 16,
            spreadRadius: 0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Soft gradient accent di sudut kanan atas
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 140,
                height: 140,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color(0x3386EFAC),
                      Color(0x00FFFFFF),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row 1: Label "SEDANG BERJALAN" & Ikon Keranjang Mint di Kanan Atas
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'SEDANG BERJALAN',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ],
                      ),
                      // Ikon Keranjang di lingkaran mint
                      Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          color: AppColors.mintBackground,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.shopping_basket_outlined,
                          color: AppColors.primary,
                          size: 22,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Judul Daftar Belanja (Bisa multiline tebal)
                  Text(
                    _formatCardTitle(list.name),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      height: 1.25,
                      letterSpacing: -0.4,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Tanggal & Ikon Kalender
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 13.5,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        AppFormatters.dateWithDay(list.createdAt),
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Progres Belanja Pill Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.lavenderPill,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Progres Belanja',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${list.jumlahTercentang} dari ${list.totalBarang} barang (${list.persentaseBarangInt}%)',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Informasi Terpakai & Total Budget
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      const Text(
                        'Terpakai: ',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        AppFormatters.rupiah(list.totalTerpakai),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'dari ${AppFormatters.rupiah(list.budget)}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Progress Bar Dinamis
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: list.persentaseBudget.clamp(0.0, 1.0),
                      minHeight: 8,
                      backgroundColor: const Color(0xFFE2E8F0),
                      valueColor: AlwaysStoppedAnimation<Color>(progressBarColor),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Status Budget & Chip Sisa Budget
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.verified_user_outlined,
                            size: 15,
                            color: budgetStatus.color,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            budgetStatus.message,
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF334155),
                            ),
                          ),
                        ],
                      ),
                      CustomBadge(
                        label: 'Sisa ${AppFormatters.rupiah(list.sisaBudget)}',
                        backgroundColor: AppColors.mintChip,
                        textColor: AppColors.mintText,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Tombol "Lanjutkan Belanja"
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: onContinueShopping,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 20,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Lanjutkan Belanja',
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 22,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Memformat teks judul "Belanja Mingguan Dapur" dengan line-break yang rapi seperti di gambar
  static String _formatCardTitle(String original) {
    if (original == 'Belanja Mingguan Dapur') {
      return 'Belanja\nMingguan\nDapur';
    }
    return original;
  }
}

