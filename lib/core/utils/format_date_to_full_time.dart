import 'package:intl/intl.dart';

String formatDateToFullTime(DateTime dateTime) {
  String formattedDate = DateFormat('E, MMM d, yyyy').format(dateTime);

  String formattedTime = DateFormat('h:mm a').format(dateTime);

  return '$formattedDate・$formattedTime';
}
