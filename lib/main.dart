import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:reddit/core/extensions/extensions.dart';
import 'package:reddit/core/theme/app_theme.dart';
import 'package:reddit/features/auth/login_screen.dart';
import 'package:reddit/features/home/home_screen.dart';
import 'package:reddit/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ref.isDark ? ThemeMode.dark : ThemeMode.light,
      home: ref.auth.isAuthenticated ? const HomeScreen() : const LoginScreen(),
    );
  }
}



/*

TODO: 

- create different constructors for different post types and implement it in 
postController

*/
