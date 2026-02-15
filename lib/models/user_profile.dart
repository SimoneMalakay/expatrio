import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 0)
class UserProfile extends HiveObject {
  @HiveField(0)
  final String originCountry;

  @HiveField(1)
  final String destinationCountry;
  
  @HiveField(2)
  final String destinationCity;

  @HiveField(3)
  final String visaType;

  @HiveField(4)
  int xp;

  @HiveField(5)
  int streakDays;

  @HiveField(6)
  List<String> badges;

  UserProfile({
    required this.originCountry,
    required this.destinationCountry,
    required this.destinationCity,
    required this.visaType,
    this.xp = 0,
    this.streakDays = 0,
    this.badges = const [],
  });
}
