import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'test_hooks.dart';

void main() {
  // needed to run on Linux
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: ValueKey("app"),
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        "second_screen": (_) => SecondScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int i1 = 0;
  int i2 = 0;
  TimeOfDay timeOfDay;
  bool ch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextField(
                key: ValueKey("field_1"),
                keyboardType: TextInputType.number,
                onChanged: (s) => setState(() => i1 = int.parse(s)),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "first number",
                ),
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<int>(
                key: ValueKey("field_2"),
                items: List.generate(20, (i) {
                  return DropdownMenuItem<int>(
                    key: ValueKey("variant_item_$i"),
                    child: Text(
                      "it is $i",
                      key: ValueKey("variant_$i"),
                    ),
                    value: i,
                  );
                }),
                value: i2,
                onChanged: (i) => setState(() => i2 = i),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "second number",
                ),
                isDense: true,
              ),
              SizedBox(height: 12),
              Text(
                'summa = ${i1 + i2}',
                key: ValueKey("result"),
                style: TextStyle(fontSize: 20.0),
              ),
              SizedBox(height: 12),
              SnackbarButton(() => setState(() => i2 = 7)),
              SizedBox(height: 12),
              FlatButton(
                key: ValueKey("second_screen"),
                onPressed: () => Navigator.pushNamed(context, "second_screen"),
                child: Text("Second screen"),
              ),
              SizedBox(height: 12),
              FlatButton(
                key: ValueKey("select_time"),
                onPressed: () async {
                  final time = await selectTime(
                    context: context,
                    initialTime: TimeOfDay(hour: 19, minute: 18),
                  );
                  if (time != null) {
                    setState(() => timeOfDay = time);
                  }
                },
                child: Text("Select time"),
              ),
              if (timeOfDay != null) ...[
                SizedBox(height: 12),
                Text(
                  timeOfDay.toString(),
                  key: ValueKey("time"),
                  style: TextStyle(fontSize: 20.0),
                ),
              ],
              SwitchListTile(
                key: ValueKey("ch_switch"),
                value: ch,
                onChanged: (ch) => setState(() => this.ch = ch),
              ),
              if (ch) ...[
                SizedBox(height: 12),
                Text(
                  "some_text",
                  key: ValueKey("some_text"),
                  style: TextStyle(fontSize: 20.0),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class SnackbarButton extends StatelessWidget {
  final Function() onSnackbarAction;

  SnackbarButton(this.onSnackbarAction);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: Colors.red,
      key: ValueKey("button_snackbar"),
      child: Text("snackbar"),
      onPressed: () {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "snackbar_text",
              key: ValueKey("snackbar_text"),
            ),
            action: SnackBarAction(
              key: ValueKey("action_make_7"),
              label: "make 7",
              onPressed: onSnackbarAction,
            ),
          ),
        );
      },
    );
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second screen"),
      ),
      body: Scrollbar(
        child: ListView.builder(
          key: ValueKey("list"),
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(14.0),
            child: Text(
              "Item #$index",
              key: ValueKey("item_$index"),
            ),
          ),
          itemCount: 100,
        ),
      ),
    );
  }
}
