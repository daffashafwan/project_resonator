import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:project_resonator/models/saved-item.dart';
import 'package:project_resonator/services/db.dart';
import 'package:project_resonator/pages/history.dart';

class Penyimpanan extends StatefulWidget {
  _PenyimpananState createState() => _PenyimpananState();
  Penyimpanan({Key key}) : super(key: key);
}

enum TtsState { playing, stopped }


class _PenyimpananState extends State<Penyimpanan> {

  FlutterTts flutterTts;
  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;
  String voice;
  String kalimat;
  List<SavedItem> _kalimat = [];
  TextStyle _style = TextStyle(color: Colors.black, fontSize: 15);

  List<Widget> get _items => _kalimat.map((item) => format(item)).toList();

  Widget format(SavedItem item) {

    return Dismissible(
      key: Key(item.id.toString()),
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, 6, 12, 4),
        child: Card(
          child: ListTile(
            title: Text(item.kalimat, style: _style),
            onTap: (){
              setState(() {
                voice = item.kalimat;
              });
              _speak();
              },
          ),
        ),
      ),
      onDismissed: (DismissDirection direction) => _delete(item),
    );
  }

  void start() async{
    WidgetsFlutterBinding.ensureInitialized();

  await DB.init();

  }
  void _delete(SavedItem item) async {
    
    DB.delete(SavedItem.table, item);
    refresh();
  }

  void _save() async {

    Navigator.of(context).pop();
    SavedItem item = SavedItem(
      kalimat: kalimat,
    );

    await DB.insert(SavedItem.table, item);
    setState(() => kalimat = '' );
    refresh();
  }

  void _create(BuildContext context) {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Tambah Kalimat Baru"),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop()
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () => _save()
            )           
          ],
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(labelText: 'Isi Kalimat', hintText: 'cth. Selamat Pagi'),
            onChanged: (value) { kalimat = value; },
          ),
        );
      }
    );
  }

  void initState(){
    //start();
    refresh();
    initTts();
    super.initState();
    
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

  void refresh() async {

    List<Map<String, dynamic>> _results = await DB.query(SavedItem.table);
    _kalimat = _results.map((item) => SavedItem.fromMap(item)).toList();
    setState(() { });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
              padding: EdgeInsets.fromLTRB(12, 6, 12, 4),
              child: Card(
                child: ListView( children: _items ),
              ),
            ),
            ),
            

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () { _create(context); },
        tooltip: 'New TODO',
        child: Icon(Icons.library_add),
      )
    );
  }
}