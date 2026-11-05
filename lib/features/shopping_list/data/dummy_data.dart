import '../domain/models/shopping_item.dart';
import '../domain/models/shopping_list.dart';

class DummyData {
  DummyData._();

  static ShoppingList get activeShoppingList {
    return ShoppingList(
      id: 'active_1',
      name: 'Belanja Mingguan Dapur',
      category: 'Dapur & Harian',
      createdAt: DateTime(2025, 5, 24), // Sabtu, 24 Mei 2025
      budget: 100000,
      status: ShoppingListStatus.active,
      items: [
        // 14 Barang yang sudah dibeli / tercentang (Total: Rp 85.000)
        const ShoppingItem(
          id: 'i1',
          name: 'Telur Ayam 500g',
          category: 'Protein',
          quantity: 1,
          estimatedPrice: 15000,
          actualPrice: 15000,
          isChecked: true,
          priority: ItemPriority.penting,
        ),
        const ShoppingItem(
          id: 'i2',
          name: 'Minyak Goreng 500ml',
          category: 'Kebutuhan Dapur',
          quantity: 1,
          estimatedPrice: 9000,
          actualPrice: 9000,
          isChecked: true,
          priority: ItemPriority.penting,
        ),
        const ShoppingItem(
          id: 'i3',
          name: 'Beras Ramos 2kg',
          category: 'Kebutuhan Dapur',
          quantity: 1,
          estimatedPrice: 26000,
          actualPrice: 26000,
          isChecked: true,
          priority: ItemPriority.penting,
        ),
        const ShoppingItem(
          id: 'i4',
          name: 'Bawang Merah 250g',
          category: 'Bumbu',
          quantity: 1,
          estimatedPrice: 6000,
          actualPrice: 6000,
          isChecked: true,
          priority: ItemPriority.penting,
        ),
        const ShoppingItem(
          id: 'i5',
          name: 'Bawang Putih 100g',
          category: 'Bumbu',
          quantity: 1,
          estimatedPrice: 4000,
          actualPrice: 4000,
          isChecked: true,
          priority: ItemPriority.penting,
        ),
        const ShoppingItem(
          id: 'i6',
          name: 'Cabai Rawit 100g',
          category: 'Bumbu',
          quantity: 1,
          estimatedPrice: 5000,
          actualPrice: 5000,
          isChecked: true,
          priority: ItemPriority.biasa,
        ),
        const ShoppingItem(
          id: 'i7',
          name: 'Tempe Balok',
          category: 'Protein',
          quantity: 1,
          estimatedPrice: 4000,
          actualPrice: 4000,
          isChecked: true,
          priority: ItemPriority.biasa,
        ),
        const ShoppingItem(
          id: 'i8',
          name: 'Tahu Putih',
          category: 'Protein',
          quantity: 1,
          estimatedPrice: 3000,
          actualPrice: 3000,
          isChecked: true,
          priority: ItemPriority.biasa,
        ),
        const ShoppingItem(
          id: 'i9',
          name: 'Bayam 1 Ikat',
          category: 'Sayuran',
          quantity: 1,
          estimatedPrice: 2500,
          actualPrice: 2500,
          isChecked: true,
          priority: ItemPriority.biasa,
        ),
        const ShoppingItem(
          id: 'i10',
          name: 'Wortel 250g',
          category: 'Sayuran',
          quantity: 1,
          estimatedPrice: 2500,
          actualPrice: 2500,
          isChecked: true,
          priority: ItemPriority.biasa,
        ),
        const ShoppingItem(
          id: 'i11',
          name: 'Garam Dapur Halus',
          category: 'Bumbu',
          quantity: 1,
          estimatedPrice: 2000,
          actualPrice: 2000,
          isChecked: true,
          priority: ItemPriority.biasa,
        ),
        const ShoppingItem(
          id: 'i12',
          name: 'Merica Bubuk',
          category: 'Bumbu',
          quantity: 1,
          estimatedPrice: 1000,
          actualPrice: 1000,
          isChecked: true,
          priority: ItemPriority.bolehDilewatkan,
        ),
        const ShoppingItem(
          id: 'i13',
          name: 'Kecap Manis Sachet',
          category: 'Bumbu',
          quantity: 1,
          estimatedPrice: 2000,
          actualPrice: 2000,
          isChecked: true,
          priority: ItemPriority.bolehDilewatkan,
        ),
        const ShoppingItem(
          id: 'i14',
          name: 'Saus Tiram',
          category: 'Bumbu',
          quantity: 1,
          estimatedPrice: 3000,
          actualPrice: 3000,
          isChecked: true,
          priority: ItemPriority.bolehDilewatkan,
        ),
        // 4 Barang yang belum dibeli / belum tercentang
        const ShoppingItem(
          id: 'i15',
          name: 'Sabun Cuci Piring',
          category: 'Kebersihan',
          quantity: 1,
          estimatedPrice: 5000,
          isChecked: false,
          priority: ItemPriority.biasa,
        ),
        const ShoppingItem(
          id: 'i16',
          name: 'Spons Cuci Piring',
          category: 'Kebersihan',
          quantity: 1,
          estimatedPrice: 2500,
          isChecked: false,
          priority: ItemPriority.bolehDilewatkan,
        ),
        const ShoppingItem(
          id: 'i17',
          name: 'Daun Bawang & Seledri',
          category: 'Sayuran',
          quantity: 1,
          estimatedPrice: 2500,
          isChecked: false,
          priority: ItemPriority.biasa,
        ),
        const ShoppingItem(
          id: 'i18',
          name: 'Kaldu Ayam Bubuk',
          category: 'Bumbu',
          quantity: 1,
          estimatedPrice: 5000,
          isChecked: false,
          priority: ItemPriority.bolehDilewatkan,
        ),
      ],
    );
  }

