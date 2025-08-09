import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../models/post.dart';
import '../services/hive_service.dart';

class PostProvider extends ChangeNotifier {
  final Box _postsBox = HiveService.getPostsBox();
  final List<PostModel> _posts = <PostModel>[];

  List<PostModel> get posts => List.unmodifiable(_posts);

  Future<void> loadPosts() async {
    _posts.clear();
    for (final dynamic key in _postsBox.keys) {
      final dynamic raw = _postsBox.get(key);
      if (raw is Map) {
        try {
          _posts.add(PostModel.fromMap(raw));
        } catch (_) {
          // ignore malformed entries
        }
      }
    }
    _posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();
  }

  Future<void> addPost({
    required String username,
    required String caption,
    required List<int> imageBytes,
  }) async {
    final String id = const Uuid().v4();
    final PostModel post = PostModel(
      id: id,
      username: username,
      caption: caption,
      imageBytes: Uint8List.fromList(imageBytes),
      createdAt: DateTime.now(),
      likes: 0,
    );
    await _postsBox.put(id, post.toMap());
    _posts.insert(0, post);
    notifyListeners();
  }

  Future<void> deletePost(String postId) async {
    await _postsBox.delete(postId);
    _posts.removeWhere((p) => p.id == postId);
    notifyListeners();
  }

  Future<void> toggleLike(String postId) async {
    final int index = _posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;
    final PostModel current = _posts[index];
    final PostModel updated = current.copyWith(likes: current.likes + 1);
    _posts[index] = updated;
    await _postsBox.put(postId, updated.toMap());
    notifyListeners();
  }

  List<PostModel> postsByUser(String username) {
    return _posts.where((p) => p.username == username).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }
}


