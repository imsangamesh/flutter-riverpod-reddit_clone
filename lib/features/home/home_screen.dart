import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/post_card.dart';
import 'package:reddit/core/common/widgets/helper_widgets.dart';
import 'package:reddit/core/utils/error_text.dart';
import 'package:reddit/core/utils/nav_utils.dart';
import 'package:reddit/features/community/community_controller.dart';
import 'package:reddit/features/home/profile_drawer.dart';
import 'package:reddit/features/home/search_community_delegate.dart';
import 'package:reddit/features/post/add_post_screen.dart';
import 'package:reddit/features/post/post_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      drawer: const ProfileDrawer(),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => showSearch(
              context: context,
              delegate: SearchCommunityDelegate(ref),
            ),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: ref.watch(getUserCommunitiesProvider).when(
            data: (communities) =>
                ref.watch(userFeedProvider(communities)).when(
                      data: (posts) {
                        if (posts.isEmpty) {
                          return const EmptyList(
                            'No feed! Please join communities first!',
                          );
                        }

                        return ListView.builder(
                          itemCount: posts.length,
                          padding: const EdgeInsets.all(10),
                          itemBuilder: (context, i) {
                            final post = posts[i];
                            return PostCard(post);
                          },
                        );
                      },
                      error: (error, _) {
                        log(error.toString());
                        return ErrorText('Error: $error');
                      },
                      loading: Loader.new,
                    ),
            error: (error, _) => ErrorText(error.toString()),
            loading: Loader.new,
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => NavUtils.to(context, const AddPostScreen()),
        child: const Icon(Icons.post_add),
      ),
    );
  }
}
