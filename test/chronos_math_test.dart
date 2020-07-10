import 'package:flutter_test/flutter_test.dart';

import 'package:chronos/chronos.dart';

void main() {
  Chronos createDateTime() => Chronos(2018, 2, 3, 4, 5, 6, 7, 8);
  group('Add', () {
    test("Chronos#add(years: 1) adds a year", () {
      final newChronos = createDateTime().add(years: 1);
      expect(newChronos.year, 2019);
    });

    // TODO - quarter
    // test("Chronos#add(quarters: 1) adds a quarter", () {
    //   final newChronos = createDateTime().add(months: 1);
    //   expect(newChronos.quarter, 2);
    //   expect(newChronos.month, 5);
    // });

    test("Chronos#add(months: 1) at end of month", () {
      final chronos = Chronos(2018, 1, 31).add(months: 1);
      expect(chronos.month, 2);
      expect(chronos.day, 28);
    });

    test("Chronos#add(months: 1) at end of month on leap year", () {
      final chronos = Chronos(2020, 1, 31).add(months: 1);
      expect(chronos.month, 2);
      expect(chronos.day, 29);
    });

    test("Chronos#add(months: 13) at end of month on leap year", () {
      final chronos = Chronos(2015, 1, 31).add(months: 13);
      expect(chronos.year, 2016);
      expect(chronos.month, 2);
      expect(chronos.day, 29);
    });

    // TODO - timezones
    // test("DateTime#plus({ days: 1 }) keeps the same time across a DST", () => {
    //   const i = DateTime.fromISO("2016-03-12T10:00", {
    //       zone: "America/Los_Angeles"
    //     }),
    //     later = i.plus({ days: 1 });
    //   expect(later.day).toBe(13);
    //   expect(later.hour).toBe(10);
    // });

    // test("DateTime#plus({ hours: 24 }) gains an hour to spring forward", () => {
    //   const i = DateTime.fromISO("2016-03-12T10:00", {
    //       zone: "America/Los_Angeles"
    //     }),
    //     later = i.plus({ hours: 24 });
    //   expect(later.day).toBe(13);
    //   expect(later.hour).toBe(11);
    // });

    // #669
    // test("DateTime#plus({ days:0, hours: 24 }) gains an hour to spring forward", () => {
    //   const i = DateTime.fromISO("2016-03-12T10:00", {
    //       zone: "America/Los_Angeles"
    //     }),
    //     later = i.plus({ days: 0, hours: 24 });
    //   expect(later.day).toBe(13);
    //   expect(later.hour).toBe(11);
    // });

    test("Chronos#add(multiple) works across the 100 barrier", () {
      final chronos = Chronos(99, 12, 31).add(days: 2);
      expect(chronos.year, 100);
      expect(chronos.month, 1);
      expect(chronos.day, 2);
    });

    // TODO - fix 1970 boundary
    // test("Chronos#add renders invalid when out of max. datetime range using days", () {
    //   final chronos = Chronos.utc(1970, 1, 1).add(years: 1);
    //   expect(chronos.year, 1971);
    //   expect(chronos.month, 1);
    //   expect(chronos.day, 1);
    // });

    // TODO - fracional days
    // test("DateTime#plus handles fractional days", () => {
    //   const d = DateTime.fromISO("2016-01-31T10:00");
    //   expect(d.plus({ days: 0.8 })).toEqual(d.plus({ hours: (24 * 4) / 5 }));
    //   expect(d.plus({ days: 6.8 })).toEqual(d.plus({ days: 6, hours: (24 * 4) / 5 }));
    //   expect(d.plus({ days: 6.8, milliseconds: 17 })).toEqual(
    //     d.plus({ days: 6, milliseconds: 0.8 * 24 * 60 * 60 * 1000 + 17 })
    //   );
    // });

    test("Chronos#add supports negative digits", () {
      final chronos = Chronos(2020, 1, 2);
      expect(chronos.add(seconds: -1).second, 59);
      expect(chronos.add(minutes: -1).minute, 59);
      expect(chronos.add(hours: -1).hour, 23);
      expect(chronos.add(hours: -24).day, 1);
      expect(chronos.add(days: -1).day, 1);
      expect(chronos.add(months: -1).month, 12);
      expect(chronos.add(years: -2).year, 2018);
    });

    test("Chronos#add supports negative and positive digits", () {
      final chronos = Chronos(2020, 1, 2).add(months: 1, days: -1);
      expect(chronos.month, 2);
      expect(chronos.day, 1);
    });

  });
}
