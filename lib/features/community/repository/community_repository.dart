import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit/core/constants/firebase_constants.dart';
import 'package:reddit/core/failure.dart';
import 'package:reddit/core/providers/firebase_providers.dart';
import 'package:reddit/core/typedefs.dart';
import 'package:reddit/models/community_model.dart';
import 'package:reddit/models/post_model.dart';

final communityRepositoryProvider = Provider((ref) {
  return CommunityRepository(firestore: ref.read(firestoreProvider));
});

class CommunityRepository {
  CommunityRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  FutureVoid createCommunity(Community community) async {
    try {
      final communityDoc = await _communities.doc(community.name).get();

      if (communityDoc.exists) {
        return left(
          Failure(
            'Community with the name ${community.name} already exists!',
          ),
        );
      }

      return right(_communities.doc(community.name).set(community.toMap()));
    } on FirebaseException catch (e) {
      return left(Failure(e.toString()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid joinCommunity(String name, String uid) async {
    try {
      return right(
        await _communities.doc(name).update({
          'members': FieldValue.arrayUnion([uid]),
        }),
      );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid leaveCommunity(String name, String uid) async {
    try {
      return right(
        await _communities.doc(name).update({
          'members': FieldValue.arrayRemove([uid]),
        }),
      );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Community>> getUserCommunities(String uid) {
    return _communities
        .where('members', arrayContains: uid)
        .snapshots()
        .map((event) {
      final communities = <Community>[];

      for (final doc in event.docs) {
        communities.add(Community.fromMap(doc.data()! as Map<String, dynamic>));
      }

      return communities;
    });
  }

  Stream<Community> getCommunityByName(String name) {
    return _communities.doc(name).snapshots().map(
          (commSnap) =>
              Community.fromMap(commSnap.data()! as Map<String, dynamic>),
        );
  }

  FutureVoid editCommunity(Community community) async {
    try {
      return right(
        await _communities.doc(community.name).update(community.toMap()),
      );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communities
        .where(
          'name',
          isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
          isLessThan: query.isEmpty
              ? null
              : query.substring(0, query.length - 1) +
                  String.fromCharCode(query.codeUnitAt(query.length - 1) + 1),
        )
        .snapshots()
        .map((event) {
      final communities = <Community>[];
      for (final comm in event.docs) {
        communities
            .add(Community.fromMap(comm.data()! as Map<String, dynamic>));
      }
      return communities;
    });
  }

  FutureVoid addMods(String name, List<String> uids) async {
    try {
      return right(
        await _communities.doc(name).update({'mods': uids}),
      );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  CollectionReference get _communities =>
      _firestore.collection(FirebaseConstants.communities);

  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.posts);

  Stream<List<Post>> getCommunityPosts(String name) {
    return _posts
        .where('communityName', isEqualTo: name)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map((e) => Post.fromMap(e.data()! as Map<String, dynamic>))
              .toList(),
        );
  }
}
