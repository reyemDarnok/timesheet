import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timesheet',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Timesheet'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<DateTime> toggleBreak = new List<DateTime>();
  List<DateTime> toggleClockedIn = new List<DateTime>();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
            title: Text(widget.title),
            actions: <Widget>[
              new IconButton(
                icon: Icon(Icons.settings),
                onPressed: _goToSettings,
              )
            ]
        ),
        body: body()
    ); // This trailing comma makes auto-formatting nicer for build methods
  }

  Widget body() {
    Column main = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new TotalTimerText(toggleBreak, toggleClockedIn),
          Text("Zeit heute Pause gemacht"),
          Text("Jetzt abhauen macht minus"),
          RaisedButton(
            onPressed: () {
              toggleClockedIn.add(DateTime.now());
              setState(() {

              });
            },
            child: new Text(
              (toggleClockedIn.length % 2 == 0) ? 'Einstempeln' : "Ausstempeln",
          ),
          ),
          RaisedButton(
            onPressed: () {
              toggleBreak.add(DateTime.now());
              setState(() {

              });
            },
            child: new Text(
              (toggleBreak.length % 2 == 0) ? 'Pause beginnen' : 'Pause enden',
            ),
          ),
        ]
    );
    Row r = Row(mainAxisAlignment: MainAxisAlignment.center, children: [main]);
    return r;
  }

  _goToSettings() {
    Navigator.of(context).push(
        new MaterialPageRoute<void>(builder: (buildContext) {
          return settingsPage();
        }));
  }

  Widget settingsPage() {
    return new Scaffold(
        appBar: new AppBar(
          title: Text("Einstellungen"),
        ),
        body: ListView(
            itemExtent: 50,
            children: <Widget>[
              ListTile(
                  dense: true,
                  leading: Text("Arbeitszeit"),
                  title: TextField(
                    controller: new TextEditingController(
                        text: Config.workPerDay.toString()),
                  )
              ),
              ListTile(
                  dense: true,
                  leading: Text("Pausenzeit"),
                  title: TextField(
                    controller: new TextEditingController(
                        text: Config.breakPerDay.toString()),
                  )
              ),

            ]
        )
    );
  }

}

class TotalTimerText extends StatefulWidget {
  final List<DateTime> toggleBreak;
  final List<DateTime> toggleClockIn;

  TotalTimerText(this.toggleBreak, this.toggleClockIn);


  TotalTimerTextState createState() =>
      new TotalTimerTextState(toggleBreak, toggleClockIn);
}

class TotalTimerTextState extends State<TotalTimerText> {
  Timer timer;
  List<DateTime> toggleBreak;
  List<DateTime> toggleClockIn;

  TotalTimerTextState(this.toggleBreak, this.toggleClockIn) {
    timer = new Timer.periodic(new Duration(milliseconds: 1000), (timer) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Text("Arbeitszeit: " + calcWorkTime().toString());
  }

  Duration calcWorkTime() {
    Duration workTime = new Duration(minutes: 0);
    bool inBreak = false;
    bool clockedIn = false;
    int indexClockIn = 1;
    DateTime lastPointOfReference;
    if (toggleClockIn.length > 0) {
      lastPointOfReference = toggleClockIn[0];
      clockedIn = true;
      for (DateTime breakToggle in toggleBreak) {
        if (indexClockIn < toggleClockIn.length &&
            toggleClockIn[indexClockIn].compareTo(breakToggle) < 0) {
          if (inBreak && clockedIn) {
            clockedIn = false;
          } else if (!inBreak && clockedIn) {
            clockedIn = false;
            workTime +=
                toggleClockIn[indexClockIn].difference(lastPointOfReference);
          } else if (inBreak && !clockedIn) {
            clockedIn = true;
          } else if (!inBreak && !clockedIn) {
            clockedIn = true;
          }
          indexClockIn++;
        } else {
          if (inBreak) {
            inBreak = false;
            lastPointOfReference = breakToggle;
          } else {
            if (clockedIn) {
              workTime += breakToggle.difference(lastPointOfReference);
            }
            inBreak = true;
            //lastPointOfReference=breakToggle;
          }
        }
      }
      List<DateTime> clockInOverflow = toggleClockIn.sublist(indexClockIn);
      for (DateTime toggle in clockInOverflow) {
        if (clockedIn && !inBreak) {
          workTime += toggle.difference(lastPointOfReference);
          clockedIn = false;
          lastPointOfReference = toggle;
        } else {
          clockedIn = true;
          lastPointOfReference = toggle;
        }
      }
      if (clockedIn && !inBreak) {
        workTime += DateTime.now().difference(lastPointOfReference);
      }
    }
    return workTime;
  }

}

class Config {
  static Duration workPerDay = new Duration(hours: 7, minutes: 21);
  static Duration breakPerDay = new Duration(hours: 1);
}
