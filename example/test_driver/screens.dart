import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_driver_helper/flutter_driver_helper.dart';

class MainScreen extends BaseScreen {
  MainScreen(FlutterDriver driver) : super(driver);

  DWidget get app => dWidget('app');

  DWidget get field_1 => dWidget('field_1');

  DWidget get field_2 => dWidget('field_2');

  DWidget field2Variant(int i) => dWidget('variant_$i');

  DWidget get result => dWidget('result');

  DWidget get buttonSnackbar => dWidget('button_snackbar');

  DWidget get secondScreen => dWidget('second_screen');

  DWidget get snackbarText => dWidget('snackbar_text');

  DWidget get actionMake7 => dWidget('action_make_7');

  DWidget get selectTime => dWidget('select_time');

  DWidget get time => dWidget('time');

  DWidget get chSwitch => dWidget('ch_switch');

  DWidget get someText => dWidget('some_text');
}

class SecondScreen extends BaseScreen {
  SecondScreen(FlutterDriver driver) : super(driver);

  DWidget get list => dWidget("list");

  DScrollItem item(int index) => dScrollItem('item_$index', list);
}
