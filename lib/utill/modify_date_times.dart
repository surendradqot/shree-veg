String getTimePeriod(String timeString) {
  List<String> parts = timeString.split(':');
  int hour = int.parse(parts[0]);

  String period;
  switch (hour) {
    case 4:
      period = 'Early Morning';
      break;
    case 5:
      period = 'Early Morning';
      break;
    case 6:
      period = 'Early Morning';
      break;
    case 7:
      period = 'Early Morning';
      break;
    case 8:
      period = 'Morning';
      break;
    case 9:
      period = 'Morning';
      break;
    case 10:
      period = 'Morning';
      break;
    case 11:
      period = 'Morning';
      break;
    case 12:
      period = 'Afternoon';
      break;
    case 13:
      period = 'Afternoon';
      break;
    case 14:
      period = 'Afternoon';
      break;
    case 15:
      period = 'Evening';
      break;
    case 16:
      period = 'Evening';
      break;
    case 17:
      period = 'Evening';
      break;
    case 18:
      period = 'Evening';
      break;
    default:
      period = 'Afternoon';
      break;
  }

  return period;
}

bool isSlotEnabled(String timeString) {
  DateTime currentTime = DateTime.now();
  int currentHour = currentTime.hour;
  int currentMinute = currentTime.minute;

  List<String> parts = timeString.split(':');
  int slotHour = int.parse(parts[0]);
  int slotMinute = int.parse(parts[1]);

  // Calculate the difference in minutes
  int differenceInMinutes =
      ((slotHour - currentHour) * 60) + (slotMinute - currentMinute);

  // Check if the difference is greater than 30 minutes
  bool enabled = differenceInMinutes > 30;

  return enabled;
}

String getFormattedTimes(String openTime, String closeTime,
    bool? getDisableTime, int disableMinutes) {
  List<String> openParts = openTime.split(':');
  List<String> closeParts = closeTime.split(':');

  int openHour = int.parse(openParts[0]);
  int openMinute = int.parse(openParts[1]);
  int closeHour = int.parse(closeParts[0]);
  int closeMinute = int.parse(closeParts[1]);

  if (getDisableTime == true) {
    // Subtract disableMinutes minutes from the opening time's minutes
    openMinute -= disableMinutes;
    // Adjust hours and minutes if openMinute becomes negative
    if (openMinute < 0) {
      openMinute += 60;
      openHour -= 1;
    }
  }

  String openAmPm = openHour >= 12 ? 'pm' : 'am';
  String closeAmPm = closeHour >= 12 ? 'pm' : 'am';

  if (openHour > 12) openHour -= 12;
  if (closeHour > 12) closeHour -= 12;

  if (getDisableTime == true) {
    String formattedTimes =
        '$openHour:${openMinute.toString().padLeft(2, '0')} $openAmPm';
    return formattedTimes;
  } else {
    String formattedTimes =
        '$openHour:${openMinute.toString().padLeft(2, '0')} $openAmPm - '
        '$closeHour:${closeMinute.toString().padLeft(2, '0')} $closeAmPm';
    return formattedTimes;
  }
}
