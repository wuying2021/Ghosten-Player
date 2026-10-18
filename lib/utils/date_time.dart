import 'package:date_format/date_format.dart';

extension DateTimeExtension on DateTime {
  String format() {
    return formatDate(this, [yyyy, '-', mm, '-', dd]);
  }

  String formatFull() {
    return formatDate(this, [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]);
  }

  String formatLog() {
    return formatDate(this, [mm, '-', dd, ' ', HH, ':', nn, ':', ss, '.', SSS]);
  }

  String formatFullWithoutSec() {
    return formatDate(this, [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn]);
  }

  Duration fromNow() {
    return Duration(milliseconds: DateTime.now().millisecondsSinceEpoch - millisecondsSinceEpoch);
  }

  bool operator >=(DateTime other) {
    return microsecondsSinceEpoch >= other.microsecondsSinceEpoch;
  }

  bool operator >(DateTime other) {
    return microsecondsSinceEpoch > other.microsecondsSinceEpoch;
  }

  bool operator <=(DateTime other) {
    return microsecondsSinceEpoch <= other.microsecondsSinceEpoch;
  }

  bool operator <(DateTime other) {
    return microsecondsSinceEpoch < other.microsecondsSinceEpoch;
  }
}
