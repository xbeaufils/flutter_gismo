import 'package:flutter_gismo/model/BeteModel.dart';

class Prelevement {

  int ? _id;

  late DateTime _datePrelevement;

  int ? get id => _id;

  set id(int ? value) {
    _id = value;
  }

  List<Bete>  _betes = [];
  List<Resultat> _resultats=[];

  Prelevement.fromResult(element);
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
}

class Resultat {
  int ? _id;
  int ? _parasite;
  int ? _quantite;
}