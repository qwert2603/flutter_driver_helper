# Flutter Driver Helper

Utility for easy work with flutter_driver in UI / integration tests

# Why?

Flutter Driver Helper has several useful utilities for writing UI / integration tests.

From Android's point of view, Flutter Driver is like [Espresso](https://developer.android.com/training/testing/espresso), while Flutter Driver Helper acts like [Kakao](https://github.com/agoda-com/Kakao).

Usual Flutter Driver test looks like

```dart
final list = find.byValueKey("list");
final item42 = find.byValueKey("item_42");
final secondScreen = find.byValueKey("second_screen");

await driver.tap(secondScreen);
await driver.waitForAbsent(item42);
await driver.scrollUntilVisible(list, item42);
await driver.waitFor(item42);
await driver.tap(find.pageBack());
```

This may be rewritten with Flutter Driver Helper to more readable style:

```dart
class MainScreen extends BaseScreen {
  MainScreen(FlutterDriver driver) : super(driver);

  DWidget get secondScreen => dWidget('second_screen');
}

class SecondScreen extends BaseScreen {
  SecondScreen(FlutterDriver driver) : super(driver);

  DWidget get list => dWidget("list");

  DScrollItem item(int index) => dScrollItem('item_$index', list);
}

...

final mainScreen = MainScreen(driver);
final secondScreen = SecondScreen(driver);

await runTestActions([
  mainScreen.secondScreen.tap(),
  secondScreen.item(42).waitForAbsent(),
  secondScreen.item(42).scrollUntilVisible(dyScroll: -300),
  secondScreen.item(42).waitFor(),
  secondScreen.pageBack.tap(),
]);
```
# Advantages

* With screens (Page Objects) we separate UI-elements from actions and can reuse these screens in several tests.
* Also we get rid of `await` on every line, that was easy to forget to write.

# Full example is in [example](https://github.com/qwert2603/flutter_driver_helper/tree/master/example) dir.
