import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AuthUser {
  final String name;
  final String email;

  const AuthUser({required this.name, required this.email});
}

class AuthException implements Exception {
  final String message;

  const AuthException(this.message);
}

class AuthRepository {
  static const _boxName = 'user_accounts_box';
  static const _sessionKey = 'current_user_email';
  static const _onboardingKey = 'onboarding_completed';
  Box? _box;

  AuthUser? get currentUser {
    final email = _box?.get(_sessionKey) as String?;
    if (email == null) return null;

    final account = _box?.get(_accountKey(email));
    if (account is! Map) return null;
    return _userFromMap(Map<String, dynamic>.from(account));
  }

  bool get onboardingCompleted => (_box?.get(_onboardingKey) as bool?) ?? false;

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  Future<AuthUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final box = _requireBox();
    if (name.trim().isEmpty) {
      throw const AuthException('Nama wajib diisi.');
    }
    final normalizedEmail = email.trim().toLowerCase();
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(normalizedEmail)) {
      throw const AuthException('Masukkan email yang valid.');
    }
    if (password.length < 6) {
      throw const AuthException('Kata sandi minimal 6 karakter.');
    }
    final accountKey = _accountKey(normalizedEmail);
    if (box.containsKey(accountKey)) {
      throw const AuthException('Email sudah terdaftar.');
    }

    final salt = List<int>.generate(16, (_) => Random.secure().nextInt(256));
    final user = AuthUser(name: name.trim(), email: normalizedEmail);
    await box.put(accountKey, {
      'name': user.name,
      'email': user.email,
      'salt': base64UrlEncode(salt),
      'passwordHash': _hashPassword(password, salt),
    });
    await box.put(_sessionKey, normalizedEmail);
    return user;
  }

  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    final box = _requireBox();
    final normalizedEmail = email.trim().toLowerCase();
    final account = box.get(_accountKey(normalizedEmail));
    if (account is! Map) {
      throw const AuthException('Email atau kata sandi salah.');
    }

    final stored = Map<String, dynamic>.from(account);
    final salt = base64Url.decode(stored['salt'] as String);
    if (_hashPassword(password, salt) != stored['passwordHash']) {
      throw const AuthException('Email atau kata sandi salah.');
    }

    await box.put(_sessionKey, normalizedEmail);
    return _userFromMap(stored);
  }

  Future<void> logout() async {
    await _requireBox().delete(_sessionKey);
  }

  Future<void> completeOnboarding() async {
    await _requireBox().put(_onboardingKey, true);
  }

  Box _requireBox() {
    final box = _box;
    if (box == null || !box.isOpen) {
      throw StateError('AuthRepository belum diinisialisasi.');
    }
    return box;
  }

  String _accountKey(String email) => 'account:$email';

  String _hashPassword(String password, List<int> salt) {
    return sha256.convert([...salt, ...utf8.encode(password)]).toString();
  }

  AuthUser _userFromMap(Map<String, dynamic> map) {
    return AuthUser(name: map['name'] as String, email: map['email'] as String);
  }
}
