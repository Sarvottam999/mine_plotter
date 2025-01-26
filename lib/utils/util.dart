import 'package:intl/intl.dart';

String formatDateTime(String isoDate) {
  try {
    // Parse the ISO 8601 string
    DateTime dateTime = DateTime.parse(isoDate);

    // Format the date and time
    String formattedDate = DateFormat('h:mm a, dd MMM yyyy').format(dateTime);
    return formattedDate;
  } catch (e) {
    // Return an error message if parsing fails
    return 'Invalid date format';
  }
}

 