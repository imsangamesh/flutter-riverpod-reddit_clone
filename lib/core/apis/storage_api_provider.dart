import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit/core/errors/failure.dart';
import 'package:reddit/core/extensions/extensions.dart';
import 'package:reddit/core/services/typedefs.dart';

final fireStorageApiProvider = Provider(
  (ref) => FireStorageApi(firebaseStorage: ref.fireStorage),
);

class FireStorageApi {
  FireStorageApi({required FirebaseStorage firebaseStorage})
      : _fireStorage = firebaseStorage;

  final FirebaseStorage _fireStorage;

  FutureEither<String> storeFile({
    required String path,
    required String id,
    required File file,
  }) async {
    try {
      final uploadTask =
          await _fireStorage.ref().child(path).child(id).putFile(file);
      return right(await uploadTask.ref.getDownloadURL());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
