import 'dart:async';

import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:project_resonator/pages/transcribe.dart';
import 'package:project_resonator/pages/speak.dart';
import 'package:project_resonator/pages/awal.dart';
import 'package:project_resonator/pages/penyimpanan.dart';
import 'package:project_resonator/pages/penyimpananStack.dart';
import 'package:project_resonator/pages/speechToText.dart';
import 'package:bmnav/bmnav.dart' as bmnav;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:project_resonator/pages/splashscreen.dart';
import 'package:project_resonator/services/db.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await DB.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Map<int, Color> color =
  {
    50:Color.fromRGBO(87, 195, 130, .1),
    100:Color.fromRGBO(87, 195, 130, .2),
    200:Color.fromRGBO(87, 195, 130, .3),
    300:Color.fromRGBO(87, 195, 130, .4),
    400:Color.fromRGBO(87, 195, 130, .5),
    500:Color.fromRGBO(87, 195, 130, .6),
    600:Color.fromRGBO(87, 195, 130, .7),
    700:Color.fromRGBO(87, 195, 130, .8),
    800:Color.fromRGBO(87, 195, 130, .9),
    900:Color.fromRGBO(87, 195, 130, 1),


  };

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    MaterialColor colorCustom = MaterialColor(0xFF57C382, color);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TULIS',
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
        primarySwatch: colorCustom,
        primaryColor: colorCustom,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:MyHomePage(title: 'Resonator',) 
      // SplashScreen(
      //   'assets/splash.flr',
      //   MyHomePage(title: 'Resonator',),
      //   backgroundColor: Color(0xffffed9e),
      //   loopAnimation: 'Untitled',
      //   onSuccess: (_) {
      //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyHomePage(title: 'Resonator',)));
      //   },
      //   until: ()=> Future.delayed(Duration(milliseconds: 0)),
      // ),
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
  int currentTab = 1;
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
      body: SafeArea(
        top: true,
        child: IndexedStack(
            children: <Widget>[
              Learn(),
              Speak(),
              PenyimpananStack(),
            ],
            index: currentTab,
          ),
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
          bmnav.BottomNavItem(Icons.play_lesson_rounded, label: 'Learn'),
          bmnav.BottomNavItem(Icons.mic, label: 'Speak'),
          bmnav.BottomNavItem(Icons.bookmark, label: 'Saved')
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
