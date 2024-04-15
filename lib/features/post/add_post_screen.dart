import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/widgets/buttons.dart';
import 'package:reddit/core/common/widgets/custom_textfield.dart';
import 'package:reddit/core/common/widgets/helper_widgets.dart';
import 'package:reddit/core/common/widgets/image_picker_box.dart';
import 'package:reddit/core/constants/app_text_styles.dart';
import 'package:reddit/core/constants/colors.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/extensions/extensions.dart';
import 'package:reddit/core/theme/app_theme.dart';
import 'package:reddit/core/utils/error_text.dart';
import 'package:reddit/core/utils/utils.dart';
import 'package:reddit/features/community/community_controller.dart';
import 'package:reddit/features/post/post_controller.dart';
import 'package:reddit/models/community_model.dart';

class AddPostScreen extends ConsumerStatefulWidget {
  const AddPostScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends ConsumerState<AddPostScreen> {
  List<bool> isSelected = [true, false, false];

  final titleCntr = TextEditingController();
  final otherCntr = TextEditingController();
  File? image;
  Community? community;

  @override
  void dispose() {
    titleCntr.dispose();
    otherCntr.dispose();
    super.dispose();
  }

  void submit() {
    if (titleCntr.text.trim().isEmpty ||
        (!isSelected[1] && otherCntr.text.trim().isEmpty) ||
        (isSelected[1] && image == null)) {
      Utils.showSnackbar(
        context,
        'Please fill all the fields before submitting!',
      );
      return;
    }

    if (isSelected[2] && !otherCntr.text.trim().startsWith('http')) {
      Utils.showSnackbar(context, 'Please provide a valid URL!');
      return;
    }

    if (isSelected[0]) {
      ref.read(postControllerProvider.notifier).shareTextPost(
            context: context,
            title: titleCntr.text.trim(),
            description: otherCntr.text.trim(),
            community: community!,
          );
    }

    if (isSelected[1]) {
      ref.read(postControllerProvider.notifier).shareImagePost(
            context: context,
            title: titleCntr.text.trim(),
            image: image!,
            community: community!,
          );
    }

    if (isSelected[2]) {
      ref.read(postControllerProvider.notifier).shareLinkPost(
            context: context,
            title: titleCntr.text.trim(),
            link: otherCntr.text.trim(),
            community: community!,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add new post!')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// ---------------------------------- `POST TYPE SELECTOR`
            ToggleButtons(
              isSelected: isSelected,
              onPressed: (i) {
                otherCntr.clear();
                isSelected = List.generate(3, (_) => false);
                setState(() => isSelected[i] = !isSelected[i]);
              },
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Icon(Icons.notes_rounded),
                      SizedBox(width: 5),
                      Text('Text'),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Icon(Icons.image_outlined),
                      SizedBox(width: 5),
                      Text('Image'),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Icon(Icons.link),
                      SizedBox(width: 5),
                      Text('Link'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            /// ---------------------------------- `COMMUNITY SELECTOR`
            ref.watch(getUserCommunitiesProvider).when(
                  data: (communities) {
                    if (communities.isEmpty) return const SizedBox();
                    community ??= communities.first;

                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.listTile(ref.isDark),
                        borderRadius: BorderRadius.circular(kBR),
                      ),
                      child: DropdownButton<Community>(
                        iconEnabledColor: AppTheme.primaryColor(ref.isDark),
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                        borderRadius: BorderRadius.circular(kBR),
                        underline: const SizedBox(),
                        iconSize: 28,
                        isExpanded: true,
                        value: community,
                        items: communities
                            .map(
                              (e) => DropdownMenuItem<Community>(
                                value: e,
                                child: Text(
                                  e.name,
                                  style: community == e
                                      ? AppTStyles.primary(ref.isDark)
                                      : AppTStyles.body,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (val) => setState(() => community = val),
                      ),
                    );
                  },
                  error: (e, s) => ErrorText(e.toString()),
                  loading: Loader.new,
                ),
            const SizedBox(height: 15),

            /// ---------------------------------- `TITLE`
            CustomTextField(
              titleCntr,
              'Title',
              prefixIcon: Icons.short_text_rounded,
            ),

            /// ---------------------------------- `TEXT`
            if (isSelected[0])
              CustomTextField(
                otherCntr,
                'Description',
                maxLines: null,
                prefixIcon: Icons.notes_rounded,
              ),

            /// ---------------------------------- `IMAGE`
            if (isSelected[1])
              ImagePickerBox(
                image: image,
                setSelectedImage: (File file) => setState(() => image = file),
              ),

            /// ---------------------------------- `LINK`
            if (isSelected[2])
              CustomTextField(
                otherCntr,
                'Link',
                maxLines: null,
                prefixIcon: Icons.add_link_rounded,
              ),

            SizedBox(
              width: context.scrW,
              child: LoadingButton.elevated(
                'Submit Post',
                submit,
                isLoading: ref.isPostLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
