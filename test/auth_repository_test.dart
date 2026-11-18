import 'dart:io';

import 'package:aplikasi_daftar_belanja/features/auth/data/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  late Directory storageDirectory;

  setUp(() async {
    storageDirectory = await Directory.systemTemp.createTemp('belanjapas_auth');
    Hive.init(storageDirectory.path);
  });

  tearDown(() async {
    await Hive.close();
    await storageDirectory.delete(recursive: true);
  });

  test('akun dan sesi tersimpan, logout tidak menghapus akun', () async {
    final repository = AuthRepository();
    await repository.init();

    final registered = await repository.register(
      name: 'Dewi Putri',
      email: 'Dewi@Example.com',
      password: 'rahasia123',
    );
    expect(registered.name, 'Dewi Putri');
    expect(registered.email, 'dewi@example.com');

    final storedAccount = Hive.box('user_accounts_box')
        .get('account:dewi@example.com') as Map;
    expect(storedAccount['passwordHash'], isNot('rahasia123'));

    final reopenedRepository = AuthRepository();
    await reopenedRepository.init();
    expect(reopenedRepository.currentUser?.email, 'dewi@example.com');

    await reopenedRepository.logout();
    expect(reopenedRepository.currentUser, isNull);

    final loggedIn = await reopenedRepository.login(
      email: 'DEWI@example.com',
      password: 'rahasia123',
    );
    expect(loggedIn.name, 'Dewi Putri');
  });

  test('email yang sudah digunakan tidak bisa didaftarkan ulang', () async {
    final repository = AuthRepository();
    await repository.init();
    await repository.register(
      name: 'Dewi Putri',
      email: 'dewi@example.com',
      password: 'rahasia123',
    );

    await expectLater(
      repository.register(
        name: 'Dewi Lain',
        email: 'DEWI@example.com',
        password: 'rahasia456',
      ),
      throwsA(isA<AuthException>()),
    );
  });
}
