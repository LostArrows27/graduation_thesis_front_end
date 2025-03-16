import 'package:intl/intl.dart';

String formatBirthday(DateTime date) {
  return DateFormat('dd/MM/yyyy').format(date);
}

String formatJoinedDate(DateTime date) {
  return DateFormat('MMMM d, yyyy').format(date);
}
