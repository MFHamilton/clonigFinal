import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  /// Crea un nuevo documento en 'posts'
  Future<void> createPost(PostModel post) {
    return _db
        .collection('posts')
        .doc(post.id)
        .set({
      'authorId':  post.authorId,
      'imageUrl':   post.imageUrl,
      'caption':    post.caption,
      'timestamp':  FieldValue.serverTimestamp(),
      'likes':      post.likes,
    });
  }

  Stream<List<PostModel>> postsStream() {
    return _db
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) {
      final data = doc.data();
      final ts = data['timestamp'] as Timestamp?;
      return PostModel(
        id:        doc.id,
        authorId:  data['authorId'] as String,
        imageUrl:  data['imageUrl'] as String,
        caption:   data['caption'] as String,
        timestamp: ts != null ? ts.toDate() : DateTime.now(),
        likes:     List<String>.from(data['likes'] ?? []),
      );
    }).toList());
  }

  Future<void> likePost(String postId, String uid) {
    return _db
        .collection('posts')
        .doc(postId)
        .update({'likes': FieldValue.arrayUnion([uid])});
  }

  Future<void> unlikePost(String postId, String uid) {
    return _db
        .collection('posts')
        .doc(postId)
        .update({'likes': FieldValue.arrayRemove([uid])});
  }

}
