import 'package:flutter_driver/flutter_driver.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart';

import 'test_action.dart';

/// Base page-object for accessing UI-elements.
/// (https://martinfowler.com/bliki/PageObject.html).
///
/// [pageBack] is AppBar's back button in Scaffold.
///
/// See README.md for example.
@immutable
abstract class BaseScreen {
  final FlutterDriver _driver;

  BaseScreen(this._driver);

  @protected
  DWidget dWidget(dynamic key) => DWidget(_driver, key);

  @protected
  DWidget dScrollItem(dynamic key, DWidget scrollable) =>
      DScrollItem(_driver, key, scrollable);

  DWidget get pageBack => DWidget.pageBack(_driver);
}

/// [DWidget] represents single UI-element in Screen.
/// It has methods for interacting with given UI-element during testing.
/// These methods return [TestAction] for using in [runTestActions].
@immutable
class DWidget {
  final FlutterDriver _driver;
  final String _name;
  final SerializableFinder _finder;

  DWidget(this._driver, dynamic valueKey)
      : _name = valueKey.toString(),
        _finder = find.byValueKey(valueKey);

  DWidget.pageBack(this._driver)
      : _name = "pageBack",
        _finder = find.pageBack();

  TestAction tap({Duration timeout}) => TestAction(
        () => _driver.tap(_finder, timeout: timeout),
        name: "tap on $_name",
      );

  TestAction waitFor({Duration timeout}) => TestAction(
        () => _driver.waitFor(_finder, timeout: timeout),
        name: "waitFor $_name",
      );

  TestAction waitForAbsent({Duration timeout}) => TestAction(
        () => _driver.waitForAbsent(_finder, timeout: timeout),
        name: "waitForAbsent $_name",
      );

  TestAction hasText(String text, {Duration timeout}) => TestAction(
        () async =>
            expect(await _driver.getText(_finder, timeout: timeout), text),
        name: "check $_name hasText $text",
      );

  TestAction setText(String text, {Duration timeout}) => TestAction(
        () async {
          await _driver.tap(_finder, timeout: timeout);
          await _driver.enterText(text ?? "", timeout: timeout);
        },
        name: "setText $text on $_name",
      );

  TestAction appendText(String text, {Duration timeout}) => TestAction(
        () async {
          await _driver.tap(_finder, timeout: timeout);
          final prev = await _driver.getText(_finder, timeout: timeout);
          await _driver.enterText(prev + (text ?? ""), timeout: timeout);
        },
        name: "appendText $text on $_name",
      );

  TestAction scrollIntoView({double alignment = 0.0, Duration timeout}) =>
      TestAction(
        () => _driver.scrollIntoView(_finder,
            alignment: alignment, timeout: timeout),
        name: "scrollIntoView $_name",
      );

  Future<String> getText({Duration timeout}) =>
      _driver.getText(_finder, timeout: timeout);
}

/// [DScrollItem] represents item in scrollable widget.
/// It allows to scroll to given item in list.
///
/// See README.md for example.
class DScrollItem extends DWidget {
  final DWidget _scrollable;

  DScrollItem(
    FlutterDriver driver,
    dynamic valueKey,
    this._scrollable,
  ) : super(driver, valueKey);

  TestAction scrollUntilVisible({
    double alignment = 0.0,
    double dxScroll = 0.0,
    double dyScroll = 0.0,
    Duration timeout,
  }) =>
      TestAction(
        () => _driver.scrollUntilVisible(
          _scrollable._finder,
          _finder,
          alignment: alignment,
          dxScroll: dxScroll,
          dyScroll: dyScroll,
          timeout: timeout,
        ),
        name: "scrollUntilVisible ${_scrollable._name} $_name",
      );
}
