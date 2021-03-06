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
  final _scrollControler = ScrollController();
  String button_text = 'Start';

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
                return Text(
                  displayTime,
                  style: const TextStyle(
                      fontSize: 45, fontWeight: FontWeight.bold),
                ); //add style
              }),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 25, 0, 20),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
                    child: ElevatedButton(
                        onPressed: () {
                          _stopWatchTimer.onExecute.add(StopWatchExecute.start);
                        },
                        child: Text(button_text,
                            style: const TextStyle(fontSize: 25)),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                        ))),
                ElevatedButton(
                    onPressed: () {
                      _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                      setState(() {
                        button_text = 'Resume';
                      });
                    },
                    child: Text('Stop', style: const TextStyle(fontSize: 25)),
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 255, 78, 65),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                    ))
              ])),
          ElevatedButton(
              onPressed: () {
                _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                setState(() {
                  button_text = 'Start';
                });
              },
              child: Text('Reset', style: const TextStyle(fontSize: 25)),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 147, 150, 147),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              )),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: ElevatedButton(
                  onPressed: () {
                    _stopWatchTimer.onExecute.add(StopWatchExecute.lap);
                  },
                  child: Text('Lap', style: const TextStyle(fontSize: 25)),
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 147, 150, 147),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                  ))),
          SizedBox(
              height: 200,
              child: StreamBuilder<List<StopWatchRecord>>(
                stream: _stopWatchTimer.records,
                initialData: const [],
                builder: (context, snap) {
                  final value = snap.data ?? [];

                  Future.delayed(const Duration(milliseconds: 200), () {
                    _scrollControler.animateTo(
                        _scrollControler.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOut);
                  });
                  return ListView.builder(
                      controller: _scrollControler,
                      itemBuilder: (BuildContext context, int index) {
                        final data = value[index];
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                  '${index + 1}  -  ${data.displayTime}',
                                  style: const TextStyle(fontSize: 25)),
                            ),
                            const Divider(height: 2)
                          ],
                        );
                      },
                      itemCount: value.length);
                },
              ))
        ]));
  }
}
