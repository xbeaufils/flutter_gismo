import 'package:intl/intl.dart';

class EchographieModel {
  int ? _idBd;
  late DateTime _dateEcho;
  DateTime ? _dateAgnelage;
  DateTime ? _dateSaillie;
  late int _nombre;
  late int _bete_id;
  final _df = new DateFormat('dd/MM/yyyy');

  EchographieModel();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (_idBd != null)
      data["id"] = _idBd ;
    data["dateEcho"] = _df.format(_dateEcho);
    data["dateAgnelage"] = (_dateAgnelage == null)?null:_df.format(_dateAgnelage!);
    data["dateSaillie"] = (_dateSaillie == null)?null:_df.format( _dateSaillie! );
    data["nombre"] = _nombre.toString();
    data["bete_id"] = _bete_id.toString();
    return data;
  }

  EchographieModel.fromResult(result) {
    _idBd = result["id"] ;
    _dateEcho = _df.parse(result["dateEcho"]);
    _dateAgnelage = (result["dateAgnelage"]==null)?null:_df.parse(result["dateAgnelage"]);
    _dateSaillie = (result["dateSaillie"] == null)?null:_df.parse(result["dateSaillie"]);
    _nombre = result["nombre"];
    _bete_id = result["bete_id"];
  }

  set bete_id(int value) {
    _bete_id = value;
  }

  set dateEcho(DateTime value) {
    _dateEcho = value;
  }

  set idBd(int ? value) {
    _idBd = value;
  }
  set dateAgnelage(DateTime ? value) {
    _dateAgnelage = value;
  }

   set nombre(int value) {
    _nombre = value;
  }

  set dateSaillie(DateTime ? value) {
    _dateSaillie = value;
  }

  int get bete_id => _bete_id;

  int get nombre => _nombre;

  DateTime ? get dateSaillie => _dateSaillie;

  DateTime ? get dateAgnelage => _dateAgnelage;

  DateTime get dateEcho => _dateEcho;

  int ? get idBd => _idBd;

 }