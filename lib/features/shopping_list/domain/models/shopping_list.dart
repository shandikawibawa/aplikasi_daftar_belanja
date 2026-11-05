import 'shopping_item.dart';

/// Status daftar belanja
enum ShoppingListStatus {
  active,
  completed,
}

/// Model untuk daftar belanja
class ShoppingList {
  final String id;
  final String name;
  final String category;
  final DateTime createdAt;
  final int budget; // Budget yang dianggarkan dalam Rupiah
  final ShoppingListStatus status;
  final List<ShoppingItem> items;

  const ShoppingList({
    required this.id,
    required this.name,
    required this.category,
    required this.createdAt,
    required this.budget,
    this.status = ShoppingListStatus.active,
    this.items = const [],
  });

  bool get isActive => status == ShoppingListStatus.active;
  bool get isCompleted => status == ShoppingListStatus.completed;

  /// Total estimasi biaya seluruh barang (mengabaikan barang yang ada di rumah)
  int get totalEstimasi {
    return items.fold<int>(0, (sum, item) => sum + item.subtotalEstimasi);
  }

  /// Total biaya yang sudah terpakai (barang yang sudah tercentang / dibeli)
  int get totalTerpakai {
    return items
        .where((item) => item.isChecked)
        .fold<int>(0, (sum, item) => sum + item.subtotalTerpakai);
  }

  /// Sisa budget yang masih tersedia
  int get sisaBudget {
    return budget - totalTerpakai;
  }

  /// Rasio pemakaian budget (0.0 sampai 1.0+)
  double get persentaseBudget {
    if (budget <= 0) return 0.0;
    return totalTerpakai / budget;
  }

  /// Jumlah barang yang sudah dicentang
  int get jumlahTercentang {
    return items.where((item) => item.isChecked).length;
  }

  /// Total jumlah barang dalam daftar
  int get totalBarang => items.length;

  /// Rasio progres barang (0.0 sampai 1.0)
  double get persentaseBarang {
    if (totalBarang <= 0) return 0.0;
    return jumlahTercentang / totalBarang;
  }

  /// Persentase barang dibeli bulat (misal: 78)
  int get persentaseBarangInt {
    return (persentaseBarang * 100).round();
  }

  /// Penghematan uang (untuk daftar yang selesai)
  int get penghematan {
    final diff = budget - totalTerpakai;
    return diff > 0 ? diff : 0;
  }

  /// Menentukan apakah pengeluaran pas dengan budget (atau hemat < 1.000)
  bool get isPasBudget {
    final diff = (budget - totalTerpakai).abs();
    return diff <= 1500;
  }

  ShoppingList copyWith({
    String? id,
    String? name,
    String? category,
    DateTime? createdAt,
    int? budget,
    ShoppingListStatus? status,
    List<ShoppingItem>? items,
  }) {
    return ShoppingList(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      budget: budget ?? this.budget,
      status: status ?? this.status,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'budget': budget,
      'status': status.name,
      'items': items.map((i) => i.toMap()).toList(),
    };
  }

  factory ShoppingList.fromMap(Map<String, dynamic> map) {
    return ShoppingList(
      id: map['id'] as String,
      name: map['name'] as String,
      category: map['category'] as String? ?? 'Umum',
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime.now(),
      budget: (map['budget'] as num?)?.toInt() ?? 0,
      status: (map['status'] as String?) == 'completed'
          ? ShoppingListStatus.completed
          : ShoppingListStatus.active,
      items: (map['items'] as List<dynamic>?)
              ?.map((item) => ShoppingItem.fromMap(item as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}

