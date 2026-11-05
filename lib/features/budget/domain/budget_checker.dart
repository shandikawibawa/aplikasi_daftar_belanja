import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

enum BudgetStatus {
  aman('Kondisi budget sangat aman', AppColors.primary),
  hampirHabis('Budget hampir habis', AppColors.warning),
  melebihi('Melebihi budget!', AppColors.danger);

  final String message;
  final Color color;
  const BudgetStatus(this.message, this.color);
}

class BudgetChecker {
  BudgetChecker._();

  /// Menilai status kesehatan budget berdasarkan pemakaian saat ini vs alokasi budget
  static BudgetStatus checkStatus({required int terpakai, required int budget}) {
    if (budget <= 0) return BudgetStatus.aman;
    final ratio = terpakai / budget;

    if (ratio > 1.0) {
      return BudgetStatus.melebihi;
    } else if (ratio >= 0.8) {
      return BudgetStatus.hampirHabis;
    } else {
      return BudgetStatus.aman;
    }
  }

  /// Warna progress bar dinamis:
  /// - Hijau (<80%)
  /// - Oranye (80-100%)
  /// - Merah (>100%)
  static Color getProgressBarColor({required int terpakai, required int budget}) {
    if (budget <= 0) return AppColors.primary;
    final ratio = terpakai / budget;

    if (ratio > 1.0) {
      return AppColors.danger;
    } else if (ratio >= 0.8) {
      return AppColors.orangePrimary;
    } else {
      return AppColors.primary;
    }
  }
}

