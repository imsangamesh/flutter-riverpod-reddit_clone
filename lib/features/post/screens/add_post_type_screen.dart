import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/error_test.dart';
import 'package:reddit/core/common/loader.dart';
import 'package:reddit/core/utils.dart';
import 'package:reddit/features/community/controller/community_controller.dart';
import 'package:reddit/features/post/controller/post_controller.dart';
import 'package:reddit/models/community_model.dart';
import 'package:reddit/theme/pallete.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  const AddPostTypeScreen(this.type, {super.key});
  final String type;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  final titleCntr = TextEditingController();
  final descriptionCntr = TextEditingController();
  final linkCntr = TextEditingController();
  File? bannerFile;
  List<Community> communities = [];
  Community? selectedCommunity;

  Future<void> selectBannerImage() async {
    final res = await pickImage();
    if (res != null && res.count != 0) {
      setState(() => bannerFile = File(res.files[0].path!));
    }
  }

  void sharePost() {
    if (widget.type == 'image' &&
        bannerFile != null &&
        titleCntr.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareImagePost(
            context: context,
            title: titleCntr.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
            file: bannerFile!,
          );
    } else if (widget.type == 'text' && titleCntr.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareTextPost(
            context: context,
            title: titleCntr.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
            description: descriptionCntr.text.trim(),
          );
    } else if (widget.type == 'link' &&
        linkCntr.text.isNotEmpty &&
        titleCntr.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareLinkPost(
            context: context,
            title: titleCntr.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
            link: linkCntr.text.trim(),
          );
    } else {
      showSnackbar(context, 'Please enter all the fields');
    }
  }

  @override
  void dispose() {
    titleCntr.dispose();
    descriptionCntr.dispose();
    linkCntr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isImage = widget.type == 'image';
    final isText = widget.type == 'text';
    final isLink = widget.type == 'link';
    final isLoading = ref.watch(postControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Post ${widget.type}'),
        actions: [
          TextButton(onPressed: sharePost, child: const Text('Share')),
        ],
      ),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    controller: titleCntr,
                    maxLength: 30,
                    decoration: const InputDecoration(
                      filled: true,
                      hintText: 'Enter Title',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // --------------------- IMAGE
                  if (isImage)
                    GestureDetector(
                      onTap: selectBannerImage,
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(10),
                        dashPattern: const [10, 4],
                        strokeCap: StrokeCap.round,
                        color: Pallete
                            .darkModeAppTheme.textTheme.bodyLarge!.color!,
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: bannerFile != null
                              ? Image.file(bannerFile!)
                              : const Center(
                                  child: Icon(
                                    Icons.camera,
                                    size: 40,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  // --------------------- TEXT
                  if (isText)
                    TextField(
                      controller: descriptionCntr,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Enter Description',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),

                  // --------------------- LINK
                  if (isLink)
                    TextField(
                      controller: linkCntr,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Enter Link',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                  const SizedBox(height: 20),

                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text('Select Community'),
                  ),

                  ref.watch(userCommunityProvider).when(
                        data: (data) {
                          communities = data;

                          if (data.isEmpty) return const SizedBox();
                          return DropdownButton<Community>(
                            value: selectedCommunity ?? data[0],
                            items: data
                                .map(
                                  (e) => DropdownMenuItem<Community>(
                                    value: e,
                                    child: Text(e.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCommunity = value;
                              });
                            },
                          );
                        },
                        error: (e, _) => ErrorText(e.toString()),
                        loading: Loader.new,
                      ),
                ],
              ),
            ),
    );
  }
}
