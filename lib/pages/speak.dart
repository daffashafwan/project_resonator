import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class Speak extends StatefulWidget {
  _SpeakState createState() => _SpeakState();
}



class _SpeakState extends State<Speak> {
  final Map<String, HighlightedWord> _highlights = {
    'resonator': HighlightedWord(
      onTap: () => print('resonator'),
      textStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ), 
  };

  List<String> litems = [];
  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Coba Ngomong';
  double _confidence = 1.0;

  void initState(){
    super.initState();
    _speech = stt.SpeechToText();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ayo rek Kudu isok Hwa"),
        ),
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

      body: ListView.builder(
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
            
            
          }),
        );

      }
    } else {

      setState(() => _isListening = false);
      _speech.stop();

    }
    
  }
}