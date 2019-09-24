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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
          Text("Überschrift"),
          Text("Zeit heute gearbeitet"),
          Text("Zeit heute Pause gemacht"),
          Text("Jetzt abhauen macht minus"),
          Text("ein/ausstempeln"),
          Text("Pausen beginn/ende")
        ]
    );
    Row r = Row(mainAxisAlignment: MainAxisAlignment.center, children: [main]);
    return r;
  }

  _goToSettings() {
    Navigator.of(context).push(
        new MaterialPageRoute<void>(builder: (BuildContext) {
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
              ListTile(
                  dense: true,
                  leading: Text("Ab wann wird Pause angerechnet"),
                  title: TextField(
                    controller: new TextEditingController(
                        text: Config.breakCutOff.toString()),
                  )
              )
            ]
        )
    );
  }

}

class Config {
  static Duration workPerDay = new Duration(hours: 7, minutes: 21);
  static Duration breakPerDay = new Duration(hours: 1);
  static Duration breakCutOff = new Duration(hours: 6);
}
