import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/errors/failure.dart';
import 'package:reddit/core/extensions/extensions.dart';
import 'package:reddit/core/services/typedefs.dart';
import 'package:reddit/models/comment_model.dart';
import 'package:reddit/models/post_model.dart';

final postRepoProvider = Provider((ref) => PostRepo(fire: ref.firestore));

class PostRepo {
  PostRepo({required FirebaseFirestore fire}) : _fire = fire;

  final FirebaseFirestore _fire;

  /// ---------------------------------------------- `GETTERS`

  CollectionReference get _posts => _fire.collection(FireKeys.posts);
  CollectionReference get _commments => _fire.collection(FireKeys.comments);

  /// ---------------------------------------------- `METHODS`

  FutureVoid createPost(Post post) async {
    try {
      return right(_posts.doc(post.id).set(post.toMap()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<void> upVote(Post post, String uid) async {
    // we remove him from 'downVotes' either way
    if (post.downVotes.contains(uid)) {
      await _posts.doc(post.id).update({
        'downVotes': FieldValue.arrayRemove([uid]),
      });
    }

    if (post.upVotes.contains(uid)) {
      // remove if he already upVoted
      await _posts.doc(post.id).update({
        'upVotes': FieldValue.arrayRemove([uid]),
      });
    } else {
      // add if he didn't upVote
      await _posts.doc(post.id).update({
        'upVotes': FieldValue.arrayUnion([uid]),
      });
    }
  }

  Future<void> downVote(Post post, String uid) async {
    // we remove him from 'upVotes' either way
    if (post.upVotes.contains(uid)) {
      await _posts.doc(post.id).update({
        'upVotes': FieldValue.arrayRemove([uid]),
      });
    }

    if (post.downVotes.contains(uid)) {
      // remove if he already downVoted
      await _posts.doc(post.id).update({
        'downVotes': FieldValue.arrayRemove([uid]),
      });
    } else {
      // add if he didn't downVote
      await _posts.doc(post.id).update({
        'downVotes': FieldValue.arrayUnion([uid]),
      });
    }
  }

  FutureVoid deletePost(String postId) async {
    try {
      return right(_posts.doc(postId).delete());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<Post> getPostById(String postId) {
    return _posts
        .doc(postId)
        .snapshots()
        .map((event) => Post.fromMap(event.data()! as DataMap));
  }

  /// ---------------------------------------------- `USER FEED`

  Stream<List<Post>> fetchUserFeed(List<String> communityNames) {
    log(communityNames.toString());
    return _posts
        .where('communityName', whereIn: communityNames)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map((e) => Post.fromMap(e.data()! as DataMap))
              .toList(),
        );
  }

  Stream<List<Post>> fetchGuestFeed() {
    return _posts
        .orderBy('createdAt', descending: true)
        .limit(10)
        .snapshots()
        .map(
          (event) => event.docs
              .map((e) => Post.fromMap(e.data()! as DataMap))
              .toList(),
        );
  }

  /// ---------------------------------------------- `COMMENTS`

  FutureVoid addComment(Comment comment) async {
    try {
      await _commments.doc(comment.id).set(comment.toMap());
      return right(
        _posts.doc(comment.postId).update({
          'commentCount': FieldValue.increment(1),
        }),
      );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid deleteComment(String commmentId, String postId) async {
    try {
      await _commments.doc(commmentId).delete();
      return right(
        _posts.doc(postId).update({
          'commentCount': FieldValue.increment(-1),
        }),
      );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Comment>> getCommentsofPost(String postId) {
    return _commments
        .where('postId', isEqualTo: postId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map((e) => Comment.fromMap(e.data()! as DataMap))
              .toList(),
        );
  }
}
