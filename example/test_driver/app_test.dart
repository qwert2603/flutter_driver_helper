import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_driver_helper/flutter_driver_helper.dart';
import 'package:test/test.dart';

import 'screens.dart';

void main() {
  group('Counter App', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        await driver.close();
      }
    });

    setUp(() async {
      await driver.requestData("restart");
    });

    final timeout = Timeout(Duration(minutes: 5));
    final screenshotsEnabled = false;

    test(
      'test one',
      () async {
        final mainScreen = MainScreen(driver);
        final screenshoter = Screenshoter(
          driver,
          "screenshots",
          enabled: screenshotsEnabled,
        );

        await runTestActions([
          mainScreen.result.hasText("summa = 0"),
          mainScreen.field_1.setText("12"),
          mainScreen.result.hasText("summa = 12"),
          mainScreen.field_2.tap(),
          screenshoter.screenshot("field_2_variants"),
          mainScreen.field2Variant(4).tap(),
          mainScreen.result.hasText("summa = 16"),
          mainScreen.buttonSnackbar.tap(),
          mainScreen.snackbarText.waitFor(),
          mainScreen.actionMake7.tap(),
          mainScreen.snackbarText.waitForAbsent(),
          mainScreen.result.hasText("summa = 19"),
          mainScreen.someText.waitForAbsent(),
          mainScreen.chSwitch.tap(),
          mainScreen.someText.waitFor(),
          mainScreen.chSwitch.tap(),
          mainScreen.someText.waitForAbsent(),
          mainScreen.result.hasText("summa = 19"),
          screenshoter.screenshot("summa_19"),
        ]);
      },
      timeout: timeout,
    );

    test(
      'test two',
      () async {
        final mainScreen = MainScreen(driver);

        await runTestActions([
          mainScreen.result.hasText("summa = 0"),
          mainScreen.field_1.setText("3"),
          mainScreen.field_2.tap(),
          mainScreen.field2Variant(2).tap(),
          mainScreen.result.hasText("summa = 5"),
        ]);
      },
      timeout: timeout,
    );

    test(
      'test three',
      () async {
        final mainScreen = MainScreen(driver);

        await runTestActions([
          mainScreen.time.waitForAbsent(),
          TestAction(() => driver.requestData("select_time")),
          mainScreen.selectTime.tap(),
          mainScreen.time.waitFor(),
          mainScreen.time.hasText("TimeOfDay(12:28)"),
        ]);
      },
      timeout: timeout,
    );

    test(
      'test four',
      () async {
        final mainScreen = MainScreen(driver);
        final secondScreen = SecondScreen(driver);

        await runTestActions([
          mainScreen.secondScreen.tap(),
          secondScreen.item(42).waitForAbsent(),
          secondScreen.item(42).scrollUntilVisible(dyScroll: -300),
          secondScreen.item(42).waitFor(),
          secondScreen.pageBack.tap(),
        ]);
      },
      timeout: timeout,
    );
  });
}
