import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/widgets/helper_widgets.dart';
import 'package:reddit/core/constants/app_text_styles.dart';
import 'package:reddit/core/constants/colors.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/extensions/extensions.dart';
import 'package:reddit/core/utils/error_text.dart';
import 'package:reddit/core/utils/nav_utils.dart';
import 'package:reddit/features/community/community_controller.dart';
import 'package:reddit/features/community/screens/community_screen.dart';
import 'package:reddit/features/post/post_comments_screen.dart';
import 'package:reddit/features/post/post_controller.dart';
import 'package:reddit/features/profile/profile_view.dart';
import 'package:reddit/models/post_model.dart';

class PostCard extends ConsumerWidget {
  const PostCard(this.post, {this.isOnCommentsScreen = false, super.key});

  final Post post;
  final bool isOnCommentsScreen;

  int get totalVotes => post.upVotes.length - post.downVotes.length;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postCntr = ref.read(postControllerProvider.notifier);
    final user = ref.userModel!;

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 3),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.listTile(ref.isDark),
        borderRadius: BorderRadius.circular(isOnCommentsScreen ? 0 : kBR),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ---------------------------------- `AVATAR + BASIC INFO`
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(post.communityProfilePic),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Community Name
                    InkWell(
                      onTap: () => NavUtils.to(
                        context,
                        CommunityScreen(post.communityName),
                      ),
                      child: Text(
                        'r/${post.communityName}',
                        style: AppTStyles.body,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // User Name
                    InkWell(
                      onTap: () => NavUtils.to(
                        context,
                        ProfileScreen(uid: user.uid),
                      ),
                      child: Text(
                        'u/${post.username}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              // Delete Button
              ref.watch(getCommunityByNameProvider(post.communityName)).when(
                    data: (data) {
                      if (data.mods.contains(user.uid) ||
                          user.uid == post.uid) {
                        return IconButton(
                          onPressed: () =>
                              postCntr.deletePost(post.id, context),
                          icon: const Icon(
                            Icons.delete_outline,
                            color: AppColors.danger,
                            size: 25,
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                    error: (e, _) => ErrorText(e.toString()),
                    loading: Loader.new,
                  ),
            ],
          ),
          const FullDivider(height: 15),
          const SizedBox(height: 3),

          /// ---------------------------------- `TITLE`
          Text(post.title, style: AppTStyles.body),
          const SizedBox(height: 10),

          /// ---------------------------------- `TEXT - BODY`
          if (post.type == 'text')
            Text(
              post.description ?? '',
              style: AppTStyles.themeBody(ref.isDark),
            ),

          /// ---------------------------------- `IMAGE - BODY`
          if (post.type == 'image')
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                post.link!,
                width: context.scrW,
                fit: BoxFit.contain,
              ),
            ),

          /// ---------------------------------- `LINK - BODY`
          if (post.type == 'link')
            SizedBox(
              height: 150,
              width: context.scrW,
              child: AnyLinkPreview(
                borderRadius: 8,
                link: post.link!,
                displayDirection: UIDirection.uiDirectionHorizontal,
              ),
            ),
          const SizedBox(height: 12),
          const FullDivider(height: 0),

          /// ---------------------------------- `UPVOTE DOWNVOTE COMMENTS`
          Row(
            children: [
              IconButton(
                iconSize: 25,
                onPressed: () => postCntr.upVote(post),
                icon: Icon(
                  post.upVotes.contains(user.uid)
                      ? Icons.thumb_up_alt
                      : Icons.thumb_up_alt_outlined,
                ),
              ),
              //
              if (totalVotes != 0)
                Text(totalVotes.toString(), style: AppTStyles.body),
              //
              IconButton(
                iconSize: 25,
                onPressed: () => postCntr.downVote(post),
                icon: Icon(
                  post.downVotes.contains(user.uid)
                      ? Icons.thumb_down_alt
                      : Icons.thumb_down_alt_outlined,
                ),
              ),
              const Spacer(),
              //
              TextButton(
                onPressed: isOnCommentsScreen
                    ? null
                    : () => NavUtils.to(context, PostCommentsScreen(post)),
                child: Row(
                  children: [
                    const Icon(Icons.comment_rounded),
                    const SizedBox(width: 8),
                    Text('${post.commentCount}', style: AppTStyles.body),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/*

class PostCard extends ConsumerWidget {
  const PostCard(this.post, {super.key});
  final Post post;

  dynamic get totalVotes => (post.upVotes.length - post.downVotes.length) == 0
      ? 'Vote'
      : (post.upVotes.length - post.downVotes.length);

  dynamic get comment => post.commentCount == 0 ? 'Comment' : post.commentCount;

  Future<void> deletePost(WidgetRef ref, BuildContext context) async {
    await ref.read(postControllerProvider.notifier).deletePost(post, context);
  }

  Future<void> upVotePost(WidgetRef ref) async {
    await ref.read(postControllerProvider.notifier).upVote(post);
  }

  Future<void> downVotePost(WidgetRef ref) async {
    await ref.read(postControllerProvider.notifier).downVote(post);
  }

  Future<void> awardPost(
    WidgetRef ref,
    String award,
    BuildContext context,
  ) async {
    await ref
        .read(postControllerProvider.notifier)
        .awardPost(post: post, award: award, context: context);
  }

  void navigateToUserProfile(BuildContext context) {
    Routemaster.of(context).push('/u/${post.uid}');
  }

  void navigateToCommunity(BuildContext context) {
    Routemaster.of(context).push('/r/${post.communityName}');
  }

  void navigateToComments(BuildContext context) {
    Routemaster.of(context).push('/posts/${post.id}/comments');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isImage = post.type == 'image';
    final isText = post.type == 'text';
    final isLink = post.type == 'link';
    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider)!;
    final size = MediaQuery.of(context).size;
    final isGuest = !ref.watch(userProvider)!.isAuthenticated;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: currentTheme.drawerTheme.backgroundColor,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 4, 0, 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => navigateToCommunity(context),
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(post.communityProfilePic),
                                  radius: 16,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'r/${post.communityName}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () =>
                                          navigateToUserProfile(context),
                                      child: Text(
                                        'u/${post.username}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              if (post.uid == user.uid)
                                IconButton(
                                  onPressed: () => deletePost(ref, context),
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Pallete.redColor,
                                  ),
                                ),
                            ],
                          ),
                          if (post.awards.isNotEmpty) ...[
                            const SizedBox(height: 5),
                            SizedBox(
                              height: 25,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: post.awards.length,
                                itemBuilder: (context, i) {
                                  final award = user.awards[i];
                                  return Image.asset(
                                    Constants.awards[award]!,
                                    height: 25,
                                  );
                                },
                              ),
                            ),
                          ],
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Text(
                              post.title,
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (isImage)
                            SizedBox(
                              height: size.height * 0.35,
                              width: size.width,
                              child: Image.network(
                                post.link!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          if (isLink)
                            SizedBox(
                              height: 150,
                              width: size.width,
                              child: AnyLinkPreview(
                                link: post.link!,
                                displayDirection:
                                    UIDirection.uiDirectionHorizontal,
                              ),
                            ),
                          if (isText)
                            Container(
                              alignment: Alignment.bottomLeft,
                              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                              child: Text(
                                post.description!,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                          Row(
                            children: [
                              IconButton(
                                onPressed:
                                    isGuest ? null : () => upVotePost(ref),
                                icon: Icon(
                                  Constants.up,
                                  size: 30,
                                  color: post.upVotes.contains(user.uid)
                                      ? Pallete.redColor
                                      : null,
                                ),
                              ),
                              Text(
                                '$totalVotes',
                                style: const TextStyle(fontSize: 17),
                              ),
                              IconButton(
                                onPressed:
                                    isGuest ? null : () => downVotePost(ref),
                                icon: Icon(
                                  Constants.down,
                                  size: 30,
                                  color: post.downVotes.contains(user.uid)
                                      ? Pallete.blueColor
                                      : null,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () => navigateToComments(context),
                                icon: const Icon(Icons.comment),
                              ),
                              Text(
                                '$comment',
                                style: const TextStyle(fontSize: 17),
                              ),
                              const Spacer(),
                              ref
                                  .watch(
                                    getCommunityByNameProvider(
                                      post.communityName,
                                    ),
                                  )
                                  .when(
                                    data: (data) {
                                      if (data.mods.contains(user.uid)) {
                                        return IconButton(
                                          onPressed: () =>
                                              deletePost(ref, context),
                                          icon: const Icon(
                                            Icons.admin_panel_settings,
                                          ),
                                        );
                                      }
                                      return const SizedBox();
                                    },
                                    error: (e, _) => ErrorText(e.toString()),
                                    loading: Loader.new,
                                  ),
                              IconButton(
                                onPressed: isGuest
                                    ? null
                                    : () {
                                        showDialog<Dialog>(
                                          context: context,
                                          builder: (_) => Dialog(
                                            child: Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: GridView.builder(
                                                shrinkWrap: true,
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 4,
                                                  mainAxisSpacing: 15,
                                                  crossAxisSpacing: 15,
                                                ),
                                                itemCount: user.awards.length,
                                                itemBuilder: (context, i) {
                                                  final award = user.awards[i];
                                                  return GestureDetector(
                                                    onTap: () => awardPost(
                                                      ref,
                                                      award,
                                                      context,
                                                    ),
                                                    child: Image.asset(
                                                      Constants.awards[award]!,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                icon: const Icon(Icons.card_giftcard_outlined),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

*/
