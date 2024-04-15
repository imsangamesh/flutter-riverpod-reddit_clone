import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:reddit/core/apis/storage_api_provider.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/extensions/extensions.dart';
import 'package:reddit/core/services/typedefs.dart';
import 'package:reddit/core/utils/nav_utils.dart';
import 'package:reddit/core/utils/utils.dart';
import 'package:reddit/features/profile/user_profile_repository.dart';
import 'package:reddit/models/post_model.dart';
import 'package:reddit/models/user_model.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  return UserProfileController(
    userProfileRepository: ref.read(userProfileRepositoryProvider),
    storageApi: ref.read(fireStorageApiProvider),
    box: ref.getStorage,
  );
});

final getUserPostsProvider = StreamProvider.family((ref, String uid) {
  return ref.read(userProfileControllerProvider.notifier).getUserPosts(uid);
});

class UserProfileController extends StateNotifier<bool> {
  UserProfileController({
    required UserProfileRepository userProfileRepository,
    required FireStorageApi storageApi,
    required GetStorage box,
  })  : _userProfileRepository = userProfileRepository,
        _storageRepository = storageApi,
        _box = box,
        super(false);

  final UserProfileRepository _userProfileRepository;
  final FireStorageApi _storageRepository;
  final GetStorage _box;

  Future<void> editCommunity({
    required File? profileFile,
    required File? bannerFile,
    required String name,
    required BuildContext context,
  }) async {
    state = true;
    final userMap = _box.read<DataMap>(BoxKeys.user)!;
    var newUser = UserModel.fromMap(userMap);

    if (profileFile != null) {
      final res = await _storageRepository.storeFile(
        path: 'users/profile',
        id: newUser.uid,
        file: profileFile,
      );

      res.fold(
        (l) => Utils.showSnackbar(context, l.message),
        (r) => newUser = newUser.copyWith(profilePic: r),
      );
    }

    if (bannerFile != null) {
      final res = await _storageRepository.storeFile(
        path: 'users/banner',
        id: newUser.uid,
        file: bannerFile,
      );

      res.fold(
        (l) => Utils.showSnackbar(context, l.message),
        (r) => newUser = newUser.copyWith(banner: r),
      );
    }

    newUser = newUser.copyWith(name: name);

    final res = await _userProfileRepository.editProfile(newUser);
    state = false;

    res.fold(
      (l) => Utils.showSnackbar(context, l.message),
      (r) {
        _box.write(BoxKeys.user, newUser.toMap());
        NavUtils.back(context);
        Utils.showSnackbar(context, 'Profile edited successfully!');
      },
    );
  }

  Stream<List<Post>> getUserPosts(String uid) {
    return _userProfileRepository.getUserPosts(uid);
  }
}
