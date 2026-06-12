import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:intl/intl.dart';

class Prelevement {
  final _df = new DateFormat('dd/MM/yyyy');

  int ? _id;

  late DateTime _datePrelevement;

  int ? get id => _id;

  set id(int ? value) {
    _id = value;
  }

  List<Bete>  _betes = [];
  List<Resultat> _resultats=[];
  String ? _cheptel;

  Prelevement();

  List<Bete> get betes => _betes;

  set betes(List<Bete> value) {
    _betes = value;
  }

  DateTime get datePrelevement => _datePrelevement;

  set datePrelevement(DateTime value) {
    _datePrelevement = value;
  }

  List<Resultat> get resultats => _resultats;

  set resultats(List<Resultat> value) {
    _resultats = value;
  }
  String ? get cheptel => _cheptel;

  Prelevement.fromResult(Map<String, dynamic> result) {
    this._id = result["id"];
    this._datePrelevement = DateTime.parse(result["date_prelevement"]);
    this._cheptel = result["cheptel"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (_id != null)
      data["idBd"] = _id ;
    data["datePrelevement"] = _df.format(_datePrelevement);
    data["cheptel"] = _cheptel ;
    return data;
  }

}

class Resultat {
  int ? _id;
  int ? _parasite;
  int ? _quantite;
}