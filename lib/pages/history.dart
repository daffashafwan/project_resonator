import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project_resonator/models/history-item.dart';
import 'package:project_resonator/services/db.dart';

class History extends StatefulWidget {
  _HistoryState createState() => _HistoryState();
  History({Key key}) : super(key: key);
}

class _HistoryState extends State<History> {

  List<HistoryItem> _kalimat = [];
  List<Widget> get _items => _kalimat.map((item) => format(item)).toList();

  TextStyle _style = TextStyle(color: Colors.black, fontSize: 15);
  TextStyle _style_2 = TextStyle(color: Colors.black, fontSize: 10);

  Widget format(HistoryItem item) {

    return Dismissible(
      key: Key(item.id.toString()),
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, 6, 12, 4),
        child: FlatButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(item.kalimat, style: _style),
              Text(item.timestamp, style: _style_2),
            ]
          ),
          
        )
      ),
      
    );
  }

  void refresh() async {

    List<Map<String, dynamic>> _results = await DB.query(HistoryItem.table);
    _kalimat = _results.map((item) => HistoryItem.fromMap(item)).toList();
    setState(() { });
  }

  void initState(){
    //start();
    refresh();
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () { refresh(); },
        tooltip: 'New TODO',
        child: Icon(Icons.library_add),
      ),
      body: Center(
        child: ListView( children: _items )
      ),
    );
  }
}