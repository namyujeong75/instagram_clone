import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../providers/post_provider.dart';
import '../models/post.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(
      builder: (context, provider, _) {
        final List<PostModel> posts = provider.posts;
        if (posts.isEmpty) {
          return const Center(
            child: Text('첫 게시물을 만들어 보세요!'),
          );
        }
        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final PostModel post = posts[index];
            return Card(
              margin: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      child: Text(post.username.substring(0, 1).toUpperCase()),
                    ),
                    title: Text(post.username),
                    subtitle: Text(timeago.format(post.createdAt)),
                  ),
                  AspectRatio(
                    aspectRatio: 1,
                    child: Image.memory(post.imageBytes, fit: BoxFit.cover),
                  ),
                  if (post.caption.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(post.caption),
                    ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.favorite_border),
                        onPressed: () =>
                            context.read<PostProvider>().toggleLike(post.id),
                      ),
                      Text('${post.likes}'),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () =>
                            context.read<PostProvider>().deletePost(post.id),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}


