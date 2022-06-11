import 'package:intl/intl.dart';

class Todo {
  int? _id;
  late String _title;
  late String _description;
  late String _date = DateFormat.yMMMd().format(DateTime.now());

  Todo(this._title, this._date, this._description);

  Todo.comId(this._id, this._title, this._date, this._description);

  int? get id => _id;
  String get date => _date;
  String get title => _title;
  String get description => _description;

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      _title = newTitle;
    }
  }

  set description(String newDesc) {
    if (newDesc.length > 255) {
      _description = newDesc.substring(0, 255);
    } else {
      _description = newDesc;
    }
  }

  set date(String newDate) {
    _date = newDate;
  }

  Map<String, dynamic> toMap() {
    //convete um obj para um mapa
    var map = <String, dynamic>{};
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['desc'] = _description;
    map['date'] = _date;
    return map;
  }
//pojo

  Todo.fromMapObject(Map<String, dynamic> map) {
    //Pega um mapa e convente para um obj.
    _id = map['id'];
    _title = map['title'];
    _description = map['desc'];
    _date = map['date'];
  }
}
