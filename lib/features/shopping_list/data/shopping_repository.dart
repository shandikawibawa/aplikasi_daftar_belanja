import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../domain/models/shopping_list.dart';
import 'dummy_data.dart';

class ShoppingRepository {
  static const String _boxName = 'shopping_lists_box';
  Box? _box;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);

    if (_box!.isEmpty) {
      await _seedInitialData();
    } else {
      // Remove the sample active list created by previous app versions.
      await _box!.delete('active_1');
    }
  }

  Future<void> _seedInitialData() async {
    for (final item in DummyData.historyLists) {
      await _box?.put(item.id, item.toMap());
    }
  }

  List<ShoppingList> getAllLists() {
    if (_box == null) return [];

    final list = <ShoppingList>[];
    for (final key in _box!.keys) {
      final raw = _box!.get(key);
      if (raw is Map) {
        final map = Map<String, dynamic>.from(raw);
        list.add(ShoppingList.fromMap(map));
      }
    }
    return list;
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
          .map(
            (i) => i.copyWith(
              id: const Uuid().v4(),
              isChecked: false,
              actualPrice: null,
            ),
          )
          .toList(),
    );
    await saveList(duplicated);
    return duplicated;
  }
}
