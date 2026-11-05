import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_avatar.dart';
import '../../../core/widgets/custom_badge.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Profil Saya',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            // Kartu Profil Utama
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFF1F5F9)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 14,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: const [
                  AppAvatar(
                    size: 80,
                    imageUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&q=80&w=200',
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Siti Rahma',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'siti.rahma@email.com',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 12),
                  CustomBadge(
                    icon: Icon(Icons.eco_rounded, size: 15, color: AppColors.mintText),
                    label: 'Level Hemat: Bijak',
                    backgroundColor: AppColors.mintChip,
                    textColor: AppColors.mintText,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Pengaturan & Preferensi
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFF1F5F9)),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.account_balance_wallet_outlined, color: AppColors.primary),
                    title: const Text('Batas Budget Bulanan', style: TextStyle(fontWeight: FontWeight.w600)),
                    trailing: const Text('Rp 2.000.000', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 56, endIndent: 20),
                  ListTile(
                    leading: const Icon(Icons.notifications_none_rounded, color: AppColors.primary),
                    title: const Text('Pengingat Belanja', style: TextStyle(fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 56, endIndent: 20),
                  ListTile(
                    leading: const Icon(Icons.info_outline_rounded, color: AppColors.primary),
                    title: const Text('Tentang BelanjaPas', style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: const Text('Versi 1.0.0 (Material 3)'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