  static List<ShoppingList> get historyLists {
    return [
      // 1. Kebutuhan Bulanan Kos (24 barang, Rp 315.000 / Rp 350.000, Hemat Rp 35.000)
      ShoppingList(
        id: 'hist_1',
        name: 'Kebutuhan Bulanan Kos',
        category: 'Kos & Harian',
        createdAt: DateTime(2025, 5, 10), // 10 Mei 2025
        budget: 350000,
        status: ShoppingListStatus.completed,
        items: List.generate(
          24,
          (index) => ShoppingItem(
            id: 'h1_item_$index',
            name: 'Item Bulanan Kos #${index + 1}',
            category: 'Kos & Harian',
            quantity: 1,
            estimatedPrice: 14500,
            actualPrice: index == 0 ? 19000 : 12869, // total terpakai = 315.000
            isChecked: true,
          ),
        ),
      ),
      // 2. Bahan Pesta BBQ Keluarga (12 barang, Rp 198.500 / Rp 200.000, Pas Budget)
      ShoppingList(
        id: 'hist_2',
        name: 'Bahan Pesta BBQ Keluarga',
        category: 'Acara Keluarga',
        createdAt: DateTime(2025, 5, 2), // 2 Mei 2025
        budget: 200000,
        status: ShoppingListStatus.completed,
        items: [
          ...List.generate(
            11,
            (index) => ShoppingItem(
              id: 'h2_item_$index',
              name: 'Bahan BBQ #${index + 1}',
              category: 'Acara Keluarga',
              quantity: 1,
              estimatedPrice: 16500,
              actualPrice: 16500,
              isChecked: true,
            ),
          ),
          const ShoppingItem(
            id: 'h2_item_12',
            name: 'Bahan BBQ #12',
            category: 'Acara Keluarga',
            quantity: 1,
            estimatedPrice: 17000,
            actualPrice: 17000,
            isChecked: true,
          ),
        ], // 11 * 16500 = 181500 + 17000 = 198500
      ),
      // 3. Stok Bumbu & Sayur Segar (9 barang, Rp 74.000 / Rp 80.000, Hemat Rp 6.000)
      ShoppingList(
        id: 'hist_3',
        name: 'Stok Bumbu & Sayur Segar',
        category: 'Bumbu & Sayur',
        createdAt: DateTime(2025, 4, 25), // 25 Apr 2025
        budget: 80000,
        status: ShoppingListStatus.completed,
        items: [
          ...List.generate(
            8,
            (index) => ShoppingItem(
              id: 'h3_item_$index',
              name: 'Sayur Segar #${index + 1}',
              category: 'Bumbu & Sayur',
              quantity: 1,
              estimatedPrice: 8000,
              actualPrice: 8000,
              isChecked: true,
            ),
          ),
          const ShoppingItem(
            id: 'h3_item_9',
            name: 'Bumbu Dapur Segar',
            category: 'Bumbu & Sayur',
            quantity: 1,
            estimatedPrice: 10000,
            actualPrice: 10000,
            isChecked: true,
          ),
        ], // 8 * 8000 = 64000 + 10000 = 74000
      ),
    ];
  }
}

