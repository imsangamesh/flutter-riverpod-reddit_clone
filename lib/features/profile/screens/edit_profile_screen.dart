import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/widgets/buttons.dart';
import 'package:reddit/core/common/widgets/custom_textfield.dart';
import 'package:reddit/core/common/widgets/helper_widgets.dart';
import 'package:reddit/core/common/widgets/image_picker_box.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/extensions/extensions.dart';
import 'package:reddit/core/utils/error_text.dart';
import 'package:reddit/core/utils/utils.dart';
import 'package:reddit/features/auth/auth_controller.dart';
import 'package:reddit/features/profile/user_profile_controller.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen(this.uid, {super.key});

  final String uid;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  File? bannerFile;
  File? profileFile;
  final controller = TextEditingController();

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

  void save() {
    ref.read(userProfileControllerProvider.notifier).editCommunity(
          profileFile: profileFile,
          bannerFile: bannerFile,
          name: controller.text.trim(),
          context: context,
        );
  }

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(Duration.zero).then((value) {
      controller.text = ref.userModel!.name;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);

    return ref.watch(getUserDataProvider(widget.uid)).when(
          data: (user) => Scaffold(
            appBar: AppBar(
              title: const Text('Edit Profile'),
              actions: [
                LoadingButton.text('Save', save, isLoading: isLoading),
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
                          imageUrl: user.banner,
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
                                  : NetworkImage(user.profilePic)
                                      as ImageProvider,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(controller, 'Name'),
                ],
              ),
            ),
          ),
          error: (error, _) => ErrorText(error.toString()),
          loading: () => const Loader(),
        );
  }
}
