import 'package:intl/intl.dart';

enum Sex { male, femelle }
//enum Motif_Entree {bouclage, achat}

class Bete  {
  int ? _idBd;
  String ? _numBoucle;
  String ? _numMarquage;
  String ? _nom;
  DateTime ? _dateEntree;
  Sex ? _sex = Sex.male;
  //Motif_Entree _motifEntree = Motif_Entree.achat;
  String ? _observations;
  String ? _motifEntree ;
  String ? _cheptel;

  Bete( this._idBd, this._numBoucle, this._numMarquage, this._nom, this._observations, this._dateEntree, this._sex, this._motifEntree);

  Bete.fromResult (result){
    final _df = new DateFormat('dd/MM/yyyy');
    _idBd = result["id"];
    _numBoucle = result["numBoucle"];
    _numMarquage = result["numMarquage"];
    _nom = result["nom"];
    _dateEntree = _df.parse(result["dateEntree"]);
    _observations = result["observations"];
    if (result['sex'] != null)
      _sex= Sex.values.firstWhere((e) => e.toString() == 'Sex.' + result["sex"]);
    _motifEntree = result["motifEntree"]; //Motif_Entree.values.firstWhere((e) => e.toString() == 'Motif_Entree.' + result["motifEntree"]);
    _cheptel = result["cheptel"];
  }

  Map<String, dynamic> toJson() {
    final _df = new DateFormat('dd/MM/yyyy');
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (_idBd != null)
      data["id"] = _idBd ;
    data["numBoucle"] = _numBoucle;
    data["numMarquage"] = _numMarquage;
    data["nom"] = _nom;
    if (_dateEntree != null)
      data["dateEntree"] = _df.format(_dateEntree!);
    data["observations"] = _observations;
    data["sex"]= _sex.toString().split('.').last;
    data["motifEntree"] = _motifEntree.toString().split('.').last;
    data["cheptel"] = _cheptel ;
    return data;
  }

  int ? get idBd => _idBd;
  String get numBoucle =>_numBoucle!;
  String get numMarquage =>_numMarquage!;
  String ? get nom =>_nom;
  DateTime get dateEntree => _dateEntree! ;
  Sex get sex => _sex!;
  String get motifEntree =>_motifEntree!;

  String ? get observations => _observations;

  set observations(String ? value) {
    _observations = value;
  }

  set numBoucle(String value) {
    _numBoucle = value;
  }

  set motifEntree(String value) {
    _motifEntree = value;
  }

  set sex(Sex value) {
    _sex = value;
  }

  set dateEntree(DateTime value) {
    _dateEntree = value;
  }

  set numMarquage(String value) {
    _numMarquage = value;
  }

  set nom(String ? value) {
    _nom = value;
  }

  set idBd(int ? value) {
    _idBd = value;
  }

  String get cheptel => _cheptel!;

  set cheptel(String value) {
    _cheptel = value;
  }
}

