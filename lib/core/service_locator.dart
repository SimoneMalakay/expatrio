import 'package:hive_flutter/hive_flutter.dart';
import 'package:expatrio/models/user_profile.dart';
import 'package:expatrio/models/quest.dart';

class ServiceLocator {
  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register Adapters
    Hive.registerAdapter(UserProfileAdapter());
    Hive.registerAdapter(QuestAdapter());

    // Open Boxes
    await Hive.openBox<UserProfile>('userBox');
    await Hive.openBox<Quest>('questBox');
  }
}
