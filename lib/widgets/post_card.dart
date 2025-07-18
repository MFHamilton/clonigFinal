import 'package:flutter/material.dart';
import '../models/post.dart';
import 'like_button.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final String authorName; // opcional, si quieres mostrar el nombre
  const PostCard({
    super.key,
    required this.post,
    this.authorName = '',
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen
          Image.network(post.imageUrl, width: double.infinity, fit: BoxFit.cover),

          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                LikeButton(post: post),
                const SizedBox(width: 8),
                Text(post.likes.length.toString()),
              ],
            ),
          ),

          if (authorName.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                authorName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(post.caption),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              '${post.timestamp.toLocal()}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
