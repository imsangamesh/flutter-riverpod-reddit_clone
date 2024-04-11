import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/failure.dart';
import 'package:reddit/core/providers/storage_repository_providers.dart';
import 'package:reddit/core/utils.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/features/community/repository/community_repository.dart';
import 'package:reddit/models/community_model.dart';
import 'package:reddit/models/post_model.dart';
import 'package:routemaster/routemaster.dart';

final userCommunityProvider = StreamProvider(
  (ref) => ref.watch(communityControllerProvider.notifier).getUserCommunities(),
);

final getCommunityByNameProvider = StreamProvider.family(
  (ref, String name) =>
      ref.watch(communityControllerProvider.notifier).getCommunityByName(name),
);

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  return CommunityController(
    communityRepository: ref.read(communityRepositoryProvider),
    ref: ref,
    storageRepository: ref.read(storageRepositoryProvider),
  );
});

final searchCommunityProvider = StreamProvider.family(
  (ref, String query) =>
      ref.watch(communityControllerProvider.notifier).searchCommunity(query),
);

final getCommunityPostsProvider = StreamProvider.family((ref, String name) {
  return ref.read(communityControllerProvider.notifier).getCommunityPosts(name);
});

class CommunityController extends StateNotifier<bool> {
  CommunityController({
    required CommunityRepository communityRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _communityRepository = communityRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  final CommunityRepository _communityRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  Future<void> createCommunity(String name, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';

    final community = Community(
      id: name,
      name: name,
      banner: Constants.bannerDefault,
      avatar: Constants.avatarDefault,
      members: [uid],
      mods: [uid],
    );

    final res = await _communityRepository.createCommunity(community);
    state = false;

    res.fold(
      (l) => showSnackbar(context, l.message),
      (r) {
        Routemaster.of(context).pop();
        showSnackbar(context, 'Community created successfully!');
      },
    );
  }

  Future<void> joinCommunity(Community community, BuildContext context) async {
    final user = _ref.read(userProvider)!;
    Either<Failure, void> res;

    if (community.members.contains(user.uid)) {
      res = await _communityRepository.leaveCommunity(community.name, user.uid);
    } else {
      res = await _communityRepository.joinCommunity(community.name, user.uid);
    }

    res.fold(
      (l) => showSnackbar(context, l.message),
      (r) {
        if (community.members.contains(user.uid)) {
          showSnackbar(context, 'Community left successfully!');
        } else {
          showSnackbar(context, 'Community joined successfully!');
        }
      },
    );
  }

  Stream<List<Community>> getUserCommunities() {
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getUserCommunities(uid);
  }

  Stream<Community> getCommunityByName(String name) {
    return _communityRepository.getCommunityByName(name);
  }

  Future<void> editCommunity({
    required File? profileFile,
    required File? bannerFile,
    required Community community,
    required BuildContext context,
  }) async {
    var newCommunity = community;
    state = true;

    if (profileFile != null) {
      final res = await _storageRepository.storeFile(
        path: 'communities/profile',
        id: community.name,
        file: profileFile,
      );

      res.fold(
        (l) => showSnackbar(context, l.message),
        (r) => newCommunity = newCommunity.copyWith(avatar: r),
      );
    }

    if (bannerFile != null) {
      final res = await _storageRepository.storeFile(
        path: 'communities/banner',
        id: community.name,
        file: bannerFile,
      );

      res.fold(
        (l) => showSnackbar(context, l.message),
        (r) => newCommunity = newCommunity.copyWith(banner: r),
      );
    }

    final res = await _communityRepository.editCommunity(newCommunity);

    state = false;
    res.fold(
      (l) => showSnackbar(context, l.message),
      (r) {
        Routemaster.of(context).pop();
        showSnackbar(context, 'Community edited successfully!');
      },
    );
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communityRepository.searchCommunity(query);
  }

  Future<void> addMods(
    String name,
    List<String> uids,
    BuildContext context,
  ) async {
    final res = await _communityRepository.addMods(name, uids);

    res.fold(
      (l) => showSnackbar(context, l.message),
      (r) {
        Routemaster.of(context).pop();
        showSnackbar(context, 'Moderators updated successfully!');
      },
    );
  }

  Stream<List<Post>> getCommunityPosts(String name) {
    return _communityRepository.getCommunityPosts(name);
  }
}
