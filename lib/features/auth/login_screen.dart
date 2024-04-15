import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/constants/images.dart';
import 'package:reddit/core/extensions/extensions.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: context.scrW,
            child: Image.asset(Images.login),
          ),
          const SizedBox(height: 50),
          ElevatedButton.icon(
            onPressed: () => ref.auth.signInWithGoogle(context),
            icon: ref.isAuthLoading
                ? loader
                : const Icon(Icons.account_circle, size: 30),
            label: const Text('Sign up with Google'),
          ),
        ],
      ),
    );
  }

  SizedBox get loader => const SizedBox(
        height: 15,
        width: 15,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
}
