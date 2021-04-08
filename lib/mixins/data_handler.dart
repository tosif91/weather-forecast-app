import 'package:timeago/timeago.dart';

mixin DataHandler {
  String converTimeStamptoDate(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    // var dateInMyTimezone = date.add(Duration(hours: 8));
    return '${date.month}/${date.day}/${date.year}';
  }

  String getIconURL(String imageCode) {
    return 'https://openweathermap.org/img/wn/${imageCode}@2x.png';
  }

  String fetchHours(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${date.hour} : 00';
  }
}
