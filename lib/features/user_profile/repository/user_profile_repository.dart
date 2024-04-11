import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit/core/constants/firebase_constants.dart';
import 'package:reddit/core/failure.dart';
import 'package:reddit/core/providers/firebase_providers.dart';
import 'package:reddit/core/typedefs.dart';
import 'package:reddit/models/post_model.dart';
import 'package:reddit/models/user_model.dart';

final userProfileRepositoryProvider = Provider((ref) {
  return UserProfileRepository(firestore: ref.read(firestoreProvider));
});

class UserProfileRepository {
  UserProfileRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.users);

  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.posts);

  FutureVoid editProfile(UserModel user) async {
    try {
      return right(
        await _users.doc(user.uid).update(user.toMap()),
      );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Post>> getUserPosts(String uid) {
    return _posts
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map((e) => Post.fromMap(e.data()! as Map<String, dynamic>))
              .toList(),
        );
  }

  FutureVoid updateUserKarma(UserModel user) async {
    try {
      return right(
        await _users.doc(user.uid).update({
          'karma': user.karma,
        }),
      );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
