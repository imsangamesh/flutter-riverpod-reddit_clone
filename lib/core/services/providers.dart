import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';

final googleSignInProvider = Provider((_) => GoogleSignIn());

final fireAuthProvider = Provider((_) => FirebaseAuth.instance);

final firestoreProvider = Provider((_) => FirebaseFirestore.instance);

final fireStorageProvider = Provider((_) => FirebaseStorage.instance);

final getStorageProvider = Provider((_) => GetStorage());

final uuidProvider = Provider((_) => const Uuid());
