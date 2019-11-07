
class DateUtil {
  static String formatToShort(DateTime dateTime) {
    int day = dateTime.day;
    String shortMonth = _monthToShortString(dateTime.month);
    int year = dateTime.year;

      return "$day $shortMonth ${year.toString().substring(2)}";
  }

  static String _monthToShortString(int month) {
    switch (month) {
      case 1:
        return "Jan";
      case 2:
        return "Feb";
      case 3:
        return "Mar";
      case 4:
        return "Apr";
      case 5:
        return "May";
      case 6:
        return "Jun";
      case 7:
        return "Jul";
      case 8:
        return "Aug";
      case 9:
        return "Sep";
      case 10:
        return "Oct";
      case 11:
        return "Nov";
      case 12:
        return "Dec";
      default:
        throw ArgumentError();
    }
  }
}
