import 'package:flutter/material.dart';
import 'package:project_resonator/pages/transcribe.dart';
import 'package:project_resonator/pages/speak.dart';
import 'package:project_resonator/pages/awal.dart';
import 'package:project_resonator/pages/penyimpanan.dart';
import 'package:project_resonator/pages/speechToText.dart';
import 'package:bmnav/bmnav.dart' as bmnav;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:project_resonator/pages/textToSpeech.dart';
import 'package:project_resonator/pages/transcribeYoutube.dart';
import 'package:project_resonator/services/db.dart';

class PenyimpananStack extends StatefulWidget {
  PenyimpananStack({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PenyimpananStackState createState() => _PenyimpananStackState();
}

class _PenyimpananStackState extends State<PenyimpananStack> {
  int currentTab = 0;
  String dropdownValue = 'Template';
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
                child: Container(
                  width: 380,
                  padding: EdgeInsets.only(left: 12, right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey, width: 0.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white60.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 5,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    isExpanded: true,
                    underline: SizedBox(),
                    onChanged: (value) {
                      switch (value) {
                        case "Template" :
                          setState(() {
                            currentTab = 0;
                            dropdownValue = 'Template';
                          });
                          break;
                        case "Text-to-Speech" :
                          setState(() {
                            currentTab = 1;
                            dropdownValue = 'Text-to-Speech';
                          });
                          break;
                        case "Speech-to-Text" :
                          setState(() {
                            currentTab = 2;
                            dropdownValue = 'Speech-to-Text';
                          });
                          break;
                        case "Transcribe Youtube" :
                          setState(() {
                            currentTab = 3;
                            dropdownValue = 'Transcribe Youtube';
                          });
                          break;
                      }
                    },
                    items: <String>['Template', 'Text-to-Speech', 'Speech-to-Text', 'Transcribe Youtube']
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
                  Penyimpanan(),
                  TexttoSpeech(),
                  SpeechtoText(),
                  TranscribeYoutube(),
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
