String formatDate(DateTime date) {
  return "${date.day}/${date.month}/${date.year}";
}

int calculateDaysDifference(DateTime eventDate) {
  final now = DateTime.now();
  return eventDate.difference(now).inDays;
}

String convertTo12HourFormat(String time24) {
  final timeParts = time24.split(":");
  final int hour24 = int.parse(timeParts[0]);
  final int minute = int.parse(timeParts[1]);

  String period = hour24 >= 12 ? "PM" : "AM";

  int hour12 = hour24 % 12;

  // If hour is 0 (midnight), convert it to 12 (12:00 AM)
  if (hour12 == 0) {
    hour12 = 12;
  }

  String formattedTime = "$hour12:${minute.toString().padLeft(2, '0')} $period";
  return formattedTime;
}