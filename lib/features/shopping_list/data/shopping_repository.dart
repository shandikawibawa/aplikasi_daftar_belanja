import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../domain/models/shopping_list.dart';
import 'dummy_data.dart';

class ShoppingRepository {
  static const String _boxName = 'shopping_lists_box';
  Box? _box;

  Future<void> init() async {
    try {
      await Hive.initFlutter();
      _box = await Hive.openBox(_boxName);
      
      // Jika box masih kosong, isi dengan seed dummy data
      if (_box!.isEmpty) {
        await _seedInitialData();
      }
    } catch (_) {
      // Fallback jika Hive belum siap di environment tertentu
    }
  }

  Future<void> _seedInitialData() async {
    final active = DummyData.activeShoppingList;
    final history = DummyData.historyLists;

    await _box?.put(active.id, active.toMap());
    for (final item in history) {
      await _box?.put(item.id, item.toMap());
    }
  }

  List<ShoppingList> getAllLists() {
    if (_box == null || _box!.isEmpty) {
      return [
        DummyData.activeShoppingList,
        ...DummyData.historyLists,
      ];
    }

    try {
      final list = <ShoppingList>[];
      for (final key in _box!.keys) {
        final raw = _box!.get(key);
        if (raw is Map) {
          final map = Map<String, dynamic>.from(raw);
          list.add(ShoppingList.fromMap(map));
        }
      }
      if (list.isEmpty) {
        return [DummyData.activeShoppingList, ...DummyData.historyLists];
      }
      return list;
    } catch (_) {
      return [DummyData.activeShoppingList, ...DummyData.historyLists];
    }
  }

  Future<void> saveList(ShoppingList list) async {
    if (_box != null) {
      await _box!.put(list.id, list.toMap());
    }
  }

  Future<void> deleteList(String id) async {
    if (_box != null) {
      await _box!.delete(id);
    }
  }

  Future<ShoppingList> duplicateList(ShoppingList original) async {
    final newId = const Uuid().v4();
    final duplicated = original.copyWith(
      id: newId,
      name: '${original.name} (Salinan)',
      createdAt: DateTime.now(),
      status: ShoppingListStatus.active,
      items: original.items
          .map((i) => i.copyWith(
                id: const Uuid().v4(),
                isChecked: false,
                actualPrice: null,
              ))
          .toList(),
    );
    await saveList(duplicated);
    return duplicated;
  }
}

