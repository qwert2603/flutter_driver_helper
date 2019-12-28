import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';

import 'test_action.dart';

/// Utility class for making screenshots during integrations tests.
///
/// Screenshots are saved to dir "baseScreensDir/${current date-time}/".
/// Each screenshot's name is prefixed with it's index.
/// Directory is created automatically.
///
/// May be disabled with corresponding constructor param.
class Screenshoter {
  final FlutterDriver _driver;
  final String _screensDir;
  final bool enabled;
  int _nextScreenId = 1;

  Screenshoter(this._driver, String baseScreensDir, {this.enabled: true})
      : _screensDir = "$baseScreensDir/${DateTime.now()}" {
    if (!enabled) return;
    Directory(_screensDir).createSync(recursive: true);
  }

  Future<void> saveScreen(String name) async {
    if (!enabled) return;
    final bytes = await _driver.screenshot();
    File("$_screensDir/${_nextScreenId++}_$name.png").writeAsBytesSync(bytes);
  }

  TestAction screenshot(String name) => () => saveScreen(name);
}
