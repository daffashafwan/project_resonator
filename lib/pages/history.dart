import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project_resonator/models/history-item.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:project_resonator/services/db.dart';

class History extends StatefulWidget {
  _HistoryState createState() => _HistoryState();
  History({Key key}) : super(key: key);
}

enum TtsState { playing, stopped }

class _HistoryState extends State<History> {

  FlutterTts flutterTts;
  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;
  String voice;
  List<HistoryItem> _kalimat = [];
  List<Widget> get _items => _kalimat.map((item) => format(item)).toList();

  TextStyle _style = TextStyle(color: Colors.black, fontSize: 15);
  TextStyle _style_2 = TextStyle(color: Colors.black, fontSize: 10);

  Widget format(HistoryItem item) {

    return Dismissible(
      key: Key(item.id.toString()),
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, 6, 12, 4),
        child: Card(
          child: ListTile(
            title: Text(item.kalimat, style: _style),
            subtitle: Text(item.timestamp, style: _style_2),
            isThreeLine: true,
            onTap: (){
              setState(() {
                voice = item.kalimat;
              });
              _speak();
              },
            onLongPress: (){
              _deleteDialog(item);
            }  
          ),
        ),
      ),
      
    );
  }

  void _deleteDialog(HistoryItem item){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Hapus Kalimat"),
          actions: <Widget>[
            FlatButton(
              child: Text('Tidak'),
              onPressed: () => Navigator.of(context).pop()
            ),
            FlatButton(
              child: Text('Iya'),
              onPressed: () {_delete(item);Navigator.of(context).pop();} 
            )           
          ],
          content: Text('Apakah anda ingin menghapus ?'),
        );
      }
    );
  }


  void initState(){
    //start();
    
    super.initState();
    initTts();
    refresh();
    
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

    if (voice != null) {
      if (voice.isNotEmpty) {
        var result = await flutterTts.speak(voice);
        if (result == 1) setState(() => ttsState = TtsState.playing);
      }
    }
  }

  void _delete(HistoryItem item) async {
    
    DB.delete(HistoryItem.table, item);
    refresh();
  }

  Future refresh() async {

    List<Map<String, dynamic>> _results = await DB.query(HistoryItem.table);
    _kalimat = _results.map((item) => HistoryItem.fromMap(item)).toList();
    setState(() { });
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat'),
      ),
      //floatingActionButton: FloatingActionButton(
      //  onPressed: () { refresh();},
      //  tooltip: 'Refresh',
      //  child: Icon(Icons.refresh),
      //),
      body: Center(
        child: RefreshIndicator(
          child: ListView( children: _items ),
          onRefresh: refresh,
        ),

      ),
    );
  }
}