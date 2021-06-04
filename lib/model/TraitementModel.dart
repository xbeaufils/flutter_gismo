import 'package:flutter_gismo/model/BeteModel.dart';

class TraitementModel {
  int ? _idBd;
  late String _debut;
  late String _fin;
  late String _medicament;
  String ? _voie;
  String ? _dose;
  String ? _rythme;
  late String  _numBoucle;
  late String _numMarquage;
  int ? _idBete;
  int ? _idLamb;
  String ? _ordonnance;
  String ? _intervenant;
  String ? _motif;
  String ? _observation;

  int ? get idBd => _idBd;
  String get debut =>_debut;
  String get fin =>_fin;
  String get numBoucle =>_numBoucle;
  String get numMarquage =>_numMarquage;
  String get medicament =>_medicament;
  String ? get ordonnance =>_ordonnance;
  String ? get intervenant =>_intervenant;
  String ? get motif =>_motif;
  String ? get observation =>_observation;

  int ? get idBete => _idBete;
  int ? get idLamb => _idLamb;

  set idLamb(int ? value) {
    _idLamb = value;
  }

  set idBete(int ? value) {
    _idBete = value;
  }

  set numBoucle(String value) {
    _numBoucle = value;
  }

  set idBd(int ? value) {
    _idBd = value;
  }

  set debut(String value) {
    _debut = value;
  }

  set observation(String ? value) {
    _observation = value;
  }

  set motif(String ? value) {
    _motif = value;
  }

  set intervenant(String ? value) {
    _intervenant = value;
  }

  set ordonnance(String ? value) {
    _ordonnance = value;
  }

  set numMarquage(String ? value) {
    _numMarquage = value!;
  }

  set medicament(String ? value) {
    _medicament = value!;
  }

  String ? get voie => _voie;

  set voie(String ? value) {
    _voie = value;
  }

  set fin(String value) {
    _fin = value;
  }

  String ? get dose => _dose;

  String ? get rythme => _rythme;

  set rythme(String  ? value) {
    _rythme = value;
  }

  set dose(String ? value) {
    _dose = value;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (_idBd != null)
      data["idBd"] = _idBd ;
    data["debut"] = _debut;
    data["fin"] = _fin;
    data["medicament"] = _medicament;
    data["voie"] = _voie;
    data["dose"] = _dose;
    data["rythme"] = _rythme;
    if (_idBete != null)
      data["beteId"] = _idBete.toString();
    if (_idLamb != null)
      data["lambId"] = _idLamb.toString();
    data["ordonnance"] = _ordonnance;
    data["intervenant"] = _intervenant;
    data["motif"] = _motif;
    data["observation"] = _observation;
    return data;
  }

  TraitementModel() ;

  TraitementModel.fromResult(result) {
    _idBd= result["idBd"] ;
    _debut = result["debut"] ;
    _fin = result["fin"] ;
    _medicament = result["medicament"] ;
    _voie = result["voie"] ;
    _dose = result["dose"] ;
    _rythme = result["rythme"] ;
    _idBete = result["beteId"] ;
    _idLamb = result["lambId"];
    _ordonnance = result["ordonnance"] ;
    _intervenant = result["intervenant"] ;
    _motif = result["motif"] ;
    _observation = result["observation"] ;

  }
}

class TraitementCollectif {
  late List<Bete> betes;
  late TraitementModel traitement;

  TraitementCollectif(this.traitement, this.betes);

  TraitementCollectif.fromResult(result) {
    betes = result["betes"];
    traitement = result["traitement"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["betes"] = betes;
    data["traitement"] = traitement;
    return data;
  }
}