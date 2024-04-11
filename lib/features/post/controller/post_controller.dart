import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/enums.dart';
import 'package:reddit/core/providers/storage_repository_providers.dart';
import 'package:reddit/core/utils.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/features/post/repository/post_repository.dart';
import 'package:reddit/features/user_profile/controller/user_profile_controller.dart';
import 'package:reddit/models/comment_model.dart';
import 'package:reddit/models/community_model.dart';
import 'package:reddit/models/post_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

final postControllerProvider =
    StateNotifierProvider<PostController, bool>((ref) {
  return PostController(
    postRepository: ref.read(postRepositoryProvider),
    ref: ref,
    storageRepository: ref.read(storageRepositoryProvider),
  );
});

final userPostsProvider = StreamProvider.family(
  (ref, List<Community> communities) {
    return ref
        .watch(postControllerProvider.notifier)
        .fetchUserPosts(communities);
  },
);

final guestPostsProvider = StreamProvider(
  (ref) {
    return ref.watch(postControllerProvider.notifier).fetchGuestPosts();
  },
);

final getPostByIdProvider = StreamProvider.family((ref, String id) {
  return ref.watch(postControllerProvider.notifier).getPostById(id);
});

final getPostCommentsProvider = StreamProvider.family((ref, String postId) {
  return ref
      .watch(postControllerProvider.notifier)
      .fetchCommentsOfPosts(postId);
});

class PostController extends StateNotifier<bool> {
  PostController({
    required PostRepository postRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _postRepository = postRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  final PostRepository _postRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  Future<void> shareTextPost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String description,
  }) async {
    state = true;
    final postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    final post = Post(
      id: postId,
      title: title,
      communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar,
      upVotes: [],
      downVotes: [],
      commentCount: 0,
      username: user.name,
      uid: user.uid,
      type: 'text',
      createdAt: DateTime.now(),
      awards: [],
      description: description,
    );

    final res = await _postRepository.addPost(post);
    await _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.textPost);
    state = false;

    res.fold(
      (l) => showSnackbar(context, l.message),
      (r) {
        showSnackbar(context, 'Posted successfully');
        Routemaster.of(context).pop();
      },
    );
  }

  Future<void> shareLinkPost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String link,
  }) async {
    state = true;
    final postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    final post = Post(
      id: postId,
      title: title,
      communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar,
      upVotes: [],
      downVotes: [],
      commentCount: 0,
      username: user.name,
      uid: user.uid,
      type: 'link',
      createdAt: DateTime.now(),
      awards: [],
      link: link,
    );

    final res = await _postRepository.addPost(post);
    await _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.linkPost);
    state = false;

    res.fold(
      (l) => showSnackbar(context, l.message),
      (r) {
        showSnackbar(context, 'Posted successfully');
        Routemaster.of(context).pop();
      },
    );
  }

  Future<void> shareImagePost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required File file,
  }) async {
    state = true;
    final postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    final imageRes = await _storageRepository.storeFile(
      path: 'posts/${selectedCommunity.name}',
      id: postId,
      file: file,
    );

    imageRes.fold(
      (l) => showSnackbar(context, l.message),
      (url) async {
        final post = Post(
          id: postId,
          title: title,
          communityName: selectedCommunity.name,
          communityProfilePic: selectedCommunity.avatar,
          upVotes: [],
          downVotes: [],
          commentCount: 0,
          username: user.name,
          uid: user.uid,
          type: 'image',
          createdAt: DateTime.now(),
          awards: [],
          link: url,
        );

        final res = await _postRepository.addPost(post);
        await _ref
            .read(userProfileControllerProvider.notifier)
            .updateUserKarma(UserKarma.imagePost);
        state = false;

        res.fold(
          (l) => showSnackbar(context, l.message),
          (r) {
            showSnackbar(context, 'Posted successfully');
            Routemaster.of(context).pop();
          },
        );
      },
    );
  }

  Stream<List<Post>> fetchUserPosts(List<Community> communities) {
    if (communities.isNotEmpty) {
      return _postRepository.fetchUserPosts(communities);
    }
    return Stream.value([]);
  }

  Stream<List<Post>> fetchGuestPosts() {
    return _postRepository.fetchGuestPosts();
  }

  Future<void> deletePost(Post post, BuildContext context) async {
    final res = await _postRepository.deletePost(post);
    await _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.deletePost);
    res.fold(
      (l) => null,
      (r) => showSnackbar(context, 'Post Deleted successfully'),
    );
  }

  Future<void> upVote(Post post) async {
    final uid = _ref.read(userProvider)!.uid;
    await _postRepository.upVote(post, uid);
  }

  Future<void> downVote(Post post) async {
    final uid = _ref.read(userProvider)!.uid;
    await _postRepository.downVote(post, uid);
  }

  Stream<Post> getPostById(String postId) {
    return _postRepository.getPostById(postId);
  }

  Future<void> addComment({
    required BuildContext context,
    required String text,
    required Post post,
  }) async {
    final user = _ref.read(userProvider)!;
    final comment = Comment(
      id: const Uuid().v1(),
      text: text,
      postId: post.id,
      username: user.name,
      profilePic: user.profilePic,
      createdAt: DateTime.now(),
    );

    final res = await _postRepository.addComment(comment);
    await _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.comment);

    res.fold(
      (l) => showSnackbar(context, l.message),
      (r) => showSnackbar(context, 'Comment added successfully'),
    );
  }

  Future<void> awardPost({
    required Post post,
    required String award,
    required BuildContext context,
  }) async {
    final user = _ref.read(userProvider)!;
    final res = await _postRepository.awardPost(post, award, user.uid);

    res.fold(
      (l) => showSnackbar(context, l.message),
      (r) {
        showSnackbar(context, 'Awarded successfully');
        _ref
            .read(userProfileControllerProvider.notifier)
            .updateUserKarma(UserKarma.awardPost);
        _ref.read(userProvider.notifier).update((state) {
          log(state.toString());
          state?.awards.remove(award);
          log(state.toString());
          return state;
        });
        Routemaster.of(context).pop();
      },
    );
  }

  Stream<List<Comment>> fetchCommentsOfPosts(String postId) {
    return _postRepository.getCommentsOfPosts(postId);
  }
}
