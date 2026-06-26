import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:intl/intl.dart';

class Prelevement {
  final _df = new DateFormat('yyyy-MM-dd');

  int ? _id;

  late DateTime _datePrelevement;

  int ? get id => _id;

  set id(int ? value) {
    _id = value;
  }

  List<Bete>  _betes = [];
  List<Resultat> _resultats=[];
  String ? _cheptel;

  Prelevement(this._datePrelevement);
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

  set cheptel(String ? value) {
    _cheptel = value;
  }

  Prelevement.fromResult(Map<String, dynamic> result) {
    this._id = result["id"];
    this._datePrelevement = DateTime.parse(result["datePrelevement"]);
    this._cheptel = result["cheptel"];
    this._betes = result["betes"].map<Bete>((b) => Bete.fromResult(b)).toList();
    this._resultats = result["resultats"].map<Resultat>((r) => Resultat.fromResult(r)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (_id != null)
      data["id"] = _id ;
    data["datePrelevement"] = _df.format(_datePrelevement);
    data["cheptel"] = _cheptel ;
    data['betes'] = _betes.map((bete) => bete.toJson()).toList();
    data['resultats'] = _resultats.map((resultat) => resultat.toJson()).toList();
    return data;
  }

  String toEventString() {
    String event = "";
    for (Resultat resultat in _resultats) {
      if (resultat.parasite != null)
      switch (resultat.parasite!) {
        case Parasite.STRONGLES_GASTRO_INTESTINAUX:
          event += "S.G.I. : ${resultat.quantite}; ";
        case Parasite.STRONGLES_PULMONAIRES:
          event += "S.P. : ${resultat.quantite}; ";
        case Parasite.STRONGYLOIDES:
          event += "Str. : ${resultat.quantite}; ";
        case Parasite.NEMATODIRUS:
          event += "N. : ${resultat.quantite}; ";
        case Parasite.TRICHURES:
          event += "Tr. : ${resultat.quantite}; ";
        case Parasite.PETITES_DOUVES:
          event += "P.D. : ${resultat.quantite}; ";
        case Parasite.GRANDES_DOUVES:
          event += "G.D. : ${resultat.quantite}; ";
        case Parasite.PARAMPHISTOMES:
          event += "Pa : ${resultat.quantite}; ";
        case Parasite.TAENIA:
          event += "T : ${resultat.quantite}; ";
        case Parasite.COCCIDIES:
          event += "Co : ${resultat.quantite}; ";
      }
    }
    return event;
  }
}

enum Parasite {
  STRONGLES_GASTRO_INTESTINAUX,
  STRONGLES_PULMONAIRES,
  STRONGYLOIDES,
  NEMATODIRUS,
  TRICHURES,
  PETITES_DOUVES,
  GRANDES_DOUVES,
  PARAMPHISTOMES,
  TAENIA,
  COCCIDIES;
}

class Resultat {
  int ? _id;
  Parasite ? _parasite;
  int ? _quantite;

  Resultat.STRONGLES_GASTRO_INTESTINAUX(int qte) {
    _parasite = Parasite.STRONGLES_GASTRO_INTESTINAUX;
    _quantite = qte;
  }

  Resultat.STRONGLES_PULMONAIRES(int qte) {
    _parasite = Parasite.STRONGLES_PULMONAIRES;
    _quantite = qte;
  }

  Resultat.STRONGYLOIDES(int qte) {
    _parasite = Parasite.STRONGYLOIDES;
    _quantite = qte;
  }

  Resultat.NEMATODIRUS(int qte) {
    _parasite = Parasite.NEMATODIRUS;
    _quantite = qte;
  }

  Resultat.TRICHURES(int qte) {
    _parasite = Parasite.TRICHURES;
    _quantite = qte;
  }

  Resultat.PETITES_DOUVES(int qte) {
    _parasite = Parasite.PETITES_DOUVES;
    _quantite = qte;
  }

  Resultat.GRANDES_DOUVES(int qte) {
    _parasite = Parasite.GRANDES_DOUVES;
    _quantite = qte;
  }

  Resultat.PARAMPHISTOMES(int qte) {
    _parasite = Parasite.PARAMPHISTOMES;
    _quantite = qte;
  }

  Resultat.TAENIA(int qte) {
    _parasite = Parasite.TAENIA;
    _quantite = qte;
  }

  Resultat.COCCIDIES(int qte) {
    _parasite = Parasite.COCCIDIES;
    _quantite = qte;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = _id;
    data["parasite"] = _parasite!.name;
    data["quantite"] = _quantite;
    return data;
  }

  Resultat.fromResult(Map<String, dynamic> result) {
    this._id = result["id"];
    this._parasite = Parasite.values.firstWhere((e) => e.toString() == 'Parasite.' + result["parasite"]);
    this._quantite = result["quantite"];
  }

  int ? get id => _id;

  set id(int ? value) {
    _id = value;
  }

  int ? get quantite => _quantite;

  set quantite(int ? value) {
    _quantite = value;
  }

  Parasite ? get parasite => _parasite;

  set parasite(Parasite ? value) {
    _parasite = value;
  }
}