library chronos;

import 'dart:math';
import 'package:intl/intl.dart';

enum ChronoUnit {
  YEAR,
  MONTH,
  WEEK,
  DAY,
  HOUR,
  MINUTE,
  SECOND,
  MILLISECOND,
  MICROSECOND,
}

class Chronos {
  final DateTime _dateTime;

  static const _daysInMonthArray = [
    0,
    31,
    28,
    31,
    30,
    31,
    30,
    31,
    31,
    30,
    31,
    30,
    31
  ];

  // Constructors
  Chronos(int year,
      [int month = 1,
      int day = 1,
      int hour = 0,
      int minute = 0,
      int second = 0,
      int millisecond = 0,
      int microsecond = 0])
      : _dateTime = DateTime(
          year,
          month,
          day,
          hour,
          minute,
          second,
          millisecond,
          microsecond,
        );

  Chronos.utc(int year,
      [int month = 1,
      int day = 1,
      int hour = 0,
      int minute = 0,
      int second = 0,
      int millisecond = 0,
      int microsecond = 0])
      : _dateTime = DateTime(
          year,
          month,
          day,
          hour,
          minute,
          second,
          millisecond,
          microsecond,
        ).toUtc();

  Chronos.now() : _dateTime = DateTime.now();

  Chronos.fromMillisecondsSinceEpoch(int millisecondsSinceEpoch)
      : _dateTime = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);

  Chronos.fromMicrosecondsSinceEpoch(int microsecondsSinceEpoch)
      : _dateTime = DateTime.fromMicrosecondsSinceEpoch(microsecondsSinceEpoch);

  Chronos.fromDateTime(DateTime dateTime)
      : _dateTime = DateTime(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          dateTime.hour,
          dateTime.minute,
          dateTime.second,
          dateTime.millisecond,
          dateTime.microsecond,
        );

  // getters
  int get year => _dateTime.year;
  int get month => _dateTime.month;
  int get day => _dateTime.day;
  int get hour => _dateTime.hour;
  int get minute => _dateTime.minute;
  int get second => _dateTime.second;
  int get millisecond => _dateTime.millisecond;
  int get microsecond => _dateTime.microsecond;
  int get dayOfYear => int.parse(DateFormat("D").format(_dateTime));
  int get weekNumber => ((dayOfYear - _dateTime.weekday + 10) / 7).floor();
  DateTime get dateTime => DateTime(
        _dateTime.year,
        _dateTime.month,
        _dateTime.day,
        _dateTime.hour,
        _dateTime.minute,
        _dateTime.second,
        _dateTime.millisecond,
        _dateTime.microsecond,
      );
  
  

  // methods
  Chronos add({
    Duration duration = Duration.zero,
    int years = 0,
    int months = 0,
    int weeks = 0,
    int days = 0,
    int hours = 0,
    int minutes = 0,
    int seconds = 0,
    int milliseconds = 0,
    int microseconds = 0,
  }) {
    Chronos chrono = Chronos.fromDateTime(_dateTime.add(duration));
    chrono = Chronos.fromDateTime(chrono.dateTime.add(Duration(
      days: days + (weeks * 7),
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      milliseconds: milliseconds,
      microseconds: microseconds,
    )));
    chrono = _addMonths(chrono, months);
    chrono = _addMonths(chrono, years * 12);
    return chrono;
  }

  Chronos startOf(ChronoUnit unit) {
    switch (unit) {
      case ChronoUnit.MILLISECOND:
        return Chronos(
          _dateTime.year,
          _dateTime.month,
          _dateTime.day,
          _dateTime.hour,
          _dateTime.minute,
          _dateTime.second,
          _dateTime.millisecond,
        );
      case ChronoUnit.SECOND:
        return Chronos(_dateTime.year, _dateTime.month, _dateTime.day,
            _dateTime.hour, _dateTime.minute, _dateTime.second);
      case ChronoUnit.MINUTE:
        return Chronos(_dateTime.year, _dateTime.month, _dateTime.day,
            _dateTime.hour, _dateTime.minute);
      case ChronoUnit.HOUR:
        return Chronos(
            _dateTime.year, _dateTime.month, _dateTime.day, _dateTime.hour);
      case ChronoUnit.DAY:
        return Chronos(_dateTime.year, _dateTime.month, _dateTime.day);
      case ChronoUnit.WEEK:
        final newDate =
            _dateTime.subtract(Duration(days: _dateTime.weekday - 1));
        return Chronos(newDate.year, newDate.month, newDate.day);
      case ChronoUnit.MONTH:
        return Chronos(_dateTime.year, _dateTime.month);
      case ChronoUnit.YEAR:
        return Chronos(_dateTime.year);
      default:
        return Chronos.fromDateTime(_dateTime);
    }
  }

  // helpers
  Chronos _addMonths(Chronos from, int months) {
    final r = months % 12;
    final q = (months - r) ~/ 12;
    var newYear = from.dateTime.year + q;
    var newMonth = from.dateTime.month + r;
    if (newMonth > 12) {
      newYear++;
      newMonth -= 12;
    }
    final newDay = min(from.dateTime.day, _daysInMonth(newYear, newMonth));
    if (from.dateTime.isUtc) {
      return Chronos.utc(
        newYear,
        newMonth,
        newDay,
        from.dateTime.hour,
        from.dateTime.minute,
        from.dateTime.second,
        from.dateTime.millisecond,
        from.dateTime.microsecond,
      );
    } else {
      return Chronos(
        newYear,
        newMonth,
        newDay,
        from.dateTime.hour,
        from.dateTime.minute,
        from.dateTime.second,
        from.dateTime.millisecond,
        from.dateTime.microsecond,
      );
    }
  }

  int _daysInMonth(int year, int month) {
    var result = _daysInMonthArray[month];
    if (month == 2 && _isLeapYear(year)) result++;
    return result;
  }

  bool _isLeapYear(int year) =>
      (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));
}
