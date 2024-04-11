import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/error_test.dart';
import 'package:reddit/core/common/loader.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/utils.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/features/user_profile/controller/user_profile_controller.dart';
import 'package:reddit/theme/pallete.dart';

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
  late TextEditingController controller;

  Future<void> selectBannerImage() async {
    final res = await pickImage();
    if (res != null && res.count != 0) {
      setState(() => bannerFile = File(res.files[0].path!));
    }
  }

  Future<void> selectProfileImage() async {
    final res = await pickImage();
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
    controller = TextEditingController(text: ref.read(userProvider)!.name);
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
                TextButton(
                  onPressed: save,
                  child: const Text('Save'),
                ),
              ],
            ),
            body: isLoading
                ? const Loader()
                : Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: selectBannerImage,
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(10),
                                  dashPattern: const [10, 4],
                                  strokeCap: StrokeCap.round,
                                  color: Pallete.darkModeAppTheme.textTheme
                                      .bodyLarge!.color!,
                                  child: Container(
                                    width: double.infinity,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: bannerFile != null
                                        ? Image.file(bannerFile!)
                                        : (user.banner.isEmpty ||
                                                user.banner ==
                                                    Constants.bannerDefault)
                                            ? const Center(
                                                child: Icon(
                                                  Icons.camera,
                                                  size: 40,
                                                ),
                                              )
                                            : Image.network(user.banner),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                left: 20,
                                child: GestureDetector(
                                  onTap: selectProfileImage,
                                  child: CircleAvatar(
                                    radius: 32,
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
                        TextField(
                          controller: controller,
                          decoration: InputDecoration(
                            filled: true,
                            hintText: 'Name',
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(16),
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
