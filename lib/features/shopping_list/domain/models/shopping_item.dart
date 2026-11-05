/// Tingkat prioritas barang belanja
enum ItemPriority {
  penting('Penting', 1),
  biasa('Biasa', 2),
  bolehDilewatkan('Boleh Dilewatkan', 3);

  final String label;
  final int order; // Digunakan untuk algoritma auto-adjust: urutan pemangkasan
  const ItemPriority(this.label, this.order);

  static ItemPriority fromString(String val) {
    return ItemPriority.values.firstWhere(
      (e) => e.name.toLowerCase() == val.toLowerCase() || e.label.toLowerCase() == val.toLowerCase(),
      orElse: () => ItemPriority.biasa,
    );
  }
}

/// Model untuk barang di dalam daftar belanja
class ShoppingItem {
  final String id;
  final String name;
  final String category;
  final int quantity;
  final int estimatedPrice; // Harga estimasi per unit dalam Rupiah
  final int? actualPrice; // Harga riil per unit saat dibeli (nullable)
  final bool isChecked; // Status tercentang (sudah diambil/dibeli)
  final bool isInStock; // "Ada di rumah" (tidak dihitung dalam total biaya)
  final ItemPriority priority;

  const ShoppingItem({
    required this.id,
    required this.name,
    required this.category,
    this.quantity = 1,
    required this.estimatedPrice,
    this.actualPrice,
    this.isChecked = false,
    this.isInStock = false,
    this.priority = ItemPriority.biasa,
  });

  /// Subtotal estimasi barang (0 jika sudah ada di rumah)
  int get subtotalEstimasi => isInStock ? 0 : (quantity * estimatedPrice);

  /// Subtotal harga riil / yang terpakai jika tercentang
  int get subtotalTerpakai {
    if (isInStock) return 0;
    final price = actualPrice ?? estimatedPrice;
    return quantity * price;
  }

  ShoppingItem copyWith({
    String? id,
    String? name,
    String? category,
    int? quantity,
    int? estimatedPrice,
    int? actualPrice,
    bool? isChecked,
    bool? isInStock,
    ItemPriority? priority,
  }) {
    return ShoppingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      estimatedPrice: estimatedPrice ?? this.estimatedPrice,
      actualPrice: actualPrice ?? this.actualPrice,
      isChecked: isChecked ?? this.isChecked,
      isInStock: isInStock ?? this.isInStock,
      priority: priority ?? this.priority,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'quantity': quantity,
      'estimatedPrice': estimatedPrice,
      'actualPrice': actualPrice,
      'isChecked': isChecked,
      'isInStock': isInStock,
      'priority': priority.name,
    };
  }

  factory ShoppingItem.fromMap(Map<String, dynamic> map) {
    return ShoppingItem(
      id: map['id'] as String,
      name: map['name'] as String,
      category: map['category'] as String? ?? 'Lainnya',
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
      estimatedPrice: (map['estimatedPrice'] as num?)?.toInt() ?? 0,
      actualPrice: (map['actualPrice'] as num?)?.toInt(),
      isChecked: map['isChecked'] as bool? ?? false,
      isInStock: map['isInStock'] as bool? ?? false,
      priority: ItemPriority.fromString(map['priority'] as String? ?? 'biasa'),
    );
  }
}

