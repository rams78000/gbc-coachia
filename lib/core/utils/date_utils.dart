import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Utility class for date and time operations
class AppDateUtils {
  // Format date to display in UI
  static String formatDate(DateTime date, {String format = 'MMM dd, yyyy'}) {
    return DateFormat(format).format(date);
  }
  
  // Format time to display in UI
  static String formatTime(DateTime time, {String format = 'HH:mm'}) {
    return DateFormat(format).format(time);
  }
  
  // Format datetime to display in UI
  static String formatDateTime(DateTime dateTime, {String format = 'MMM dd, yyyy HH:mm'}) {
    return DateFormat(format).format(dateTime);
  }
  
  // Get the start of day for a given date
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
  
  // Get the end of day for a given date
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }
  
  // Get the start of week for a given date (Monday as first day)
  static DateTime startOfWeek(DateTime date) {
    final int difference = date.weekday - 1;
    return startOfDay(date.subtract(Duration(days: difference)));
  }
  
  // Get the end of week for a given date (Sunday as last day)
  static DateTime endOfWeek(DateTime date) {
    final int difference = 7 - date.weekday;
    return endOfDay(date.add(Duration(days: difference)));
  }
  
  // Get the start of month for a given date
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }
  
  // Get the end of month for a given date
  static DateTime endOfMonth(DateTime date) {
    return endOfDay(DateTime(date.year, date.month + 1, 0));
  }
  
  // Check if two dates are on the same day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && 
           date1.month == date2.month && 
           date1.day == date2.day;
  }
  
  // Get a list of DateTime objects for a week
  static List<DateTime> daysInWeek(DateTime date) {
    final DateTime startDay = startOfWeek(date);
    return List.generate(
      7, 
      (index) => startDay.add(Duration(days: index))
    );
  }
  
  // Get a relative time string (e.g., "2 hours ago")
  static String getRelativeTime(DateTime dateTime) {
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(dateTime);
    
    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
