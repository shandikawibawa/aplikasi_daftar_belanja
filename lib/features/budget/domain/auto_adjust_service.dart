import '../../shopping_list/domain/models/shopping_item.dart';
import '../../shopping_list/domain/models/shopping_list.dart';

/// Catatan langkah perubahan pemangkasan item untuk auto-adjust
class AdjustmentStep {
  final String itemId;
  final String itemName;
  final int oldQuantity;
  final int newQuantity;
  final int savedAmount;
  final ItemPriority priority;

  const AdjustmentStep({
    required this.itemId,
    required this.itemName,
    required this.oldQuantity,
    required this.newQuantity,
    required this.savedAmount,
    required this.priority,
  });
}

/// Hasil dari kalkulasi auto-adjust budget
class AutoAdjustResult {
  final ShoppingList adjustedList;
  final List<AdjustmentStep> steps;
  final int totalSaved;
  final bool isWithinBudget;

  const AutoAdjustResult({
    required this.adjustedList,
    required this.steps,
    required this.totalSaved,
    required this.isWithinBudget,
  });
}

/// Layanan logika bisnis pemangkasan otomatis barang agar sesuai budget
class AutoAdjustService {
  const AutoAdjustService();

  AutoAdjustResult adjustList(ShoppingList list) {
    if (list.totalEstimasi <= list.budget) {
      return AutoAdjustResult(
        adjustedList: list,
        steps: const [],
        totalSaved: 0,
        isWithinBudget: true,
      );
    }

    final currentItems = list.items.map((e) => e.copyWith()).toList();
    final steps = <AdjustmentStep>[];
    int totalSaved = 0;

    int calculateCurrentTotal() {
      return currentItems.fold<int>(0, (sum, i) => sum + i.subtotalEstimasi);
    }

    while (calculateCurrentTotal() > list.budget) {
      // Filter barang yang masih bisa dikurangi (bukan ada di rumah dan qty > 0)
      final candidates = currentItems
          .where((item) => !item.isInStock && item.quantity > 0)
          .toList();

      if (candidates.isEmpty) {
        break; // Tidak ada barang lagi yang bisa dikurangi
      }

      // Urutkan prioritas terendah dulu (Boleh Dilewatkan -> Biasa -> Penting)
      // Jika prioritas sama, kurangi barang dengan harga subtotal tertinggi
      candidates.sort((a, b) {
        final priorityComparison = b.priority.order.compareTo(a.priority.order);
        if (priorityComparison != 0) return priorityComparison;
        return b.subtotalEstimasi.compareTo(a.subtotalEstimasi);
      });

      final targetItem = candidates.first;
      final targetIndex = currentItems.indexWhere((i) => i.id == targetItem.id);

      final oldQty = targetItem.quantity;
      final newQty = oldQty - 1;
      final savedAmount = targetItem.estimatedPrice;

      steps.add(
        AdjustmentStep(
          itemId: targetItem.id,
          itemName: targetItem.name,
          oldQuantity: oldQty,
          newQuantity: newQty,
          savedAmount: savedAmount,
          priority: targetItem.priority,
        ),
      );

      totalSaved += savedAmount;

      if (newQty <= 0) {
        currentItems.removeAt(targetIndex);
      } else {
        currentItems[targetIndex] = targetItem.copyWith(quantity: newQty);
      }
    }

    final updatedList = list.copyWith(items: currentItems);
    return AutoAdjustResult(
      adjustedList: updatedList,
      steps: steps,
      totalSaved: totalSaved,
      isWithinBudget: updatedList.totalEstimasi <= list.budget,
    );
  }
}

