import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/utils/nav_utils.dart';
import 'package:reddit/core/utils/utils.dart';
import 'package:reddit/features/auth/auth_repo.dart';
import 'package:reddit/features/auth/login_screen.dart';
import 'package:reddit/features/home/home_screen.dart';
import 'package:reddit/models/user_model.dart';

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(ref.watch(authRepoProvider)),
);

final getUserDataProvider = StreamProvider.family(
  (ref, String uid) =>
      ref.watch(authControllerProvider.notifier).getUserData(uid),
);

class AuthController extends StateNotifier<bool> {
  AuthController(AuthRepo authRepo)
      : _authRepo = authRepo,
        super(false);

  final AuthRepo _authRepo;

  /// --------------------------------------------- `HELPERS`

  bool get isAuthenticated => _authRepo.isAuthenticated;
  UserModel? get user => _authRepo.getUser;

  /// --------------------------------------------- `METHODS`

  Future<void> signInWithGoogle(BuildContext context) async {
    state = true;
    final result = await _authRepo.signInWithGoogle();
    state = false;

    result.fold(
      (failure) => Utils.showSnackbar(context, failure.message),
      (r) {
        Utils.showSnackbar(context, 'Signed in successfully!');
        NavUtils.offAll(context, const HomeScreen());
      },
    );
  }

  Stream<UserModel> getUserData(String uid) => _authRepo.getUserData(uid);

  Future<void> logout(BuildContext context) async {
    await _authRepo.logout();
    if (!mounted) return;
    await NavUtils.to(context, const LoginScreen());
  }
}
