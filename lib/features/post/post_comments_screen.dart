import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/post_card.dart';
import 'package:reddit/core/common/widgets/custom_textfield.dart';
import 'package:reddit/core/common/widgets/helper_widgets.dart';
import 'package:reddit/core/utils/error_text.dart';
import 'package:reddit/features/post/post_controller.dart';
import 'package:reddit/models/post_model.dart';

class PostCommentsScreen extends ConsumerWidget {
  PostCommentsScreen(this.post, {super.key});

  final Post post;
  final commentCntr = TextEditingController();

  void addComment(BuildContext context, WidgetRef ref) {
    if (commentCntr.text.isEmpty) return;
    ref.read(postControllerProvider.notifier).addComment(
          context: context,
          text: commentCntr.text.trim(),
          postId: post.id,
        );
    commentCntr.clear();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: ref.watch(getCommentsOfPostProvider(post.id)).when(
            data: (comments) {
              return Column(
                children: [
                  PostCard(post, isOnCommentsScreen: true),
                  //
                  CustomTextField(
                    commentCntr,
                    "What's on your mind?",
                    radius: 0,
                    autoFocus: true,
                    onSubmit: () => addComment(context, ref),
                    bottomPadding: 0,
                  ),
                  const Divider(),
                  //
                  Expanded(
                    child: ListView.builder(
                      itemCount: comments.length,
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                      itemBuilder: (context, i) {
                        final comment = comments[i];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(comment.profilePic),
                            ),
                            title: Text(comment.text),
                            subtitle: Text(comment.username),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
            error: (e, _) => ErrorText(e.toString()),
            loading: Loader.new,
          ),
    );
  }
}
