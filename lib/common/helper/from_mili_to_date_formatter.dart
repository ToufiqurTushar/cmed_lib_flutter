class FromMiliToDateFormatter {
  // Method to format milliseconds to a date string in "DD-MMM-YYYY" format
  static String formatMilliseconds(int milliseconds) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    String day = dateTime.day.toString().padLeft(2, '0'); // Ensures two digits
    String month = _getMonthName(dateTime.month);
    String year = dateTime.year.toString();

    return "$day-$month-$year"; // e.g., "07-Oct-2024"
  }

  // Helper method to get month name
  static String _getMonthName(int month) {
    switch (month) {
      case 1: return "Jan";
      case 2: return "Feb";
      case 3: return "Mar";
      case 4: return "Apr";
      case 5: return "May";
      case 6: return "Jun";
      case 7: return "Jul";
      case 8: return "Aug";
      case 9: return "Sep";
      case 10: return "Oct";
      case 11: return "Nov";
      case 12: return "Dec";
      default: return "";
    }
  }
}
