import 'package:project_resonator/models/model.dart';

class SavedItem extends Model {

	static String table = 'saved_items';

	int id;
	String kalimat;

	TodoItem({ this.id, this.kalimat});

	Map<String, dynamic> toMap() {

		Map<String, dynamic> map = {
			'kalimat': kalimat,
		};

		if (id != null) { map['id'] = id; }
		return map;
	}

	static TodoItem fromMap(Map<String, dynamic> map) {
		
		return TodoItem(
			id: map['id'],
			kalimat: map['kalimat'],
		);
	}
}