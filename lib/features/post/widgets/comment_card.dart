import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/models/comment_model.dart';

class CommentCard extends ConsumerWidget {
  const CommentCard(this.comment, {super.key});
  final Comment comment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(comment.profilePic),
            radius: 18,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'u/${comment.username}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(comment.text),
            ],
          ),
        ],
      ),
    );
  }
}
