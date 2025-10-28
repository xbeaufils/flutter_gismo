import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:intl/intl.dart';

abstract class TraitementAbstract {
  final _df = new DateFormat('dd/MM/yyyy');
  int ? _idBd;
  late DateTime _debut;
  late DateTime _fin;
  late String  _numBoucle;
  late String _numMarquage;
  int ? _idBete;
  int ? _idLamb;
  String ? _ordonnance;
  String ? _intervenant;
  String ? _motif;
  String ? _observation;

  int ? get idBd => _idBd;
  DateTime get debut =>_debut;
  DateTime get fin =>_fin;
  String get numBoucle =>_numBoucle;
  String get numMarquage =>_numMarquage;
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

  set debut(DateTime value) {
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

   set fin(DateTime value) {
    _fin = value;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (_idBd != null)
      data["idBd"] = _idBd ;
    data["debut"] = _df.format(_debut);
    data["fin"] = _df.format(_fin);
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

}

class MedicModel {
  late String _medicament;
  String ? _voie;
  String ? _dose;
  String ? _rythme;

  MedicModel();
  MedicModel.build(this._medicament, this._voie, this._dose, this._rythme);

  String get medicament =>_medicament;

  set medicament(String ? value) {
    _medicament = value!;
  }

  String ? get voie => _voie;

  set voie(String ? value) {
    _voie = value;
  }


  String ? get dose => _dose;

  String ? get rythme => _rythme;

  set rythme(String  ? value) {
    _rythme = value;
  }

  set dose(String ? value) {
    _dose = value;
  }

}

class TraitementModel extends TraitementAbstract{
  final _df = new DateFormat('dd/MM/yyyy');

  MedicModel ? _medic;

  MedicModel ? get medic => _medic;

  set medic(MedicModel ? value) {
    _medic = value;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (_idBd != null)
      data["idBd"] = _idBd ;
    data["debut"] = _df.format(_debut);
    data["fin"] = _df.format(_fin);
    data["medicament"] = medic!.medicament;
    data["voie"] = medic!.voie;
    data["dose"] = medic!.dose;
    data["rythme"] = medic!.rythme;
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

  TraitementModel() {
    _medic = MedicModel();
  }

  TraitementModel.fromResult(result) {
    _medic = MedicModel();
    _idBd= result["idBd"] ;
    _debut = _df.parse(result["debut"]) ;
    _fin = _df.parse(result["fin"] );
    medic!.medicament = result["medicament"] ;
    medic!.voie = result["voie"] ;
    medic!.dose = result["dose"] ;
    medic!.rythme = result["rythme"] ;
    _idBete = result["beteId"] ;
    _idLamb = result["lambId"];
    _ordonnance = result["ordonnance"] ;
    _intervenant = result["intervenant"] ;
    _motif = result["motif"] ;
    _observation = result["observation"] ;

  }
}

class TraitementMultiMedic extends TraitementAbstract {
  late List<Bete> _betes;
  late List<MedicModel> _medics;

  TraitementMultiMedic(TraitementModel traitement, this._medics, this._betes) {
    _idBd = traitement.idBd;
    _debut = traitement.debut;
    _fin = traitement.fin;
    _ordonnance = traitement.ordonnance;
    _intervenant = traitement.intervenant;
    _motif = traitement.motif;
    _observation = traitement.observation;
  }

  TraitementMultiMedic.fromResult(result) {
    _betes = result["betes"];
    _medics = result["medics"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["traitement"] = super.toJson;
    data["betes"] = _betes;
    data["medics"] = _medics;
    return data;
  }

}

class TraitementCollectif {
  late List<Bete> betes;
  late List<TraitementModel> traitements;

  TraitementCollectif(this.traitements, this.betes);

  TraitementCollectif.fromResult(result) {
    betes = result["betes"];
    traitements = result["traitement"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["betes"] = betes;
    data["traitements"] = traitements;
    return data;
  }
}