import 'dart:async';

import 'package:example/main.dart';
import 'package:example/test_hooks.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_driver_helper/src/restart_widget.dart';

void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;

  // ignore: close_sinks
  final StreamController<String> restartController = StreamController<String>()
    ..add("restart");

  enableFlutterDriverExtension(
    handler: (request) async {
      if (request == "restart") {
        restartController.add("restart");
        await Future.delayed(const Duration(milliseconds: 200));
      }
      if (request == "select_time") {
        selectTime = ({
          BuildContext context,
          TimeOfDay initialTime,
        }) async =>
            TimeOfDay(hour: 12, minute: 28);
      }
      return null;
    },
  );

  runApp(RestartWidget(
    stream: restartController.stream,
    builder: (context, data) => MyApp(),
  ));
}
