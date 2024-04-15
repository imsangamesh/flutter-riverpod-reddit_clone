import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/post_card.dart';
import 'package:reddit/core/common/widgets/helper_widgets.dart';
import 'package:reddit/core/constants/app_text_styles.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/extensions/extensions.dart';
import 'package:reddit/core/utils/error_text.dart';
import 'package:reddit/core/utils/nav_utils.dart';
import 'package:reddit/features/community/community_controller.dart';
import 'package:reddit/features/community/screens/mod_tools_screen.dart';
import 'package:reddit/models/community_model.dart';

class CommunityScreen extends ConsumerWidget {
  const CommunityScreen(this.communityName, {super.key});

  final String communityName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.userModel!.uid;
    final communityCntr = ref.watch(communityControllerProvider.notifier);
    const topHeaderHeight = kBannerHeight + 50;

    Stack topHeader(Community community) {
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
                image: NetworkImage(community.banner),
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// ----------------------------- `AVATAR`
          Positioned(
            bottom: 0,
            left: 15,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(community.avatar),
            ),
          ),

          /// ----------------------------- `NAME & BUTTON`
          Positioned(
            bottom: 0,
            right: 0,
            child: Row(
              children: [
                Text(
                  'r/${community.name}',
                  style: AppTStyles.primary(ref.isDark),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 35,
                  child: OutlinedButton(
                    onPressed: community.mods.contains(uid)
                        ? () =>
                            NavUtils.to(context, ModToolsScreen(community.name))
                        : () => communityCntr.toggleJoinCommunity(
                              community,
                              context,
                            ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(13, 5, 13, 5),
                      textStyle: AppTStyles.caption,
                    ),
                    child: community.mods.contains(uid)
                        ? const Text('Mod Tools')
                        : community.members.contains(uid)
                            ? const Text('Joined')
                            : const Text('Join'),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return SafeArea(
      child: Scaffold(
        body: ref.watch(getCommunityByNameProvider(communityName)).when(
              data: (community) => Padding(
                padding: const EdgeInsets.all(10),
                child: NestedScrollView(
                  headerSliverBuilder: (_, __) {
                    return [
                      SliverAppBar(
                        expandedHeight: topHeaderHeight,
                        flexibleSpace: topHeader(community),
                      ),
                    ];
                  },
                  body:
                      ref.watch(getCommunityPostsProvider(community.name)).when(
                            data: (posts) {
                              return ListView.builder(
                                padding: const EdgeInsets.only(top: 15),
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
