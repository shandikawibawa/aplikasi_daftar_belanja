import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/shopping_list/data/shopping_repository.dart';
import 'features/shopping_list/presentation/providers/shopping_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi locale formatting Bahasa Indonesia untuk intl
  await initializeDateFormatting('id_ID', null);

  // Inisialisasi penyimpanan lokal Hive.
  final shoppingRepo = ShoppingRepository();
  await shoppingRepo.init();

  runApp(
    ProviderScope(
      overrides: [shoppingRepositoryProvider.overrideWithValue(shoppingRepo)],
      child: const BelanjaPasApp(),
    ),
  );
}

class BelanjaPasApp extends StatelessWidget {
  const BelanjaPasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BelanjaPas',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
      locale: const Locale('id', 'ID'),
      supportedLocales: const [Locale('id', 'ID'), Locale('en', 'US')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
