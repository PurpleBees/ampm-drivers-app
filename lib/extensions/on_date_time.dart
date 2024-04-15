import 'package:intl/intl.dart';

extension ToFormat on DateTime {
  String get dateToFormat => DateFormat('dd-MM-yyyy').format(this);

  String get toTimeStamp =>
      DateFormat("yyyy-MM-dd HH:mm:ss.SSSSSS").format(this);

  bool isEqualDate(DateTime other) =>
      other.year == year && other.month == month && other.day == day;
}
