import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../shopping_list/presentation/providers/shopping_provider.dart';
import '../../shopping_list/presentation/widgets/history_list_card.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyLists = ref.watch(historyShoppingListsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Riwayat Belanja',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
      ),
      body: historyLists.isEmpty
          ? const Center(
              child: Text(
                'Belum ada riwayat belanja yang selesai.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: historyLists.length,
              itemBuilder: (context, index) {
                final list = historyLists[index];
                return HistoryListCard(
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
                );
              },
            ),
    );
  }
}

