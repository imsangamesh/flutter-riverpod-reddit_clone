import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/post_card.dart';
import 'package:reddit/core/common/widgets/helper_widgets.dart';
import 'package:reddit/core/constants/app_text_styles.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/extensions/extensions.dart';
import 'package:reddit/core/utils/error_text.dart';
import 'package:reddit/core/utils/nav_utils.dart';
import 'package:reddit/features/auth/auth_controller.dart';
import 'package:reddit/features/profile/screens/edit_profile_screen.dart';
import 'package:reddit/features/profile/user_profile_controller.dart';
import 'package:reddit/models/user_model.dart';

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen(this.uid, {super.key});
  final String uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const topHeaderHeight = kBannerHeight + 50 + 20;

    Stack topHeader(UserModel user) {
      return Stack(
        children: [
          /// ----------------------------- `BANNER`
          const SizedBox(height: topHeaderHeight),
          Container(
            width: context.scrW,
            height: kBannerHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kBR),
              image: DecorationImage(
                image: NetworkImage(user.banner),
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// ----------------------------- `AVATAR`
          Positioned(
            bottom: 20,
            left: 15,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user.profilePic),
            ),
          ),

          /// ----------------------------- `NAME & BUTTON`
          Positioned(
            bottom: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: 35,
                  child: OutlinedButton(
                    onPressed: () => NavUtils.to(
                      context,
                      EditProfileScreen(user.uid),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(13, 5, 13, 5),
                      textStyle: AppTStyles.caption,
                    ),
                    child: const Text('Edit'),
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  'r/${user.name}',
                  style: AppTStyles.primary(ref.isDark),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return SafeArea(
      child: Scaffold(
        body: ref.watch(getUserDataProvider(uid)).when(
              data: (user) => Padding(
                padding: const EdgeInsets.all(10),
                child: NestedScrollView(
                  headerSliverBuilder: (_, __) {
                    return [
                      SliverAppBar(
                        expandedHeight: topHeaderHeight,
                        flexibleSpace: topHeader(user),
                      ),
                    ];
                  },
                  body: ref.watch(getUserPostsProvider(uid)).when(
                        data: (posts) {
                          return ListView.builder(
                            padding: const EdgeInsets.only(top: 10),
                            itemCount: posts.length,
                            itemBuilder: (context, i) {
                              final post = posts[i];
                              return PostCard(post);
                            },
                          );
                        },
                        error: (error, _) => ErrorText(error.toString()),
                        loading: Loader.new,
                      ),
                ),
              ),
              error: (error, _) => ErrorText(error.toString()),
              loading: Loader.new,
            ),
      ),
    );
  }
}
