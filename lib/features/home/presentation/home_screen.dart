import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../shopping_list/presentation/providers/shopping_provider.dart';
import '../../shopping_list/presentation/widgets/active_list_card.dart';
import '../../shopping_list/presentation/widgets/create_list_button.dart';
import '../../shopping_list/presentation/widgets/history_list_card.dart';
import '../../shopping_list/presentation/widgets/quick_categories_section.dart';
import 'widgets/greeting_section.dart';
import 'widgets/home_app_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeList = ref.watch(activeShoppingListProvider);
    final historyLists = ref.watch(historyShoppingListsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const HomeAppBar(),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // 1. Sapaan & Level Hemat
              const GreetingSection(
                userName: 'Siti Rahma!',
                savingLevel: 'Level Hemat: Bijak',
              ),

              const SizedBox(height: 6),

              // 2. Kartu Daftar Belanja Aktif (Sedang Berjalan)
              if (activeList != null)
                ActiveListCard(
                  list: activeList,
                  onContinueShopping: () {
                    context.push('/detail/${activeList.id}');
                  },
                ),

              // 3. Tombol Oranye "Buat Daftar Belanja Baru"
              CreateListButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Membuka form pembuatan daftar belanja baru...'),
                      backgroundColor: AppColors.primary,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              // 4. Header "Daftar Sebelumnya"
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.history_rounded,
                          size: 22,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Daftar Sebelumnya',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        context.go('/riwayat');
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                        child: Text(
                          'Lihat Semua>',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 4),

              // 5. Daftar Kartu Riwayat (3 Item sesuai desain gambar)
              ...historyLists.map(
                (list) => HistoryListCard(
                  list: list,
                  onDuplicate: () async {
                    final duplicated = await ref
                        .read(shoppingListsProvider.notifier)
                        .duplicateList(list.id);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Berhasil menyalin "${duplicated?.name}" ke daftar aktif!'),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  },
                  onViewDetail: () {
                    context.push('/detail/${list.id}');
                  },
                ),
              ),

              const SizedBox(height: 8),

              // 6. Section "Kategori Cepat" (Inspirasi Belanja: Sayuran, Protein, Kebersihan, Bumbu)
              const QuickCategoriesSection(),

              // Padding ekstra di bawah agar tidak tertutup bottom bar
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

