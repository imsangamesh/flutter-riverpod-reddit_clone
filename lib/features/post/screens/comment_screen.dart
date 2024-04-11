import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/error_test.dart';
import 'package:reddit/core/common/loader.dart';
import 'package:reddit/core/common/post_card.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/features/post/controller/post_controller.dart';
import 'package:reddit/features/post/widgets/comment_card.dart';
import 'package:reddit/models/post_model.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  const CommentsScreen(this.postId, {super.key});

  final String postId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final commentCntr = TextEditingController();

  void addComment(Post post) {
    ref.read(postControllerProvider.notifier).addComment(
          context: context,
          text: commentCntr.text.trim(),
          post: post,
        );
    setState(commentCntr.clear);
  }

  @override
  void dispose() {
    commentCntr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isGuest = !ref.watch(userProvider)!.isAuthenticated;

    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(getPostByIdProvider(widget.postId)).when(
            data: (post) {
              return Column(
                children: [
                  PostCard(post),
                  if (!isGuest)
                    TextField(
                      onSubmitted: (_) => addComment(post),
                      controller: commentCntr,
                      decoration: const InputDecoration(
                        hintText: 'What are your thoughts?',
                        filled: true,
                        border: InputBorder.none,
                      ),
                    ),
                  ref.watch(getPostCommentsProvider(widget.postId)).when(
                        data: (data) {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                final comment = data[index];
                                return CommentCard(comment);
                              },
                            ),
                          );
                        },
                        error: (error, _) {
                          log(error.toString());
                          return ErrorText(error.toString());
                        },
                        loading: Loader.new,
                      ),
                ],
              );
            },
            error: (error, _) => ErrorText(error.toString()),
            loading: Loader.new,
          ),
    );
  }
}
