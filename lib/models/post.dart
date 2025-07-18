class PostModel {
  final String id;
  final String authorId;
  final String imageUrl;
  final String caption;
  final DateTime timestamp;
  final List<String> likes;

  PostModel({
    required this.id,
    required this.authorId,
    required this.imageUrl,
    required this.caption,
    required this.timestamp,
    this.likes = const [],
  });

  Map<String, dynamic> toJson() => {
    'authorId': authorId,
    'imageUrl': imageUrl,
    'caption': caption,
    'timestamp': timestamp.toIso8601String(),
    'likes': likes,
  };

  factory PostModel.fromJson(Map<String, dynamic> json, String docId) {
    return PostModel(
      id: docId,
      authorId: json['authorId'] as String,
      imageUrl: json['imageUrl'] as String,
      caption: json['caption'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      likes: List<String>.from(json['likes'] ?? []),
    );
  }
}
