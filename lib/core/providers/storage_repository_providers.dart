import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit/core/failure.dart';
import 'package:reddit/core/providers/firebase_providers.dart';
import 'package:reddit/core/typedefs.dart';

final storageRepositoryProvider = Provider(
  (ref) => StorageRepository(firebaseStorage: ref.read(storageProvider)),
);

class StorageRepository {
  StorageRepository({required FirebaseStorage firebaseStorage})
      : _firebaseStorage = firebaseStorage;

  final FirebaseStorage _firebaseStorage;

  FutureEither<String> storeFile({
    required String path,
    required String id,
    required File file,
  }) async {
    try {
      final uploadTask =
          await _firebaseStorage.ref().child(path).child(id).putFile(file);
      return right(await uploadTask.ref.getDownloadURL());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
