import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';

part 'history_item_data.g.dart';

@HiveType(typeId: 0)
class HistoryItemData {
  @HiveField(0)
  final String country;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final double lat;
  @HiveField(3)
  final double lon;
  HistoryItemData({this.country, this.name, this.lat, this.lon});
}
