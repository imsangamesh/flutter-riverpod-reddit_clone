import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/widgets/buttons.dart';
import 'package:reddit/core/common/widgets/helper_widgets.dart';
import 'package:reddit/core/common/widgets/image_picker_box.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/utils/error_text.dart';
import 'package:reddit/core/utils/utils.dart';
import 'package:reddit/features/community/community_controller.dart';
import 'package:reddit/models/community_model.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  const EditCommunityScreen(this.name, {super.key});
  final String name;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? bannerFile;
  File? profileFile;

  Future<void> selectBannerImage() async {
    final res = await Utils.pickImage();
    if (res != null && res.count != 0) {
      setState(() => bannerFile = File(res.files[0].path!));
    }
  }

  Future<void> selectProfileImage() async {
    final res = await Utils.pickImage();
    if (res != null && res.count != 0) {
      setState(() => profileFile = File(res.files[0].path!));
    }
  }

  void save(Community community) {
    ref.read(communityControllerProvider.notifier).editCommunity(
          profileFile: profileFile,
          bannerFile: bannerFile,
          community: community,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);

    return ref.watch(getCommunityByNameProvider(widget.name)).when(
          data: (community) => Scaffold(
            appBar: AppBar(
              title: const Text('Edit Community'),
              actions: [
                LoadingButton.text(
                  'Save',
                  (bannerFile == null && profileFile == null)
                      ? null
                      : () => save(community),
                  isLoading: isLoading,
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  SizedBox(
                    height: kBannerHeight + 40,
                    child: Stack(
                      children: [
                        ImagePickerBox(
                          image: bannerFile,
                          setSelectedImage: (File file) =>
                              setState(() => bannerFile = file),
                          imageUrl: community.banner,
                        ),
                        Positioned(
                          bottom: 0,
                          left: 20,
                          child: GestureDetector(
                            onTap: selectProfileImage,
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage: profileFile != null
                                  ? FileImage(profileFile!)
                                  : NetworkImage(community.avatar)
                                      as ImageProvider,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          error: (error, _) => ErrorText(error.toString()),
          loading: () => const Loader(),
        );
  }
}
