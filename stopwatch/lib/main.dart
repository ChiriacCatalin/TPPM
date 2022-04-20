import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  int value = 1;
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: Text("StopWatchPro"), centerTitle: true),
            body: GetBody()));
  }

  Widget GetBody() {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          StreamBuilder<int>(
              stream: _stopWatchTimer.rawTime,
              initialData: 0,
              builder: (context, snap) {
                final value = snap.data ?? this.value;
                final displayTime =
                    StopWatchTimer.getDisplayTime(value, hours: true);
                return Text(displayTime); //add style
              }),
          ElevatedButton(
              onPressed: () {
                _stopWatchTimer.onExecute.add(StopWatchExecute.start);
              },
              child: Text('Start'))
        ]));
  }

  void onButtonPressed() {
    setState(() {
      value = Random().nextInt(100);
    });
  }
}
