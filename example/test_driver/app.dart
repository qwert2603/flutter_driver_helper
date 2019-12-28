import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';

import '../lib/restart_app.dart';
import '../lib/test_hooks.dart';
import '../lib/main.dart' as app;

void main() {
  enableFlutterDriverExtension(
    handler: (request) async {
      if (request == "restart") {
        await makeRestart();
        await Future.delayed(const Duration(milliseconds: 200));
      }
      if (request.startsWith("select_time")) {
        selectTime = ({
          BuildContext context,
          TimeOfDay initialTime,
        }) async =>
            TimeOfDay(hour: 12, minute: 28);
      }
      return null;
    },
  );
  app.main();
}
