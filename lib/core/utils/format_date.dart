import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  DateTime now = DateTime.now();
  DateTime yesterday = now.subtract(Duration(days: 1));

  if (date.year == now.year) {
    // Same year
    if (date.month == now.month && date.day == now.day) {
      return "Today";
    } else if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return "Yesterday";
    } else {
      return DateFormat('MMM dd').format(date);
    }
  } else {
    return DateFormat('MMM dd, yyyy').format(date);
  }
}

String formatTime(DateTime date) {
  return DateFormat('hh:mm').format(date);
}
