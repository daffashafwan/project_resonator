import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:flutter/foundation.dart';
import 'package:split_view/split_view.dart';
import 'dart:math' as math;
import 'package:project_resonator/services/db.dart';
import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:project_resonator/models/history-item.dart';
import 'package:project_resonator/services/db.dart';
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
  List<String> litems = [];
  List<String> litems2 = [];
  List<String> litems3 = [];
  final TextEditingController eCtrl = new TextEditingController();
  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Coba Ngomong';
  double _confidence = 1.0;
 
  void _save() async {

    //Navigator.of(context).pop();
    HistoryItem item = HistoryItem(
      kalimat: _newVoiceText,
      timestamp: 'oi',
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

  void _onChange(String text) {
    setState(() {
      _newVoiceText = text;
    });
  }





  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(),
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
        view1: Container(
          padding: const EdgeInsets.all(8.0),
           child: Column(
                children: [
                  Flexible(
                    child: SizedBox(
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
                  ),
                  Flexible(
                    child: SizedBox(
                      height: 500,
                      child: RotatedBox(
                        quarterTurns: (_turn ? 2 : 4),
                        child: Column(
                          children: <Widget>[
                            new TextField(
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
                                _save();
                                setState(() {});
                              },
                            ),
                            new Expanded(
                              child: new ListView.builder
                                (
                                  itemCount: litems2.length,
                                  itemBuilder: (BuildContext ctxt, int Index) {
                                    return new Text(litems2[Index]);
                                  }
                              )
                            )
                          ],

                        ),
   
                        ),
                    ),
                    
                  ),
                ],

            ),
          
        ),


        
      view2: ListView.builder(
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
      ),      

    );
  }

  void _listen() async {
    
    if (!_isListening) {
      litems.add(_text);
      
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );

      if (available) {

        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            print('list : $litems');
            
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

  }
}