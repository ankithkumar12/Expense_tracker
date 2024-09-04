

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  DateTime stringToDateTime() {
    int year = int.parse(substring(0, 4));
    int month = int.parse(substring(5, 7));
    int day = int.parse(substring(8, 10));
    int hours = int.parse(substring(11, 13));
    int min = int.parse(substring(14, 16));
    return DateTime(
        year = year, month = month, day = day, hours = hours, min = min);
  }

  String cleanOrder() {
    String month = "";
    String date = "";
    int i = 0;
    for (i = 0; i < length; i++) {
      if (this[i] != "/") {
        month += this[i];
      } else {
        break;
      }
    }
    date = substring(i + 1, length);
    return "$date-$month";
  }
}
