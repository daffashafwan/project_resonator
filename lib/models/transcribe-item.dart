import 'package:project_resonator/models/model.dart';

class TranscribeItem extends Model {

  static String table = 'history_items';

  int id;
  String kalimat;
  String timestamp;

  TranscribeItem({ this.id, this.kalimat, this.timestamp});

  Map<String, dynamic> toMap() {

    Map<String, dynamic> map = {
      'kalimat': kalimat,
      'timestamp': timestamp,
    };

    if (id != null) { map['id'] = id; }
    return map;
  }

  static TranscribeItem fromMap(Map<String, dynamic> map) {

    return TranscribeItem(
      id: map['id'],
      kalimat: map['kalimat'],
      timestamp: map['timestamp'],
    );
  }
}