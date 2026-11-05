import 'package:aplikasi_daftar_belanja/features/shopping_list/data/dummy_data.dart';
import 'package:aplikasi_daftar_belanja/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  testWidgets('BelanjaPas App Smoke Test & Beranda Rendering', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: BelanjaPasApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Pastikan Brand "BelanjaPas" tampil
    expect(find.text('BelanjaPas'), findsOneWidget);

    // Pastikan Sapaan tampil
    expect(find.textContaining('Halo, Siti Rahma!'), findsOneWidget);

    // Pastikan kartu aktif tampil
    expect(find.text('SEDANG BERJALAN'), findsOneWidget);
    expect(find.text('Lanjutkan Belanja'), findsOneWidget);

    // Pastikan daftar sebelumnya tampil
    expect(find.text('Daftar Sebelumnya'), findsOneWidget);
    expect(find.text(DummyData.historyLists[0].name), findsOneWidget);
  });
}
