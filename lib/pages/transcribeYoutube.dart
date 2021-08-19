import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project_resonator/models/history-item.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:project_resonator/services/db.dart';
import 'package:project_resonator/pages/penyimpanan.dart';

class TranscribeYoutube extends StatefulWidget {
  _TranscribeYoutubeState createState() => _TranscribeYoutubeState();
  TranscribeYoutube({Key key}) : super(key: key);
}

enum TtsState { playing, stopped }

class _TranscribeYoutubeState extends State<TranscribeYoutube> {
  FlutterTts flutterTts;
  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;
  String voice;
  List<HistoryItem> _kalimat = [];
  List<Widget> get _items => _kalimat.map((item) => format(item)).toList();

  TextStyle _style = TextStyle(color: Colors.black, fontSize: 18);
  TextStyle _style_2 = TextStyle(color: Colors.black, fontSize: 12);

  Widget format(HistoryItem item) {
    return Dismissible(
      key: Key(item.id.toString()),
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, 6, 10, 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              child: Card(
                color: Color.fromRGBO(87, 195, 130, .6),
                child: ListTile(
                  title: Text(item.kalimat, style: _style),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete, size: 30,),
                        onPressed: (){
                          _deleteDialog(item);
                        },
                      ),
                    ],
                  ),
                  subtitle: Text(item.timestamp, style: _style_2),
                  //isThreeLine: true,
                ),
              ),
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteDialog(HistoryItem item) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Hapus Kalimat"),
            actions: <Widget>[
              TextButton(
                  child: Text('Tidak'),
                  onPressed: () => Navigator.of(context).pop()),
              TextButton(
                  child: Text('Iya'),
                  onPressed: () {
                    _delete(item);
                    Navigator.of(context).pop();
                  })
            ],
            content: Text('Apakah anda ingin menghapus ?'),
          );
        });
  }

  void initState() {
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
    setState(() {});
  }

  String dropdownValue = 'One';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //floatingActionButton: FloatingActionButton(
      //  onPressed: () { refresh();},
      //  tooltip: 'Refresh',
      //  child: Icon(Icons.refresh),
      //),
      body: Center(
        child: RefreshIndicator(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(12, 6, 12, 4),
                  child: Card(
                    child: ListView(children: _items),
                  ),
                ),
              ),
            ],
          ),
          onRefresh: refresh,
        ),
      ),
    );
  }
}
