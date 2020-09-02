import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:project_resonator/models/saved-item.dart';
import 'package:project_resonator/services/db.dart';

class Penyimpanan extends StatefulWidget {
  _PenyimpananState createState() => _PenyimpananState();
  Penyimpanan({Key key}) : super(key: key);
}

class _PenyimpananState extends State<Penyimpanan> {
  String kalimat;
  List<SavedItem> _kalimat = [];
  TextStyle _style = TextStyle(color: Colors.black, fontSize: 24);

  List<Widget> get _items => _kalimat.map((item) => format(item)).toList();

  Widget format(SavedItem item) {

    return Dismissible(
      key: Key(item.id.toString()),
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, 6, 12, 4),
        child: Card(
          child: ListTile(
            title: Text(item.kalimat, style: _style),
            
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
            FlatButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop()
            ),
            FlatButton(
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
    super.initState();
    
  }

  void refresh() async {

    List<Map<String, dynamic>> _results = await DB.query(SavedItem.table);
    _kalimat = _results.map((item) => SavedItem.fromMap(item)).toList();
    setState(() { });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Penyimpanan'),
      ),
      body: Center(
        child: ListView( children: _items )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () { _create(context); },
        tooltip: 'New TODO',
        child: Icon(Icons.library_add),
      )
    );
  }
}