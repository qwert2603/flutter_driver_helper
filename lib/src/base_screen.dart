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

  DWidget dWidget(dynamic key) => DWidget(_driver, key);

  DWidget dScrollItem(dynamic key, DWidget scrollable) =>
      DScrollItem(_driver, key, scrollable._finder);

  DWidget get pageBack => DWidget.pageBack(_driver);
}

/// [DWidget] represents single UI-element in Screen.
/// It has methods for interacting with given UI-element during testing.
/// These methods return [TestAction] for using in [runTestActions].
@immutable
class DWidget {
  final FlutterDriver _driver;
  final SerializableFinder _finder;

  DWidget(this._driver, dynamic valueKey) : _finder = find.byValueKey(valueKey);

  DWidget.pageBack(this._driver) : _finder = find.pageBack();

  TestAction tap({Duration timeout}) =>
      () => _driver.tap(_finder, timeout: timeout);

  TestAction waitFor({Duration timeout}) =>
      () => _driver.waitFor(_finder, timeout: timeout);

  TestAction waitForAbsent({Duration timeout}) =>
      () => _driver.waitForAbsent(_finder, timeout: timeout);

  TestAction hasText(String text, {Duration timeout}) => () async =>
      expect(await _driver.getText(_finder, timeout: timeout), text);

  TestAction setText(String text, {Duration timeout}) => () async {
        await _driver.tap(_finder, timeout: timeout);
        await _driver.enterText(text ?? "", timeout: timeout);
      };

  TestAction appendText(String text, {Duration timeout}) => () async {
        await _driver.tap(_finder, timeout: timeout);
        final prev = await _driver.getText(_finder, timeout: timeout);
        await _driver.enterText(prev + (text ?? ""), timeout: timeout);
      };

  TestAction scrollIntoView({double alignment = 0.0, Duration timeout}) => () =>
      _driver.scrollIntoView(_finder, alignment: alignment, timeout: timeout);

  Future<String> getText({Duration timeout}) =>
      _driver.getText(_finder, timeout: timeout);
}

///  [DScrollItem] represents item in scrollable widget.
///  It allows to scroll to given item in list.
///
/// See README.md for example.
class DScrollItem extends DWidget {
  final SerializableFinder _scrollable;

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
      () => _driver.scrollUntilVisible(
            _scrollable,
            _finder,
            alignment: alignment,
            dxScroll: dxScroll,
            dyScroll: dyScroll,
            timeout: timeout,
          );
}
