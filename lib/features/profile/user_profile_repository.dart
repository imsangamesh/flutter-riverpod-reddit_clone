import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/errors/failure.dart';
import 'package:reddit/core/extensions/extensions.dart';
import 'package:reddit/core/services/typedefs.dart';
import 'package:reddit/models/post_model.dart';
import 'package:reddit/models/user_model.dart';

final userProfileRepositoryProvider = Provider((ref) {
  return UserProfileRepository(fire: ref.firestore);
});

class UserProfileRepository {
  UserProfileRepository({required FirebaseFirestore fire}) : _fire = fire;

  final FirebaseFirestore _fire;

  CollectionReference get _users => _fire.collection(FireKeys.users);

  CollectionReference get _posts => _fire.collection(FireKeys.posts);

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
