import 'package:intl/intl.dart';

enum Sex { male, femelle }
enum Generation {INDETERMINE, PURE, F1, F2, F3 , F4}
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
  Hybridation ? _genetique;

  Bete( this._idBd, this._numBoucle, this._numMarquage, this._nom, this._observations, this._dateEntree, this._sex, this._motifEntree);

  Bete.create();

  Bete.fromResult (result){
    final _df = new DateFormat('dd/MM/yyyy');
    _idBd = result["id"];
    _numBoucle = result["numBoucle"];
    _numMarquage = result["numMarquage"];
    _nom = result["nom"];
    _dateEntree = _df.tryParse(result["dateEntree"]);
    _observations = result["observations"];
    if (result['sex'] != null)
      _sex= Sex.values.firstWhere((e) => e.toString() == 'Sex.' + result["sex"]);
    _motifEntree = result["motifEntree"]; //Motif_Entree.values.firstWhere((e) => e.toString() == 'Motif_Entree.' + result["motifEntree"]);
    _cheptel = result["cheptel"];
    if (result["genetique"] != null)
      _genetique = Hybridation.fromResult(result["genetique"]);
  }

  Map<String, dynamic> toJson() {
    final _df = new DateFormat('dd/MM/yyyy');
    final DateFormat _dfJson = new DateFormat('yyyy-MM-dd');
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (_idBd != null)
      data["id"] = _idBd ;
    data["numBoucle"] = _numBoucle;
    data["numMarquage"] = _numMarquage;
    data["nom"] = _nom;
    if (_dateEntree != null) {
      data["dateEntree"] = _df.format(_dateEntree!);
      data["dateEntree_json"] = _dfJson.format(_dateEntree!);
    }
    data["observations"] = _observations;
    data["sex"]= _sex.toString().split('.').last;
    data["motifEntree"] = _motifEntree.toString().split('.').last;
    data["cheptel"] = _cheptel ;
    if (_genetique != null)
      data["genetique"] = _genetique!.toJson();
    return data;
  }

  int ? get idBd => _idBd;
  String get numBoucle =>_numBoucle!;
  String ? get numBoucleOrNull =>_numBoucle;
  String get numMarquage =>_numMarquage!;
  String ? get numMarquageOrNull =>_numMarquage;
  String ? get nom =>_nom;
  DateTime ? get dateEntree => _dateEntree ;
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

  set dateEntree(DateTime ? value) {
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

  Hybridation ? get genetique => _genetique;
  set genetique(Hybridation ? value) {
    _genetique = value;
  }

  String formatCroisement() {
    if (_genetique == null)
      return "";
    String croisement = "";
    switch (_genetique!.niveau) {
      case Generation.PURE:
        croisement = "Pur";
      case Generation.F1:
        croisement = "F1";
      case Generation.F2:
        croisement = "F2";
      case Generation.F3:
        croisement = "F3";
      case Generation.F4:
        croisement = "F4";
      case Generation.INDETERMINE:
        croisement = "Indetermine";

    }
    if (_genetique!.races.length > 0) {
      croisement = croisement + " - ";
      for (int i = 0; i < _genetique!.races.length; i++) {
        croisement = croisement + _genetique!.races[i].nom;
        if (i < _genetique!.races.length - 1)
          croisement = croisement + ", ";
      }
    }
    return croisement;
  }
}

class Hybridation {
  late Generation _niveau;
  late List<Race> _races;

  Hybridation() {
    _races = [];
  }

  Generation get niveau => _niveau;

  set niveau(Generation value) {
    _niveau = value;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["niveau"] = _niveau.toString().split('.').last;
    data["races"] = _races.map((race) => race.toJson()).toList();
    return data;
  }

  Hybridation.fromResult(result) {
    _niveau = Generation.values.firstWhere((e) => e.toString() == 'Generation.' + result["niveau"]);
    _races = [];
    for (int i = 0; i < result["races"].length; i++) {
      _races.add(Race.fromResult(result["races"][i]));
    }
    _races.sort( (a,b) => a.ordre.compareTo(b.ordre));
  }

  List<Race> get races => _races;

  set races(List<Race> value) {
    _races = value;
  }
}

class Race {
  late int _ordre;
  late int _idRace;
  late String _nom;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["ordre"] = _ordre;
    data["idRace"] = _idRace;
    data["nom"] = _nom;
    return data;
  }

  Race.fromResult(result) {
    _idRace = result["idRace"];
    _nom = result["nom"];
    if (result["ordre"] != null)
      _ordre = result["ordre"];
  }

  int get ordre => _ordre;

  set ordre(int value) {
    _ordre = value;
  }

  String get nom => _nom;

  set nom(String value) {
    _nom = value;
  }

  int get idRace => _idRace;

  set idRace(int value) {
    _idRace = value;
  }


}