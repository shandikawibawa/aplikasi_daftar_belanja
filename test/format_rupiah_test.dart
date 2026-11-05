import 'package:aplikasi_daftar_belanja/core/utils/format_rupiah.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  group('AppFormatters Rupiah Tests', () {
    test('Format angka menjadi string Rupiah standar', () {
      expect(AppFormatters.rupiah(85000), 'Rp 85.000');
      expect(AppFormatters.rupiah(100000), 'Rp 100.000');
      expect(AppFormatters.rupiah(315000), 'Rp 315.000');
      expect(AppFormatters.rupiah(198500), 'Rp 198.500');
      expect(AppFormatters.rupiah(0), 'Rp 0');
    });

    test('Format tanggal Indonesia dengan nama hari', () {
      final date = DateTime(2025, 5, 24); // Sabtu, 24 Mei 2025
      expect(AppFormatters.dateWithDay(date), 'Sabtu, 24 Mei 2025');
    });
  });
}

