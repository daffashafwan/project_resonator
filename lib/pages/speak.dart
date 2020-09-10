import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:flutter/foundation.dart';
import 'package:split_view/split_view.dart';
import 'dart:math' as math;
import 'package:project_resonator/services/db.dart';
import 'dart:async';
import 'dart:core';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:project_resonator/models/history-item.dart';
import 'package:project_resonator/services/db.dart';
import 'package:intl/intl.dart';

class Speak extends StatefulWidget {
  List<String> litems = [];
  List<String> litems2 = [];
  List<String> litems3 = [];
  Speak({Key key, this.litems, this.litems2}) : super(key: key);

  @override
  _SpeakState createState() => _SpeakState();

}

enum TtsState { playing, stopped }

class _SpeakState extends State<Speak> {


  FlutterTts flutterTts;
  String _newVoiceText;
  String _newDateText;

  TtsState ttsState = TtsState.stopped;
  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;
  final Map<String, HighlightedWord> _highlights = {
    'resonator': HighlightedWord(
      onTap: () => print('resonator'),
      textStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ), 
  };
  bool _turn = false;
  bool _isType = false;   
  List<String> litems = [];
  List<String> litems2 = [];
  List<String> litems3 = [];
  List<String> litems4 = [];
  final TextEditingController eCtrl = new TextEditingController();
  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Coba Ngomong';
  double _confidence = 1.0;
  
  void _save(int index) async {

    //Navigator.of(context).pop();
    HistoryItem item = HistoryItem(
      kalimat: litems2[index],
      timestamp: litems4[index],
    );

    await DB.insert(HistoryItem.table, item);
    //setState(() => kalimat = '' );
    //refresh();
  }

  void initState(){
    super.initState();
    _speech = stt.SpeechToText();
    initTts();
  }

  initTts() {
    flutterTts = FlutterTts();


    flutterTts.setStartHandler(() {
      setState(() {
        print("playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _speak() async {
    await flutterTts.setLanguage("id-ID");

    if (_newVoiceText != null) {
      if (_newVoiceText.isNotEmpty) {
        var result = await flutterTts.speak(_newVoiceText);
        if (result == 1) setState(() => ttsState = TtsState.playing);
      }
    }
  }

  void _getDate(){
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd - kk:mm').format(now);
    setState(() {
      _newDateText = formattedDate;
      litems4.add(_newDateText);
      print(litems4);
      print(litems2);
    });
  }
  void _onChange(String text) {
    setState(() {
      _newVoiceText = text;
    });
  }

 void _create(BuildContext context) {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Riwayat Percakapan"),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: (){
              Navigator.of(context).pop();
              FocusScope.of(context).previousFocus();
              },
            ),           
          ],
          content: setupAlertDialoadContainer(),
        );
      }
    );
  }

  void _saveDialog(BuildContext context, int index) {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Simpan Riwayat ?"),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: (){
              Navigator.of(context).pop();
              FocusScope.of(context).previousFocus();
              },
            ),
            FlatButton(
              child: Text('Save'),
              onPressed: (){
              _save(index);
              Navigator.of(context).pop();
              },
            ),           
          ],
          content: Text(litems2[index]),
        );
      }
    );
  }

  TextStyle _style = TextStyle(color: Colors.black, fontSize: 15);

  Widget setupAlertDialoadContainer() {
  return Container(
    height: 300.0, // Change as per your requirement
    width: 300.0, // Change as per your requirement
    child: ListView.builder(
              itemCount: litems.length,
              itemBuilder: (BuildContext context, int index){
                return new Container(
                padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                child: RichText(
                  text: TextSpan(
                    text: litems[index],
                    style: DefaultTextStyle.of(context).style,
                  ),
                ),
              );
             }
            ),
  );
}




  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
          
        ),
      ),

      body: SplitView(
        viewMode: SplitViewMode.Vertical,
        initialWeight: 0.5,
        gripColor: Colors.blue,
        onWeightChanged: (w) => print("Vertical $w"),
        gripSize: 8.0,
        view1: Column(
                children: [
                    SizedBox(
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.volume_up),
                              tooltip: 'Listen Text',
                              onPressed: _speak,
                            ),
                          
                            IconButton(
                              icon: Transform.rotate(
                                angle: math.pi/2,
                                child: Icon(Icons.compare_arrows),
                              ),
                              tooltip: 'switch',
                              onPressed: () {
                                setState(() {
                                  _turn = !_turn;
                                });
                              },
                            ),
                          
                        ],
                      )
                    ),
                  
                  
                    Expanded(
                      
                      //height: MediaQuery.of(context).size.height / 2.7,
                      //color: Colors.white,
                      child: RotatedBox(
                        //color: Colors.blue,
                        quarterTurns: (_turn ? 2 : 4),
                        child: Column(
                          children: <Widget>[
                            new Padding(
                              padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
                              child: TextField(
                               textInputAction: TextInputAction.go,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Input Textnya' 
                                  ),
                              controller: eCtrl,
                              onTap: (){
                                if(_turn=true){
                                  setState(() {
                                  
                                  
                                  _turn = !_turn;
                                });
                                }
                              },
                              onChanged: (String value){
                                _onChange(value);
                              },
                              onSubmitted: (text) {
                                litems2.add(text);
                                eCtrl.clear();
                                _getDate();
                                
                                setState(() {});
                              },
                            ),
                              ),
                            new Expanded(
                              child: new ListView.builder
                                (
                                  itemCount: litems2.length,
                                  itemBuilder: (BuildContext ctxt, int Index) {
                                    return new Padding(
                                      padding: EdgeInsets.fromLTRB(12, 6, 12, 4),
                                      child: Card(
                                        child: ListTile(
                                          title: Text(litems2[Index], style: _style),
                                          //subtitle: Text(item.timestamp, style: _style_2),
                                          //isThreeLine: true,
                                          // onTap: (){
                                          //   setState(() {
                                          //     voice = item.kalimat;
                                          //   });
                                          //   _speak();
                                          //   },
                                           onLongPress: (){
                                            print(Index);
                                             _saveDialog(context, Index);
                                           }  
                                        ),
                                      ),
                                    );



                                    //Text(litems2[Index]);
                                  }
                              )
                            )
                          ],

                        ),
   
                        ),
                    )
                      
                    
                    
                  
                ],

            ),
          
        


        
      view2: Column(
        children: <Widget>[
          Flexible(
            child: SizedBox(
              height: 50,
              child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.history),
                              tooltip: 'Listen Text',
                              onPressed: () { _create(context); },
                            ),
                          
                        ],
                      )
            ),
          ),

          Expanded(
        
        child: SingleChildScrollView(
          
        reverse: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
          child: TextHighlight(
            text: _text,
            words: _highlights,
            textStyle: const TextStyle(
              fontSize: 32.0,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      ),


        ],
      ),

      



      


      /*ListView.builder(
              itemCount: litems.length,
              itemBuilder: (BuildContext context, int index){
                return new Container(
                padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                child: RichText(
                  text: TextSpan(
                    text: litems[index],
                    style: DefaultTextStyle.of(context).style,
                  ),
                ),
              );
             }
            ),*/
      ),      
  
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      print(_text);
      litems.add(_text);
    }
  }

  /*void _listen() async {
    if(_isListening == true){
      print('textnya : $_text');
      litems.add(_text);  
    }
    print('status : $_isListening');
    if (!_isListening) {
      
      
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );

      if (available) {

        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            //print('list : $litems');
            
          }),
        );

      }else{
        print('status : $available');
      }
    } else {

      setState(() => _isListening = false);
      _speech.stop();
      _text="Please Input Your Voice";

    }

  }*/
}