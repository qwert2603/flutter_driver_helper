import 'dart:async';

final StreamController<String> _streamController = StreamController<String>()
  ..add("restart");

final Stream<String> restartAppStream = _streamController.stream;

Future<void> makeRestart() async {
  _streamController.add(null);
  await Future.delayed(const Duration(milliseconds: 16));
  _streamController.add("restart");
}
