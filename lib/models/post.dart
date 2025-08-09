import 'dart:typed_data';

class PostModel {
  final String id;
  final String username;
  final String caption;
  final Uint8List imageBytes;
  final DateTime createdAt;
  final int likes;

  const PostModel({
    required this.id,
    required this.username,
    required this.caption,
    required this.imageBytes,
    required this.createdAt,
    required this.likes,
  });

  PostModel copyWith({
    String? id,
    String? username,
    String? caption,
    Uint8List? imageBytes,
    DateTime? createdAt,
    int? likes,
  }) {
    return PostModel(
      id: id ?? this.id,
      username: username ?? this.username,
      caption: caption ?? this.caption,
      imageBytes: imageBytes ?? this.imageBytes,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
    );
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'id': id,
      'username': username,
      'caption': caption,
      'imageBytes': imageBytes,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'likes': likes,
    };
  }

  static PostModel fromMap(Map map) {
    return PostModel(
      id: map['id'] as String,
      username: map['username'] as String,
      caption: (map['caption'] ?? '') as String,
      imageBytes: map['imageBytes'] as Uint8List,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      likes: (map['likes'] ?? 0) as int,
    );
  }
}


