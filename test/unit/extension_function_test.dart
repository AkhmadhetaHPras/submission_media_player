import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:media_player/utils/extension_function.dart';

void main() {
  group('DateTimeX.toFormatGeneralData', () {
    test('Return "12 July 2023" for DateTime object of 2023-07-12', () {
      /// setup
      initializeDateFormatting();
      final DateTime dateTime = DateFormat("yyyy-MM-dd").parse("2023-07-12");

      /// act
      final String formatedDate = dateTime.toFormatGeneralData();

      /// assert
      expect(formatedDate, "12 July 2023");
    });

    test('Return "09 August 1978" for DateTime object of 1978-08-09', () {
      initializeDateFormatting();
      final DateTime dateTime = DateFormat("yyyy-MM-dd").parse("1978-08-09");

      final String formatedDate = dateTime.toFormatGeneralData();

      expect(formatedDate, "09 August 1978");
    });
  });

  group('StringTimeX.toLocalTime', () {
    test('Returns "Today" for the current date', () {
      final today = DateFormat("yyyy-MM-dd").format(DateTime.now());

      final daysDiff = today.toLocalTime();

      expect(daysDiff, 'Today');
    });

    test('Returns "3 days ago" for a date 3 days ago', () {
      final sevenDaysAgo = DateFormat("yyyy-MM-dd")
          .format(DateTime.now().subtract(const Duration(days: 3)));

      final daysDiff = sevenDaysAgo.toLocalTime();

      expect(daysDiff, '3 days ago');
    });

    test('Returns "One week ago" for a date 7 days ago', () {
      final sevenDaysAgo = DateFormat("yyyy-MM-dd")
          .format(DateTime.now().subtract(const Duration(days: 7)));

      final daysDiff = sevenDaysAgo.toLocalTime();

      expect(daysDiff, 'One week ago');
    });

    test('Returns the date it self for dates older than 7 days', () {
      final DateTime date = DateTime.now().subtract(const Duration(days: 10));
      final String olderDate = DateFormat("yyyy-MM-dd").format(date);

      final daysDiff = olderDate.toLocalTime();

      expect(daysDiff, date.toFormatGeneralData());
    });
  });

  group('IntX.formatViewsCount', () {
    test('Formats numbers less than 1000', () {
      const int hundredNumber = 999;

      final String formatedCount = hundredNumber.formatViewsCount();

      expect(formatedCount, '999');
    });

    test('Formats numbers between 1000 and 999999', () {
      const int thousandNumber = 1500;

      final String formatedCount = thousandNumber.formatViewsCount();

      expect(formatedCount, '1.5 k');
    });

    test('Formats numbers greater than or equal to 1000000', () {
      const int millionNumber = 2000000;

      final String formatedCount = millionNumber.formatViewsCount();

      expect(formatedCount, '2 m');
    });
  });
}
