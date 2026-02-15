import 'package:hive/hive.dart';

part 'quest.g.dart';

@HiveType(typeId: 1)
class Quest extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final int xpReward;

  @HiveField(4)
  final int minLevelRequired;
  
  @HiveField(5)
  bool isCompleted;

  @HiveField(6)
  bool isLocked;

  @HiveField(7)
  final int daysDeadline;

  Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.xpReward,
    required this.minLevelRequired,
    this.isCompleted = false,
    this.isLocked = true,
    required this.daysDeadline,
  });
}
