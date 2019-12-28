import 'package:flutter/material.dart';

Future<TimeOfDay> Function({
  BuildContext context,
  TimeOfDay initialTime,
}) selectTime = ({
  BuildContext context,
  TimeOfDay initialTime,
}) =>
    showTimePicker(
      context: context,
      initialTime: initialTime,
    );
