import 'package:flutter/material.dart';
import 'package:project_resonator/pages/learn.dart';
import 'package:project_resonator/pages/speak.dart';
import 'package:project_resonator/pages/awal.dart';
import 'package:project_resonator/pages/penyimpanan.dart';
import 'package:project_resonator/pages/history.dart';
import 'package:bmnav/bmnav.dart' as bmnav;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:project_resonator/services/db.dart';




class PenyimpananStack extends StatefulWidget {
  PenyimpananStack({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _PenyimpananStackState createState() => _PenyimpananStackState();
}

class _PenyimpananStackState extends State<PenyimpananStack> {
  int currentTab = 0;
  String dropdownValue = 'Riwayat';
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
        title: Text('Penyimpanan'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Flexible(
              child: Padding(
              padding: EdgeInsets.fromLTRB(12, 6, 12, 4),
              child: Card(
                child: DropdownButton<String>(
                    value: dropdownValue,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    onChanged: (value){
                switch(value){
                  case "Riwayat" :
                    setState(() {
            currentTab = 0;
            dropdownValue = 'Riwayat';
          });
                    break;
                  case "Template" :
                    setState(() {
            currentTab = 1;
            dropdownValue = 'Template';
          });
                    break;
                }
              },
                    items: <String>['Riwayat', 'Template']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
              ),
            ),
            ),
            
            Expanded(
              child: IndexedStack(
            children: <Widget>[
              History(),
              Penyimpanan(),
            ],
            index: currentTab,
          ),
            ),
            

          ],
        ),
      ),



      
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}