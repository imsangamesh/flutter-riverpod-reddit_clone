import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/widgets/custom_textfield.dart';
import 'package:reddit/core/constants/colors.dart';
import 'package:reddit/core/extensions/extensions.dart';
import 'package:reddit/core/utils/utils.dart';
import 'package:reddit/features/community/community_controller.dart';

class AddCommunitySheet extends ConsumerStatefulWidget {
  const AddCommunitySheet({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddCommunitySheetState();
}

class _AddCommunitySheetState extends ConsumerState<AddCommunitySheet> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void createCommunity(BuildContext context) {
    final name = controller.text.trim();

    if (name.length < 3) {
      Utils.showSnackbar(context, 'Length must be at least 3 characters');
      return;
    }

    ref
        .read(communityControllerProvider.notifier)
        .createCommunity(name, context);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        child: Scaffold(
          backgroundColor: AppColors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                CustomTextField(
                  controller,
                  'Community Name',
                  maxLength: 25,
                ),
                SizedBox(
                  width: context.scrW,
                  child: OutlinedButton(
                    onPressed: () => createCommunity(context),
                    child: const Text('Create Community!'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
