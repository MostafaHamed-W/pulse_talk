import 'package:flutter/material.dart';

void showCustomSnackbar({
  required BuildContext context,
  String? message,
  String? spareError,
}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message ?? spareError ?? 'Unknown error, Please try again later'),
    ),
  );
}
