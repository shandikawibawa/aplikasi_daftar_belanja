import 'package:flutter/material.dart';

/// Design tokens warna untuk BelanjaPas sesuai desain UI
abstract final class AppColors {
  // Primary Greens
  static const Color primary = Color(0xFF036A3F); // Hijau tua BelanjaPas
  static const Color primaryDark = Color(0xFF024D2E);
  static const Color primaryLight = Color(0xFF048750);
  
  // Mint & Light Greens (Badge, Chip, Icons)
  static const Color mintBackground = Color(0xFFD1FAE5); // Lingkaran ikon troli & centang
  static const Color mintChip = Color(0xFF86EFAC); // Chip "Sisa Rp 15.000" & "Level Hemat"
  static const Color mintLight = Color(0xFFCFF5E0);
  static const Color mintAccent = Color(0xFF8FF0BF);
  static const Color mintText = Color(0xFF065F46); // Teks hijau pekat di dalam badge mint

  // Warm Orange (Tombol Aksi Utama "Buat Daftar Belanja Baru")
  static const Color orangePrimary = Color(0xFFFB9A3E); // Warna tombol oranye
  static const Color orangeDark = Color(0xFFEA580C);
  static const Color orangeChipBg = Color(0xFFFFEDD5); // Background chip "Pas Budget"
  static const Color orangeText = Color(0xFF9A3412); // Teks chip oranye
  static const Color orangeButtonText = Color(0xFF5E2300); // Teks kontras tombol oranye

  // Lavender & Ice Blue (Progress pill, Tombol Salin & Mata)
  static const Color lavenderPill = Color(0xFFEEF0FF);
  static const Color lavenderBorder = Color(0xFFE0E7FF);
  static const Color lavenderIcon = Color(0xFF475569);

  // Background & Surface
  static const Color background = Color(0xFFF7F8FD); // Background abu kebiruan sangat lembut
  static const Color surface = Colors.white;
  static const Color cardShadow = Color(0x0A000000); // Shadow halus 4%

  // Status & Alerts
  static const Color danger = Color(0xFFE5484D); // Merah peringatan melebihi budget
  static const Color warning = Color(0xFFF59E0B); // Oranye peringatan hampir habis
  static const Color success = Color(0xFF10B981); // Hijau aman

  // Category Colors
  static const Color catSayuranBg = Color(0xFFD1FAE5);
  static const Color catSayuranIcon = Color(0xFF059669);
  
  static const Color catProteinBg = Color(0xFFFFEDD5);
  static const Color catProteinIcon = Color(0xFFD97706);
  
  static const Color catKebersihanBg = Color(0xFFDBEAFE);
  static const Color catKebersihanIcon = Color(0xFF2563EB);
  
  static const Color catBumbuBg = Color(0xFFFFE4E6);
  static const Color catBumbuIcon = Color(0xFFE11D48);

  // Neutral & Typography
  static const Color textPrimary = Color(0xFF0F172A); // Hampir hitam / slate gelap
  static const Color textSecondary = Color(0xFF64748B); // Slate medium untuk subjudul
  static const Color textMuted = Color(0xFF94A3B8); // Slate terang untuk tanggal & keterangan
  static const Color borderLight = Color(0xFFF1F5F9);
  static const Color divider = Color(0xFFE2E8F0);
}

