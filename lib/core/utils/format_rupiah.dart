import 'package:intl/intl.dart';

/// Utilitas formatting mata uang Rupiah dan tanggal Bahasa Indonesia
class AppFormatters {
  AppFormatters._();

  static final NumberFormat _rupiahFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  /// Format angka integer ke string Rupiah:
  /// Contoh: 85000 -> "Rp 85.000"
  static String rupiah(int amount) {
    // Normalisasi spasi agar konsisten persis dengan desain
    final formatted = _rupiahFormat.format(amount);
    return formatted.replaceAll('\u00A0', ' ');
  }

  /// Format tanggal lengkap dengan nama hari:
  /// Contoh: "Sabtu, 24 Mei 2025"
  static String dateWithDay(DateTime date) {
    return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(date);
  }

  /// Format tanggal standar:
  /// Contoh: "10 Mei 2025"
  static String dateStandard(DateTime date) {
    return DateFormat('d MMMM yyyy', 'id_ID').format(date);
  }

  /// Format tanggal dengan bulan disingkat:
  /// Contoh: "25 Apr 2025"
  static String dateShort(DateTime date) {
    return DateFormat('d MMM yyyy', 'id_ID').format(date);
  }
}

