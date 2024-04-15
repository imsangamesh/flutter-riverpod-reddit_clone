import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit/core/services/providers.dart';
import 'package:reddit/core/theme/theme_provider.dart';
import 'package:reddit/features/auth/auth_controller.dart';
import 'package:reddit/features/post/post_controller.dart';
import 'package:reddit/models/user_model.dart';
import 'package:uuid/uuid.dart';

extension ContextExt on BuildContext {
  MediaQueryData get media => MediaQuery.of(this);
  Size get size => media.size;

  double get scrH => size.height;
  double get scrW => size.width;
}

extension WidgetRefExt on WidgetRef {
  ThemeNotifier get theme => watch(themeProvider.notifier);
  AuthController get auth => watch(authControllerProvider.notifier);
  UserModel? get userModel => watch(authControllerProvider.notifier).user;

  bool get isDark => watch(themeProvider);
  bool get isAuthLoading => watch(authControllerProvider);
  bool get isPostLoading => watch(postControllerProvider);
}

extension RefExt on Ref {
  FirebaseFirestore get firestore => watch(firestoreProvider);
  FirebaseAuth get fireAuth => watch(fireAuthProvider);
  FirebaseStorage get fireStorage => watch(fireStorageProvider);
  GoogleSignIn get googleSignIn => watch(googleSignInProvider);
  GetStorage get getStorage => watch(getStorageProvider);
  Uuid get uuid => watch(uuidProvider);

  UserModel? get userModel => watch(authControllerProvider.notifier).user;
}
