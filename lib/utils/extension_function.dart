import 'package:intl/intl.dart';

extension DateTimeX on DateTime {
  /// Convert a [DateTime] date to a string format that includes the date, month, and year in [dd MMMM yyyy] format.
  ///
  /// Example:
  /// ```dart
  /// DateFormat("yyyy-MM-dd").parse("2023-07-12").toFormatGeneralData();
  /// ```
  /// Output: 12 July 2023
  String toFormatGeneralData() {
    DateFormat dateFormat = DateFormat('dd MMMM yyyy');

    return dateFormat.format(this);
  }
}

extension IntX on int {
  /// Convert [int] numbers to a string format customized for large values, using
  /// Notation 'k' for thousands and 'm' for millions.
  ///
  /// Example:
  /// ```dart
  /// 1200..formatViewsCount();
  /// ```
  /// Output: 1.2 k
  String formatViewsCount() {
    if (this < 1000) {
      return toString();
    } else if (this < 1000000) {
      double kViews = this / 1000;
      return '${kViews.toStringAsFixed(kViews.truncateToDouble() == kViews ? 0 : 1)} k';
    } else {
      double mViews = this / 1000000;
      return '${mViews.toStringAsFixed(mViews.truncateToDouble() == mViews ? 0 : 1)} m';
    }
  }
}

extension StringTimeX on String {
  /// Extends the functionality of the [String] object that stores dates in ["yyyy-MM-dd"] format.
  /// This function converts the date to a string format that includes time information relative to the current local time, such as "Today", "One week ago", or "n days ago" (with n 1 through 6).
  ///
  /// Example:
  /// ```dart
  ///  DateFormat("yyyy-MM-dd").format(DateTime.now()).toLocalTime();
  /// ```
  /// Output: Today
  String toLocalTime() {
    DateTime tempDate = DateFormat("yyyy-MM-dd").parse(this);
    final now = DateTime.now();
    Duration diff = now.difference(tempDate);

    if (diff.inDays > 7) {
      return tempDate.toFormatGeneralData();
    } else if (diff.inDays == 7) {
      return 'One week ago';
    } else if (diff.inDays >= 1 && diff.inDays <= 6) {
      return '${diff.inDays} days ago';
    } else {
      return 'Today';
    }
  }
}
