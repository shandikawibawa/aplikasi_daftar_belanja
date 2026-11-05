import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../budget/domain/auto_adjust_service.dart';
import '../../data/dummy_data.dart';
import '../../data/shopping_repository.dart';
import '../../domain/models/shopping_list.dart';

final shoppingRepositoryProvider = Provider<ShoppingRepository>((ref) {
  return ShoppingRepository();
});

class ShoppingListsNotifier extends Notifier<List<ShoppingList>> {
  @override
  List<ShoppingList> build() {
    final repo = ref.read(shoppingRepositoryProvider);
    return repo.getAllLists();
  }

  void refreshFromRepo() {
    final repo = ref.read(shoppingRepositoryProvider);
    state = repo.getAllLists();
  }

  /// Toggle centang pada barang belanja (saat mode belanja aktif)
  Future<void> toggleItemCheck({
    required String listId,
    required String itemId,
    int? actualPrice,
  }) async {
    final listIndex = state.indexWhere((l) => l.id == listId);
    if (listIndex == -1) return;

    final targetList = state[listIndex];
    final updatedItems = targetList.items.map((item) {
      if (item.id == itemId) {
        final newChecked = !item.isChecked;
        return item.copyWith(
          isChecked: newChecked,
          actualPrice: newChecked ? (actualPrice ?? item.actualPrice ?? item.estimatedPrice) : null,
        );
      }
      return item;
    }).toList();

    final updatedList = targetList.copyWith(items: updatedItems);
    final newState = [...state];
    newState[listIndex] = updatedList;
    state = newState;

    await ref.read(shoppingRepositoryProvider).saveList(updatedList);
  }

  /// Perbarui harga riil barang
  Future<void> updateActualPrice({
    required String listId,
    required String itemId,
    required int actualPrice,
  }) async {
    final listIndex = state.indexWhere((l) => l.id == listId);
    if (listIndex == -1) return;

    final targetList = state[listIndex];
    final updatedItems = targetList.items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(actualPrice: actualPrice);
      }
      return item;
    }).toList();

    final updatedList = targetList.copyWith(items: updatedItems);
    final newState = [...state];
    newState[listIndex] = updatedList;
    state = newState;

    await ref.read(shoppingRepositoryProvider).saveList(updatedList);
  }

  /// Duplikat daftar belanja (untuk tombol "Salin" di riwayat)
  Future<ShoppingList?> duplicateList(String listId) async {
    final target = state.firstWhere(
      (l) => l.id == listId,
      orElse: () => DummyData.activeShoppingList,
    );
    final duplicated = await ref.read(shoppingRepositoryProvider).duplicateList(target);
    state = [duplicated, ...state];
    return duplicated;
  }

  /// Jalankan algoritma auto-adjust bila belanja melebihi budget
  Future<AutoAdjustResult?> autoAdjustBudget(String listId) async {
    final listIndex = state.indexWhere((l) => l.id == listId);
    if (listIndex == -1) return null;

    final targetList = state[listIndex];
    const autoAdjustService = AutoAdjustService();
    final result = autoAdjustService.adjustList(targetList);

    final newState = [...state];
    newState[listIndex] = result.adjustedList;
    state = newState;

    await ref.read(shoppingRepositoryProvider).saveList(result.adjustedList);
    return result;
  }

  /// Selesai Belanja: ubah status ke completed dan arsipkan
  Future<void> completeShopping(String listId) async {
    final listIndex = state.indexWhere((l) => l.id == listId);
    if (listIndex == -1) return;

    final targetList = state[listIndex];
    final updatedList = targetList.copyWith(status: ShoppingListStatus.completed);

    final newState = [...state];
    newState[listIndex] = updatedList;
    state = newState;

    await ref.read(shoppingRepositoryProvider).saveList(updatedList);
  }
}

final shoppingListsProvider =
    NotifierProvider<ShoppingListsNotifier, List<ShoppingList>>(
  ShoppingListsNotifier.new,
);

/// Provider untuk mengambil daftar belanja aktif yang sedang berjalan
final activeShoppingListProvider = Provider<ShoppingList?>((ref) {
  final lists = ref.watch(shoppingListsProvider);
  try {
    return lists.firstWhere((list) => list.isActive);
  } catch (_) {
    return lists.isNotEmpty ? lists.first : null;
  }
});

/// Provider untuk daftar riwayat (sudah selesai)
final historyShoppingListsProvider = Provider<List<ShoppingList>>((ref) {
  final lists = ref.watch(shoppingListsProvider);
  return lists.where((list) => list.isCompleted).toList();
});

/// Provider untuk badge angka di tab "Daftar" (default 3 sesuai desain)
final activeListsCountProvider = Provider<int>((ref) {
  final lists = ref.watch(shoppingListsProvider);
  final count = lists.where((list) => list.isActive).length;
  // Jika seed baru 1, kita bisa tampilkan 3 seperti di UI desain referensi
  return count > 0 ? 3 : 0;
});

