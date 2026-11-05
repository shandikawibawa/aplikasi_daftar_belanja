import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../presentation/providers/shopping_provider.dart';
import '../presentation/widgets/active_list_card.dart';

class ShoppingListsScreen extends ConsumerWidget {
  const ShoppingListsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lists = ref.watch(shoppingListsProvider);
    final activeLists = lists.where((l) => l.isActive).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Daftar Belanja',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
      ),
      body: activeLists.isEmpty
          ? const Center(
              child: Text(
                'Belum ada daftar belanja yang aktif.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: activeLists.length,
              itemBuilder: (context, index) {
                final list = activeLists[index];
                return ActiveListCard(
                  list: list,
                  onContinueShopping: () {
                    context.push('/detail/${list.id}');
                  },
                );
              },
            ),
    );
  }
}

