import 'package:hive/hive.dart';

part 'reading_item.g.dart';

enum FeedingState { wellFed, fasting }

@HiveType(typeId: 0)
class ReadingItem extends HiveObject {
  @HiveField(0)
  int reading;
  @HiveField(1)
  String time;
  @HiveField(2)
  String date;
  @HiveField(3)
  String feedingState;

  ReadingItem(
      {required this.reading,
      required this.time,
      required this.date,
      required this.feedingState});
}
