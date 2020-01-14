import 'package:flutter/material.dart';

// copied from https://github.com/tomaszpolanski/flutter-animations/blob/master/lib/tests/src/restart_widget.dart
class RestartWidget<T> extends StatelessWidget {
  const RestartWidget({
    Key key,
    @required this.stream,
    @required this.builder,
  }) : super(key: key);

  final Stream<T> stream;
  final Widget Function(BuildContext, T) builder;

  Stream<T> _invalidate(T config) async* {
    yield null;
    await Future<dynamic>.delayed(const Duration(milliseconds: 16));
    yield config;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) {
        return StreamBuilder(
          stream: _invalidate(snapshot.data),
          builder: (context, snapshot) {
            return snapshot.data != null
                ? builder(context, snapshot.data)
                : const SizedBox();
          },
        );
      },
    );
  }
}
