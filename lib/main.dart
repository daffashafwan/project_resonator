import 'package:flutter/material.dart';
import 'package:project_resonator/pages/learn.dart';
import 'package:project_resonator/pages/speak.dart';
import 'package:project_resonator/pages/awal.dart';
import 'package:project_resonator/pages/penyimpanan.dart';
import 'package:project_resonator/pages/history.dart';
import 'package:bmnav/bmnav.dart' as bmnav;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:project_resonator/models/todo-item.dart';
import 'package:project_resonator/services/db.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await DB.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resonator App',
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
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Resonator'),
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
  int currentTab = 0;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: IndexedStack(
            children: <Widget>[
              Awal(),
              Learn(),
              Speak(),
              History(),
              Penyimpanan(),
            ],
            index: currentTab,
          ),
      bottomNavigationBar: bmnav.BottomNav(
        index: currentTab,
        onTap:(int i) {
          setState(() {
            currentTab = i;
          });
        },
        labelStyle: bmnav.LabelStyle(visible: false),
        iconStyle: bmnav.IconStyle(onSelectSize: 32.0),
        items: [
          bmnav.BottomNavItem(Icons.home, label: 'Home'),
          bmnav.BottomNavItem(Icons.book, label: 'Learn'),
          bmnav.BottomNavItem(Icons.mic, label: 'Speak'),
          bmnav.BottomNavItem(Icons.history, label: 'History'),
          bmnav.BottomNavItem(Icons.bookmark, label: 'Saved')
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
