import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit/core/constants/firebase_constants.dart';
import 'package:reddit/core/failure.dart';
import 'package:reddit/core/providers/firebase_providers.dart';
import 'package:reddit/core/typedefs.dart';
import 'package:reddit/models/comment_model.dart';
import 'package:reddit/models/community_model.dart';
import 'package:reddit/models/post_model.dart';

final postRepositoryProvider = Provider((ref) {
  return PostRepository(firestore: ref.read(firestoreProvider));
});

class PostRepository {
  PostRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.posts);
  CollectionReference get _comments =>
      _firestore.collection(FirebaseConstants.comments);
  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.users);

  FutureVoid addPost(Post post) async {
    try {
      return right(
        await _posts.doc(post.id).set(post.toMap()),
      );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Post>> fetchUserPosts(List<Community> communities) {
    return _posts
        .where(
          'communityName',
          whereIn: communities.map((e) => e.name).toList(),
        )
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map((e) => Post.fromMap(e.data()! as Map<String, dynamic>))
              .toList(),
        );
  }

  Stream<List<Post>> fetchGuestPosts() {
    return _posts
        .orderBy('createdAt', descending: true)
        .limit(10)
        .snapshots()
        .map(
          (event) => event.docs
              .map((e) => Post.fromMap(e.data()! as Map<String, dynamic>))
              .toList(),
        );
  }

  FutureVoid deletePost(Post post) async {
    try {
      return right(_posts.doc(post.id).delete());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<void> upVote(Post post, String uid) async {
    if (post.downVotes.contains(uid)) {
      await _posts.doc(post.id).update({
        'downVotes': FieldValue.arrayRemove([uid]),
      });
    }
    if (post.upVotes.contains(uid)) {
      await _posts.doc(post.id).update({
        'upVotes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await _posts.doc(post.id).update({
        'upVotes': FieldValue.arrayUnion([uid]),
      });
    }
  }

  Future<void> downVote(Post post, String uid) async {
    if (post.upVotes.contains(uid)) {
      await _posts.doc(post.id).update({
        'upVotes': FieldValue.arrayRemove([uid]),
      });
    }
    if (post.downVotes.contains(uid)) {
      await _posts.doc(post.id).update({
        'downVotes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await _posts.doc(post.id).update({
        'downVotes': FieldValue.arrayUnion([uid]),
      });
    }
  }

  Stream<Post> getPostById(String postId) {
    return _posts
        .doc(postId)
        .snapshots()
        .map((event) => Post.fromMap(event.data()! as Map<String, dynamic>));
  }

  FutureVoid addComment(Comment comment) async {
    try {
      await _comments.doc(comment.id).set(comment.toMap());
      return right(
        _posts.doc(comment.postId).update({
          'commentCount': FieldValue.increment(1),
        }),
      );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Comment>> getCommentsOfPosts(String postId) {
    return _comments
        .where('postId', isEqualTo: postId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map((e) => Comment.fromMap(e.data()! as Map<String, dynamic>))
              .toList(),
        );
  }

  FutureVoid awardPost(Post post, String award, String senderId) async {
    try {
      await _users.doc(senderId).update({
        'awards': FieldValue.arrayRemove([award]),
      });
      await _posts.doc(post.id).update({
        'awards': FieldValue.arrayUnion([award]),
      });
      return right(
        await _users.doc(post.uid).update({
          'awards': FieldValue.arrayUnion([award]),
        }),
      );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
