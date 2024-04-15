import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/errors/failure.dart';
import 'package:reddit/core/extensions/extensions.dart';
import 'package:reddit/core/services/typedefs.dart';
import 'package:reddit/models/community_model.dart';
import 'package:reddit/models/post_model.dart';

final communityRepoProvider = Provider(
  (ref) => CommunityRepo(fire: ref.firestore),
);

class CommunityRepo {
  CommunityRepo({required FirebaseFirestore fire}) : _fire = fire;

  final FirebaseFirestore _fire;

  /// --------------------------------------------- `GETTERS`

  CollectionReference get _communities =>
      _fire.collection(FireKeys.communities);

  CollectionReference get _posts => _fire.collection(FireKeys.posts);

  /// --------------------------------------------- `METHODS`

  FutureVoid createCommunity(Community community) async {
    try {
      final communityDoc = await _communities.doc(community.name).get();

      if (communityDoc.exists) {
        return left(
          Failure('Community with name "${community.name}" already exists!'),
        );
      }

      return right(_communities.doc(community.name).set(community.toMap()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid editCommunity(Community community) async {
    try {
      return right(
        _communities.doc(community.name).update(community.toMap()),
      );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid joinCommunity(String communityName, String uid) async {
    try {
      return right(
        _communities.doc(communityName).update({
          'members': FieldValue.arrayUnion([uid]),
        }),
      );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid leaveCommunity(String communityName, String uid) async {
    try {
      return right(
        _communities.doc(communityName).update({
          'members': FieldValue.arrayRemove([uid]),
        }),
      );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<Community> getCommunityByName(String name) {
    return _communities
        .doc(name)
        .snapshots()
        .map((event) => Community.fromMap(event.data()! as DataMap));
  }

  Stream<List<Community>> getUserCommunities(String uid) {
    return _communities.where('members', arrayContains: uid).snapshots().map(
          (event) => event.docs
              .map((e) => Community.fromMap(e.data()! as DataMap))
              .toList(),
        );
  }

  Stream<List<Post>> getCommunityPosts(String communityName) {
    return _posts
        .where('communityName', isEqualTo: communityName)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map((e) => Post.fromMap(e.data()! as DataMap))
              .toList(),
        );
  }

  FutureVoid addMods(String communityName, List<String> uids) async {
    try {
      return right(_communities.doc(communityName).update({'mods': uids}));
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
}
