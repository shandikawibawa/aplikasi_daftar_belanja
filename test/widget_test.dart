import 'package:aplikasi_daftar_belanja/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  testWidgets('BelanjaPas App Smoke Test & Beranda Rendering', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: BelanjaPasApp()));
    await tester.pumpAndSettle();

    // Pastikan Brand "BelanjaPas" tampil
    expect(find.text('BelanjaPas'), findsOneWidget);

    // Pastikan Sapaan tampil
    expect(find.textContaining('Halo, Siti Rahma!'), findsOneWidget);

    // Aplikasi dimulai tanpa daftar belanja aktif.
    expect(find.text('SEDANG BERJALAN'), findsNothing);
    expect(find.text('Lanjutkan Belanja'), findsNothing);
    expect(find.text('Buat Daftar Belanja Baru'), findsOneWidget);
    expect(find.text('Daftar Sebelumnya'), findsOneWidget);
  });

  testWidgets('Membuat daftar baru membuka detail daftar aktif', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: BelanjaPasApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Buat Daftar Belanja Baru'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('shopping-list-name')),
      'Belanja Mingguan',
    );
    await tester.enterText(
      find.byKey(const ValueKey('shopping-list-budget')),
      '150000',
    );
    await tester.enterText(
      find.byKey(const ValueKey('shopping-item-name-0')),
      'Beras',
    );
    await tester.enterText(
      find.byKey(const ValueKey('shopping-item-quantity-0')),
      '2',
    );
    await tester.enterText(
      find.byKey(const ValueKey('shopping-item-price-0')),
      '15000',
    );
    await tester.tap(find.text('Buat & Aktifkan Daftar'));
    await tester.pumpAndSettle();

    expect(find.text('Belanja Mingguan'), findsOneWidget);
    expect(find.text('Beras'), findsOneWidget);
    expect(find.text('2x'), findsOneWidget);
    expect(find.text('Selesai Belanja'), findsOneWidget);
  });
}
