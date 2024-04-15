import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit/core/apis/storage_api_provider.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/errors/failure.dart';
import 'package:reddit/core/extensions/extensions.dart';
import 'package:reddit/core/utils/nav_utils.dart';
import 'package:reddit/core/utils/utils.dart';
import 'package:reddit/features/community/community_repo.dart';
import 'package:reddit/models/community_model.dart';
import 'package:reddit/models/post_model.dart';

final getUserCommunitiesProvider = StreamProvider(
  (ref) => ref.watch(communityControllerProvider.notifier).getUserCommunities(),
);

final getCommunityByNameProvider = StreamProvider.family(
  (ref, String name) =>
      ref.watch(communityControllerProvider.notifier).getCommunityByName(name),
);

final getCommunityPostsProvider = StreamProvider.family((ref, String name) {
  return ref.read(communityControllerProvider.notifier).getCommunityPosts(name);
});

final searchCommunityProvider = StreamProvider.family(
  (ref, String query) =>
      ref.watch(communityControllerProvider.notifier).searchCommunity(query),
);

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  return CommunityController(
    communityRepo: ref.read(communityRepoProvider),
    storageApi: ref.read(fireStorageApiProvider),
    ref: ref,
  );
});

/// --------------------------------------------- `COMMUNITY CONTROLLER`

class CommunityController extends StateNotifier<bool> {
  CommunityController({
    required CommunityRepo communityRepo,
    required Ref ref,
    required FireStorageApi storageApi,
  })  : _communityRepo = communityRepo,
        _storageApi = storageApi,
        _ref = ref,
        super(false);

  final CommunityRepo _communityRepo;
  final FireStorageApi _storageApi;
  final Ref _ref;

  /// --------------------------------------------- `METHODS`

  Future<void> createCommunity(String name, BuildContext context) async {
    state = true;
    final uid = _ref.userModel!.uid;
    final community = Community(
      id: name,
      name: name,
      banner: Defaults.banner,
      avatar: Defaults.avatar,
      members: [uid],
      mods: [uid],
    );

    final result = await _communityRepo.createCommunity(community);
    state = false;

    result.fold(
      (l) => Utils.showSnackbar(context, l.message),
      (r) {
        NavUtils.back(context);
        Utils.showSnackbar(context, 'Community created successfully!');
      },
    );
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
      final res = await _storageApi.storeFile(
        path: 'communities/profile',
        id: community.name,
        file: profileFile,
      );

      res.fold(
        (l) => Utils.showSnackbar(context, l.message),
        (r) => newCommunity = newCommunity.copyWith(avatar: r),
      );
    }

    if (bannerFile != null) {
      final res = await _storageApi.storeFile(
        path: 'communities/banner',
        id: community.name,
        file: bannerFile,
      );

      res.fold(
        (l) => Utils.showSnackbar(context, l.message),
        (r) => newCommunity = newCommunity.copyWith(banner: r),
      );
    }

    final res = await _communityRepo.editCommunity(newCommunity);

    state = false;
    res.fold(
      (l) => Utils.showSnackbar(context, l.message),
      (r) {
        NavUtils.back(context);
        Utils.showSnackbar(context, 'Community edited successfully!');
      },
    );
  }

  Future<void> toggleJoinCommunity(
    Community community,
    BuildContext context,
  ) async {
    final uid = _ref.userModel!.uid;
    Either<Failure, void> result;

    if (community.members.contains(uid)) {
      result = await _communityRepo.leaveCommunity(community.name, uid);
    } else {
      result = await _communityRepo.joinCommunity(community.name, uid);
    }

    result.fold(
      (l) => Utils.showSnackbar(context, l.message),
      (r) {
        if (community.members.contains(uid)) {
          Utils.showSnackbar(context, 'You joined ${community.name}!');
        } else {
          Utils.showSnackbar(context, 'You left ${community.name}!');
        }
      },
    );
  }

  Stream<Community> getCommunityByName(String name) {
    return _communityRepo.getCommunityByName(name);
  }

  Stream<List<Community>> getUserCommunities() {
    final uid = _ref.userModel!.uid;
    return _communityRepo.getUserCommunities(uid);
  }

  Stream<List<Post>> getCommunityPosts(String name) {
    return _communityRepo.getCommunityPosts(name);
  }

  Future<void> addMods(
    String name,
    List<String> uids,
    BuildContext context,
  ) async {
    final res = await _communityRepo.addMods(name, uids);

    res.fold(
      (l) => Utils.showSnackbar(context, l.message),
      (r) {
        NavUtils.back(context);
        Utils.showSnackbar(context, 'Moderators updated successfully!');
      },
    );
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communityRepo.searchCommunity(query);
  }
}
