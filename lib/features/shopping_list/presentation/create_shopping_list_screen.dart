import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/theme/app_colors.dart';
import '../domain/models/shopping_item.dart';
import 'providers/shopping_provider.dart';

class CreateShoppingListScreen extends ConsumerStatefulWidget {
  const CreateShoppingListScreen({super.key});

  @override
  ConsumerState<CreateShoppingListScreen> createState() =>
      _CreateShoppingListScreenState();
}

class _CreateShoppingListScreenState
    extends ConsumerState<CreateShoppingListScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _budgetController = TextEditingController();
  final List<_ShoppingItemDraft> _itemDrafts = [_ShoppingItemDraft()];
  String _category = 'Umum';
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _budgetController.dispose();
    for (final draft in _itemDrafts) {
      draft.dispose();
    }
    super.dispose();
  }

  Future<void> _createList() async {
    if (!_formKey.currentState!.validate()) return;

    final items = _itemDrafts
        .map(
          (draft) => ShoppingItem(
            id: const Uuid().v4(),
            name: draft.nameController.text.trim(),
            category: _category,
            quantity: int.parse(draft.quantityController.text.trim()),
            estimatedPrice: int.parse(draft.priceController.text.trim()),
          ),
        )
        .toList();

    setState(() => _isSaving = true);
    try {
      final list = await ref
          .read(shoppingListsProvider.notifier)
          .createList(
            name: _nameController.text.trim(),
            category: _category,
            budget: int.parse(_budgetController.text.trim()),
            items: items,
          );
      if (mounted) context.replace('/detail/${list.id}');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _addItem() {
    setState(() => _itemDrafts.add(_ShoppingItemDraft()));
  }

  void _removeItem(int index) {
    final draft = _itemDrafts.removeAt(index);
    draft.dispose();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Buat Daftar Belanja',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              key: const ValueKey('shopping-list-name'),
              controller: _nameController,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Nama daftar',
                hintText: 'Contoh: Belanja mingguan',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama daftar wajib diisi.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),
              items:
                  const [
                        'Umum',
                        'Dapur & Harian',
                        'Sayuran',
                        'Protein',
                        'Kebersihan',
                      ]
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _category = value);
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const ValueKey('shopping-list-budget'),
              controller: _budgetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Anggaran (Rupiah)',
                hintText: 'Contoh: 150000',
                prefixText: 'Rp ',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final budget = int.tryParse(value?.trim() ?? '');
                if (budget == null || budget <= 0) {
                  return 'Masukkan anggaran lebih dari Rp 0.';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Barang Belanja',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton.icon(
                  onPressed: _addItem,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Tambah barang'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...List.generate(_itemDrafts.length, (index) {
              final draft = _itemDrafts[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Barang ${index + 1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (_itemDrafts.length > 1)
                            IconButton(
                              tooltip: 'Hapus barang ${index + 1}',
                              onPressed: () => _removeItem(index),
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                color: AppColors.danger,
                              ),
                            ),
                        ],
                      ),
                      TextFormField(
                        key: ValueKey('shopping-item-name-$index'),
                        controller: draft.nameController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          labelText: 'Nama item',
                          hintText: 'Contoh: Beras',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nama item wajib diisi.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 100,
                            child: TextFormField(
                              key: ValueKey('shopping-item-quantity-$index'),
                              controller: draft.quantityController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Jumlah',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                final quantity = int.tryParse(
                                  value?.trim() ?? '',
                                );
                                if (quantity == null || quantity <= 0) {
                                  return 'Min. 1';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              key: ValueKey('shopping-item-price-$index'),
                              controller: draft.priceController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Harga satuan',
                                hintText: 'Contoh: 15000',
                                prefixText: 'Rp ',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                final price = int.tryParse(value?.trim() ?? '');
                                if (price == null || price <= 0) {
                                  return 'Masukkan harga lebih dari Rp 0.';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 24),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _createList,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orangePrimary,
                  foregroundColor: AppColors.orangeButtonText,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Buat & Aktifkan Daftar',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShoppingItemDraft {
  final nameController = TextEditingController();
  final quantityController = TextEditingController(text: '1');
  final priceController = TextEditingController();

  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    priceController.dispose();
  }
}
