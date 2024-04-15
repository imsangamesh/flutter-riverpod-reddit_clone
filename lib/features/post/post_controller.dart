import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/apis/storage_api_provider.dart';
import 'package:reddit/core/extensions/extensions.dart';
import 'package:reddit/core/utils/nav_utils.dart';
import 'package:reddit/core/utils/utils.dart';
import 'package:reddit/features/post/post_repo.dart';
import 'package:reddit/models/comment_model.dart';
import 'package:reddit/models/community_model.dart';
import 'package:reddit/models/post_model.dart';
import 'package:uuid/uuid.dart';

final postControllerProvider = StateNotifierProvider<PostController, bool>(
  (ref) => PostController(
    postRepo: ref.watch(postRepoProvider),
    storageApi: ref.watch(fireStorageApiProvider),
    uuid: ref.uuid,
    ref: ref,
  ),
);

final userFeedProvider =
    StreamProvider.family((ref, List<Community> communityNames) {
  return ref
      .watch(postControllerProvider.notifier)
      .fetchUserFeed(communityNames);
});

final guestFeedProvider = StreamProvider((ref) {
  return ref.watch(postControllerProvider.notifier).fetchGuestFeed();
});

final getPostByIdProvider = StreamProvider.family((ref, String id) {
  return ref.watch(postControllerProvider.notifier).getPostById(id);
});

final getCommentsOfPostProvider = StreamProvider.family((ref, String postId) {
  return ref.watch(postControllerProvider.notifier).getCommentsOfPost(postId);
});

/// ---------------------------------------------- `POST CONTROLLER`

class PostController extends StateNotifier<bool> {
  PostController({
    required PostRepo postRepo,
    required FireStorageApi storageApi,
    required Uuid uuid,
    required Ref ref,
  })  : _postRepo = postRepo,
        _storageApi = storageApi,
        _uuid = uuid,
        _ref = ref,
        super(false);

  final PostRepo _postRepo;
  final FireStorageApi _storageApi;
  final Uuid _uuid;
  final Ref _ref;

  /// ---------------------------------------------- `TEXT POST`

  Future<void> shareTextPost({
    required BuildContext context,
    required String title,
    required String description,
    required Community community,
  }) async {
    state = true;
    final postId = _uuid.v1();
    final userModel = _ref.userModel!;

    final post = Post(
      id: postId,
      title: title,
      description: description,
      communityName: community.name,
      communityProfilePic: community.avatar,
      upVotes: const [],
      downVotes: const [],
      commentCount: 0,
      username: userModel.name,
      uid: userModel.uid,
      type: 'text',
      createdAt: DateTime.now(),
      awards: const [],
    );

    final result = await _postRepo.createPost(post);
    state = false;

    result.fold(
      (l) => Utils.showSnackbar(context, l.message),
      (r) {
        NavUtils.back(context);
        Utils.showSnackbar(context, 'Posted successfully');
      },
    );
  }

  /// ---------------------------------------------- `LINK POST`

  Future<void> shareLinkPost({
    required BuildContext context,
    required String title,
    required String link,
    required Community community,
  }) async {
    state = true;
    final postId = _uuid.v1();
    final userModel = _ref.userModel!;

    final post = Post(
      id: postId,
      title: title,
      link: link,
      communityName: community.name,
      communityProfilePic: community.avatar,
      upVotes: const [],
      downVotes: const [],
      commentCount: 0,
      username: userModel.name,
      uid: userModel.uid,
      type: 'link',
      createdAt: DateTime.now(),
      awards: const [],
    );

    final result = await _postRepo.createPost(post);
    state = false;

    result.fold(
      (l) => Utils.showSnackbar(context, l.message),
      (r) {
        NavUtils.back(context);
        Utils.showSnackbar(context, 'Posted successfully');
      },
    );
  }

  /// ---------------------------------------------- `IMAGE POST`

  Future<void> shareImagePost({
    required BuildContext context,
    required String title,
    required File image,
    required Community community,
  }) async {
    state = true;
    final postId = _uuid.v1();
    final userModel = _ref.userModel!;
    final imageRes = await _storageApi.storeFile(
      path: 'posts/${community.name}',
      id: postId,
      file: image,
    );

    imageRes.fold(
      (l) => Utils.showSnackbar(context, l.message),
      (imageUrl) async {
        final post = Post(
          id: postId,
          title: title,
          link: imageUrl,
          communityName: community.name,
          communityProfilePic: community.avatar,
          upVotes: [],
          downVotes: [],
          commentCount: 0,
          username: userModel.name,
          uid: userModel.uid,
          type: 'image',
          createdAt: DateTime.now(),
          awards: [],
        );

        final res = await _postRepo.createPost(post);
        state = true;

        res.fold(
          (l) => Utils.showSnackbar(context, l.message),
          (r) {
            NavUtils.back(context);
            Utils.showSnackbar(context, 'Posted successfully');
          },
        );
      },
    );
  }

  Future<void> upVote(Post post) async {
    final uid = _ref.userModel!.uid;
    await _postRepo.upVote(post, uid);
  }

  Future<void> downVote(Post post) async {
    final uid = _ref.userModel!.uid;
    await _postRepo.downVote(post, uid);
  }

  Future<void> deletePost(String postId, BuildContext context) async {
    final res = await _postRepo.deletePost(postId);
    res.fold(
      (l) => Utils.showSnackbar(context, l.message),
      (r) => Utils.showSnackbar(context, 'Post Deleted successfully'),
    );
  }

  Stream<Post> getPostById(String postId) {
    return _postRepo.getPostById(postId);
  }

  /// ---------------------------------------------- `USER FEED`

  Stream<List<Post>> fetchUserFeed(List<Community> communityNames) {
    if (communityNames.isEmpty) return Stream.value([]);
    return _postRepo.fetchUserFeed(communityNames.map((e) => e.name).toList());
  }

  Stream<List<Post>> fetchGuestFeed() => _postRepo.fetchGuestFeed();

  /// ---------------------------------------------- `COMMENTS`

  Future<void> addComment({
    required BuildContext context,
    required String text,
    required String postId,
  }) async {
    final user = _ref.userModel!;
    final comment = Comment(
      id: _uuid.v1(),
      text: text,
      postId: postId,
      username: user.name,
      profilePic: user.profilePic,
      createdAt: DateTime.now(),
    );

    final result = await _postRepo.addComment(comment);
    result.fold(
      (l) => Utils.showSnackbar(context, l.message),
      (r) => Utils.showSnackbar(context, 'Comment added successfully'),
    );
  }

  Future<void> deleteComment({
    required BuildContext context,
    required String commentId,
    required String postId,
  }) async {
    final result = await _postRepo.deleteComment(commentId, postId);
    result.fold(
      (l) => Utils.showSnackbar(context, l.message),
      (r) => Utils.showSnackbar(context, 'Comment deleted successfully'),
    );
  }

  Stream<List<Comment>> getCommentsOfPost(String postId) {
    return _postRepo.getCommentsofPost(postId);
  }
}
