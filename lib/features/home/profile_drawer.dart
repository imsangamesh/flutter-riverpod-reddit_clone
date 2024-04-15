import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/widgets/helper_widgets.dart';
import 'package:reddit/core/constants/app_text_styles.dart';
import 'package:reddit/core/constants/colors.dart';
import 'package:reddit/core/extensions/extensions.dart';
import 'package:reddit/core/utils/error_text.dart';
import 'package:reddit/core/utils/nav_utils.dart';
import 'package:reddit/features/community/community_controller.dart';
import 'package:reddit/features/community/screens/community_screen.dart';
import 'package:reddit/features/community/widgets/add_community_sheet.dart';
import 'package:reddit/features/profile/screens/user_profile_screen.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  Future<void> showCommunityAddBottomSheet(BuildContext context) async {
    NavUtils.back(context);
    await showModalBottomSheet<void>(
      isScrollControlled: true,
      showDragHandle: true,
      context: context,
      builder: (context) => const AddCommunitySheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.userModel!;

    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.edit, size: 22),
                onPressed: () {
                  NavUtils.back(context);
                  NavUtils.to(context, UserProfileScreen(user.uid));
                },
              ),
            ),

            /// --------------- `USER INFO`
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user.profilePic),
            ),
            const SizedBox(height: 15),
            Text(user.name, style: AppTStyles.body),
            const SizedBox(height: 15),

            /// --------------- `COMMUNITIES`
            ListTile(
              leading: const Icon(Icons.people_rounded),
              shape: const RoundedRectangleBorder(),
              title: Text(
                'Your Communities',
                style: AppTStyles.primary(ref.isDark),
              ),
              trailing: IconButton(
                onPressed: () => showCommunityAddBottomSheet(context),
                icon: const Icon(Icons.add),
              ),
            ),
            const Divider(height: 20),
            //
            ref.watch(getUserCommunitiesProvider).when(
                  data: (communities) => Expanded(
                    child: ListView.builder(
                      itemCount: communities.length,
                      itemBuilder: (context, i) {
                        final community = communities[i];

                        return ListTile(
                          onTap: () => NavUtils.to(
                            context,
                            CommunityScreen(community.name),
                          ),
                          shape: const RoundedRectangleBorder(),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(community.avatar),
                          ),
                          title: Text(community.name),
                          tileColor: AppColors.transparent,
                        );
                      },
                    ),
                  ),
                  error: (e, s) => ErrorText(e.toString()),
                  loading: Loader.new,
                ),

            /// -------------------------------- `THEME SWITCH`
            ListTile(
              leading: const Icon(Icons.auto_awesome),
              shape: const RoundedRectangleBorder(),
              title: Text(
                ref.isDark ? 'Nightly nights!' : 'Bright lights!',
                style: AppTStyles.primary(ref.isDark),
              ),
              trailing: Switch(
                value: ref.isDark,
                onChanged: (_) => ref.theme.toggleTheme(),
              ),
            ),

            /// -------------------------------- `LOGOUT`
            ListTile(
              onTap: () => ref.auth.logout(context),
              tileColor: AppColors.danger.withAlpha(50),
              leading: const Icon(Icons.logout, color: AppColors.danger),
              shape: const RoundedRectangleBorder(),
              title: const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.danger,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
