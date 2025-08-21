import 'dart:developer';

String formatDurationFromString(String duration) {
  int days = 0;
  int hours = 0;
  int minutes = 0;

  duration = duration.toLowerCase().trim();

  RegExp exp = RegExp(r'(\d+)\s*(days?|hours?|minutes?)');
  Iterable<RegExpMatch> matches = exp.allMatches(duration);

  for (var match in matches) {
    int value = int.parse(match.group(1)!);
    String unit = match.group(2)!;

    if (unit.startsWith('day')) {
      days = value;
    } else if (unit.startsWith('hour')) {
      hours = value;
    } else if (unit.startsWith('minute')) {
      minutes = value;
    }
  }

  int totalHours = days * 24 + hours;

  return '${totalHours}h ${minutes}m';
}

String getMaskedNumber(String number) {
  log(number);
  if (number.length <= 3) return number;
  final lastThree = number.substring(number.length - 3);
  final masked = 'X' * (number.length - 3);
  return '$masked$lastThree';
}
