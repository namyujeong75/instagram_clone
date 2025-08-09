import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String postsBoxName = 'posts';
  static const String settingsBoxName = 'settings';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Future.wait([
      Hive.openBox(postsBoxName),
      Hive.openBox(settingsBoxName),
    ]);
  }

  static Box getPostsBox() => Hive.box(postsBoxName);
  static Box getSettingsBox() => Hive.box(settingsBoxName);
}


