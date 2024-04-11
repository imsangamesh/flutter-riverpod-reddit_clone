import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/utils.dart';
import 'package:reddit/features/auth/repository/auth_repository.dart';
import 'package:reddit/models/user_model.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  ),
);

final authStateChangeProvider = StreamProvider(
  (ref) => ref.watch(authControllerProvider.notifier).authStateChange,
);

final getUserDataProvider = StreamProvider.family(
  (ref, String uid) =>
      ref.watch(authControllerProvider.notifier).getUserData(uid),
);

class AuthController extends StateNotifier<bool> {
  AuthController({
    required AuthRepository authRepository,
    required Ref ref,
  })  : _authRepository = authRepository,
        _ref = ref,
        super(false);

  final AuthRepository _authRepository;
  final Ref _ref;

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  Future<void> signInWithGoogle(
    BuildContext context, {
    required bool isFromLogin,
  }) async {
    state = true;
    final user =
        await _authRepository.signInWithGoogle(isFromLogin: isFromLogin);
    state = false;

    user.fold(
      (failure) => showSnackbar(context, failure.message),
      (um) => _ref.read(userProvider.notifier).update((_) => um),
    );
  }

  Future<void> signInAsGuest(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInAsGuest();
    state = false;

    user.fold(
      (failure) => showSnackbar(context, failure.message),
      (um) => _ref.read(userProvider.notifier).update((_) => um),
    );
  }

  Stream<UserModel> getUserData(String uid) => _authRepository.getUserData(uid);

  Future<void> logout() async {
    await _authRepository.logout();
  }
}
