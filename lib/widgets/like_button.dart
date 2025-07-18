import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/post.dart';
import '../providers/user_provider.dart';
import '../services/firestore_service.dart';

class LikeButton extends StatefulWidget {
  final PostModel post;
  const LikeButton({super.key, required this.post});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool _loading = false;

  Future<void> _toggleLike() async {
    setState(() => _loading = true);
    final uid = context.read<UserProvider>().user!.uid;
    final service = FirestoreService();
    final hasLiked = widget.post.likes.contains(uid);

    if (hasLiked) {
      await service.unlikePost(widget.post.id, uid);
      widget.post.likes.remove(uid);
    } else {
      await service.likePost(widget.post.id, uid);
      widget.post.likes.add(uid);
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final uid = context.read<UserProvider>().user!.uid;
    final isLiked = widget.post.likes.contains(uid);

    return _loading
        ? const SizedBox(
      width: 24, height: 24,
      child: CircularProgressIndicator(strokeWidth: 2),
    )
        : IconButton(
      icon: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked ? Colors.red : null,
      ),
      onPressed: _toggleLike,
    );
  }
}
