import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authProvider = NotifierProvider<AuthNotifier, AuthUser?>(
  AuthNotifier.new,
);

class AuthNotifier extends Notifier<AuthUser?> {
  @override
  AuthUser? build() => ref.read(authRepositoryProvider).currentUser;

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = await ref
        .read(authRepositoryProvider)
        .register(name: name, email: email, password: password);
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = await ref
        .read(authRepositoryProvider)
        .login(email: email, password: password);
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = null;
  }
}
