import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

String relativeTimeConvert(DateTime dateTime) {
  DateTime now = DateTime.now();
  DateTime oneMonthFromNow = now.subtract(Duration(days: 30));

  var text = '';

  if (dateTime.isBefore(now) && dateTime.isAfter(oneMonthFromNow)) {
    text = timeago.format(dateTime);
  } else {
    text = DateFormat('d MMM yyyy').format(dateTime);
  }
  return text[0].toUpperCase() + text.substring(1);
}
