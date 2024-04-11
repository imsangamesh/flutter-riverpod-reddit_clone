import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/error_test.dart';
import 'package:reddit/core/common/loader.dart';
import 'package:reddit/core/common/post_card.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/features/community/controller/community_controller.dart';
import 'package:reddit/features/post/controller/post_controller.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGuest = !ref.watch(userProvider)!.isAuthenticated;

    if (isGuest) {
      return ref.watch(userCommunityProvider).when(
            data: (communities) => ref.watch(guestPostsProvider).when(
                  data: (posts) {
                    return ListView.builder(
                      itemCount: posts.length,
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
          );
    }

    return ref.watch(userCommunityProvider).when(
          data: (communities) => ref.watch(userPostsProvider(communities)).when(
                data: (posts) {
                  return ListView.builder(
                    itemCount: posts.length,
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
        );
  }
}
