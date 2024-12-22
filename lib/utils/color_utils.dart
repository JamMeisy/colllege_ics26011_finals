import 'package:flutter/material.dart';

class ColorUtils {
  static Color getStatusBorderColor(String? status) {
    Color borderColor;

    switch (status) {
      case 'pending':
        borderColor = Color(0xffffcc55); // Yellow
        break;
      case 'approved':
        borderColor = Color(0xff50C878); // Green
        break;
      case 'declined':
        borderColor = Color(0xffFF0505); // Red
        break;
      default:
        borderColor = Colors.grey;
    }

    return borderColor;
  }
}
