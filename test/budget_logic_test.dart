import 'package:aplikasi_daftar_belanja/features/budget/domain/auto_adjust_service.dart';
import 'package:aplikasi_daftar_belanja/features/budget/domain/budget_checker.dart';
import 'package:aplikasi_daftar_belanja/features/shopping_list/domain/models/shopping_item.dart';
import 'package:aplikasi_daftar_belanja/features/shopping_list/domain/models/shopping_list.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BudgetChecker tests', () {
    test('Kondisi sangat aman saat pemakaian < 80%', () {
      final status = BudgetChecker.checkStatus(terpakai: 70000, budget: 100000);
      expect(status, BudgetStatus.aman);
    });

    test('Hampir habis saat pemakaian 80% - 100%', () {
      final status = BudgetChecker.checkStatus(terpakai: 85000, budget: 100000);
      expect(status, BudgetStatus.hampirHabis);
    });

    test('Melebihi budget saat pemakaian > 100%', () {
      final status = BudgetChecker.checkStatus(terpakai: 110000, budget: 100000);
      expect(status, BudgetStatus.melebihi);
    });
  });

  group('AutoAdjustService tests', () {
    test('Mengurangi barang dengan prioritas bolehDilewatkan terlebih dahulu', () {
      const service = AutoAdjustService();
      final list = ShoppingList(
        id: 'test_1',
        name: 'Daftar Uji',
        category: 'Uji',
        createdAt: DateTime.now(),
        budget: 50000,
        items: const [
          ShoppingItem(
            id: '1',
            name: 'Beras Penting',
            category: 'Kebutuhan Pokok',
            quantity: 1,
            estimatedPrice: 40000,
            priority: ItemPriority.penting,
          ),
          ShoppingItem(
            id: '2',
            name: 'Camilan',
            category: 'Snack',
            quantity: 2,
            estimatedPrice: 15000, // Subtotal 30000
            priority: ItemPriority.bolehDilewatkan,
          ),
        ],
      );

      // Total awal: 40.000 + 30.000 = 70.000 (> 50.000)
      expect(list.totalEstimasi, 70000);

      final result = service.adjustList(list);

      // Setelah dipangkas 2 camilan (30.000 saved), total jadi 40.000 (<= 50.000)
      expect(result.isWithinBudget, true);
      expect(result.adjustedList.totalEstimasi <= 50000, true);
      expect(result.steps.isNotEmpty, true);
      expect(result.steps.first.priority, ItemPriority.bolehDilewatkan);
    });

    test('Barang "Ada di rumah" (isInStock) tidak dihitung dalam total', () {
      final list = ShoppingList(
        id: 'test_2',
        name: 'Daftar Stok',
        category: 'Uji',
        createdAt: DateTime.now(),
        budget: 50000,
        items: const [
          ShoppingItem(
            id: '1',
            name: 'Garam (Ada di rumah)',
            category: 'Bumbu',
            quantity: 2,
            estimatedPrice: 5000,
            isInStock: true, // Ada di rumah
            priority: ItemPriority.biasa,
          ),
          ShoppingItem(
            id: '2',
            name: 'Ayam Potong',
            category: 'Protein',
            quantity: 1,
            estimatedPrice: 35000,
            isInStock: false,
            priority: ItemPriority.penting,
          ),
        ],
      );

      expect(list.totalEstimasi, 35000);
      expect(list.sisaBudget, 50000); // belum ada yang terpakai
    });
  });
}

