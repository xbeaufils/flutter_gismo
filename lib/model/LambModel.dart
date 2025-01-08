import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:intl/intl.dart';
enum Sante { VIVANT, MORT_NE, AVORTE }

class MethodeAllaitementNotFoundException implements Exception {}

class LambingModel {
  final _df = new DateFormat('dd/MM/yyyy');
  int ? _idBd;
  DateTime ? _dateAgnelage;
  late int _idMere;
  String ? _numBoucleMere;
  String ? _numMarquageMere;
  int ? idPere;
  String ? numBouclePere;
  String ? numMarquagePere;

  int ? _qualite;
  int ? _adoption;
  String ? _observations;
  late List<LambModel> _lambs;

  String ? get observations => _observations;

  set observations(String ? value) {
    _observations = value;
  }

  int ? get qualite => _qualite;

  set qualite(int ? value) {
    _qualite = value;
  }

  DateTime ? get dateAgnelage => _dateAgnelage ;
  void setDateAgnelage(DateTime ? dateAgnelage) {
    this._dateAgnelage = dateAgnelage;
  }
  int get idMere => _idMere;
  void setIdMere(int idMere) {
    this._idMere = idMere;
  }

  String ? get numMarquageMere => _numMarquageMere;

  set numMarquageMere(String ? value) {
    _numMarquageMere = value;
  }

  String ? get numBoucleMere => _numBoucleMere;

  set numBoucleMere(String ? value) {
    _numBoucleMere = value;
  }

  int ? get idBd => _idBd;
  set idBd(int ? value) {
    _idBd = value;
  }
  int ? get adoption => _adoption;

  set adoption(int ? value) {
    _adoption = value;
  }

  List<LambModel> get lambs => _lambs;

  set lambs(List<LambModel> value) {
    _lambs = value;
  }

  LambingModel(this._idMere) {
    this._lambs = [];
  }

  LambingModel.fromResult (result){
     _idBd = result["id"];
    _idMere = result["mere_id"];
    _numBoucleMere = result["numBoucleMere"];
    _numMarquageMere = result["numMarquageMere"];
    _dateAgnelage = _df.parse(result["dateAgnelage"]);
    _qualite = result["qualite"];
    _adoption = result["adoption"];
    _observations = result["observations"];
    idPere = result["pere_id"];
    numBouclePere = result["numBouclePere"];
    numMarquagePere = result["numMarquagePere"];
    if (result['agneaux'] != null) {
      if (result['agneaux'].length > 0) {
        this._lambs = [];
        for (int i = 0; i < result['agneaux'].length; i++) {
          this._lambs.add(LambModel.fromResult(result['agneaux'][i]));
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._idBd != null)
      data['id'] = this._idBd;
    data["mere_id"]= this.idMere;
    data["dateAgnelage"]= _df.format(this.dateAgnelage!);
    data["qualite"] = this._qualite;
    data["adoption"] = this._adoption;
    data["observations"] = this._observations;
    data["pere_id"] = this.idPere;
    data["agneaux"] = this._lambs.map((lamb) => lamb.toJson()).toList();
    return data;
  }

  Map<String, dynamic> toBdJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._idBd != null)
      data['id'] = this._idBd;
    data["mere_id"]= this.idMere;
    data["dateAgnelage"]= _df.format(this.dateAgnelage!);
    data["qualite"] = this._qualite;
    data["adoption"] = this._adoption;
    data["observations"] = this._observations;
    data["pere_id"] = this.idPere;
    return data;
  }


/*
  toJson() {
    return {
      "id" : this._idBd,
      "mere_id": this.idMere,
      "dateAgnelage": this.dateAgnelage,
      "qualite": this._qualite,
      "adoption": this._adoption,
      "agneaux" : this._lambs.map((lamb) => lamb.toJson()).toList()
    };
  }
  */


}

class MethodeAllaitement {
  String _key;
  String _libelle;

  String get key => _key;
  String get libelle => _libelle;

  MethodeAllaitement(this._key, this._libelle);

  static MethodeAllaitement ALLAITEMENT_MATERNEL = new MethodeAllaitement("ALLAITEMENT_MATERNEL", "Allaitement maternel");
  static MethodeAllaitement ALLAITEMENT_ARTIFICIEL = new MethodeAllaitement("ALLAITEMENT_ARTIFICIEL", "Allaitement artificiel");
  static MethodeAllaitement ADOPTE = new MethodeAllaitement("ADOPTE", "Adopté");
  static MethodeAllaitement BIBERONNE = new MethodeAllaitement("BIBERONNE", "Biberonné");

  static MethodeAllaitement getMethodeAllaitement(String value) {
    switch (value) {
      case "ALLAITEMENT_MATERNEL": return ALLAITEMENT_MATERNEL;
      case "ALLAITEMENT_ARTIFICIEL": return ALLAITEMENT_ARTIFICIEL;
      case "ADOPTE": return ADOPTE;
      case "BIBERONNE": return BIBERONNE;
    }
    throw new MethodeAllaitementNotFoundException();
  }
}

class LambModel {
  final _df = new DateFormat('dd/MM/yyyy');
  int ? _idBd;
  late int _idAgnelage;
  int ? _idDevenir;
  late Sex _sex = Sex.male;
  String ? _marquageProvisoire;

  String ? _numBoucle;
  String ? _numMarquage;
  DateTime ? _dateDeces;
  String ? _motifDeces;
  late MethodeAllaitement _allaitement;
  late Sante _sante;


  Sante get sante => _sante;

  set sante(Sante value) {
    _sante = value;
  }

  String ? get marquageProvisoire => _marquageProvisoire;
  set marquageProvisoire(String ? value) {
    _marquageProvisoire = value;
  }

  Sex get sex => _sex;
  set sex(Sex value) {
    _sex = value;
  }

  int ? get idBd => _idBd;

  int get idAgnelage => _idAgnelage;

  set idAgnelage(int value) {
    _idAgnelage = value;
  }

  int ? get idDevenir => _idDevenir;

  set idDevenir(int ? value) {
    _idDevenir = value;
  }

  String ? get numBoucle => _numBoucle;

  set numBoucle(String ? value) {
    _numBoucle = value;
  }

  String ? get numMarquage => _numMarquage;

  set numMarquage(String ? value) {
    _numMarquage = value;
  }

  set idBd(int ? value) {
    _idBd = value;
  }

  DateTime ? get dateDeces => _dateDeces;

  set dateDeces(DateTime ? value) {
    _dateDeces = value;
  }

  String ? get motifDeces => _motifDeces;

  set motifDeces(String ? value) {
    _motifDeces = value;
  }

  MethodeAllaitement get allaitement => _allaitement;

  set allaitement(MethodeAllaitement value) {
    _allaitement = value;
  }

  LambModel(this._marquageProvisoire, this._sex, this._allaitement, this._sante) ;

  LambModel.fromResult (result){
    _idBd = result["id"];
    _sex = Sex.values.firstWhere((e) => e.toString() == 'Sex.' + result["sex"]);
    _marquageProvisoire = result["marquageProvisoire"];
    _numMarquage = result["numMarquage"];
    _numBoucle = result["numBoucle"];
    //_idAgnelage= result["agnelage_id"];
    //_idDevenir = result["devenir_id"];
    if (result["dateDeces"] != null)
      _dateDeces = _df.parse( result["dateDeces"] );
    _motifDeces = result["motifDeces"];
    _allaitement = MethodeAllaitement.getMethodeAllaitement(result["allaitement"]);
    switch (result["sante"]) {
      case "VIVANT":
        _sante = Sante.VIVANT;
        break;
      case "MORT_NE":
        _sante = Sante.MORT_NE;
        break;
      case "AVORTE":
        _sante = Sante.AVORTE;
        break;
        default:
          _sante = Sante.VIVANT;
    }
  }

  Map<String, dynamic> toBdJson() {
    final Map<String, dynamic> data = toJson();
    data['agnelage_id'] = this._idAgnelage;
    data['devenir_id'] = this._idDevenir;
    return data;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._idBd != null)
      data['id'] = this._idBd;
    data['sex'] = this._sex.toString().split('.').last;
    data["allaitement"] = this._allaitement.key;
    data['marquageProvisoire'] = this._marquageProvisoire;
    switch ( this._sante) {
      case Sante.VIVANT:
        data['sante'] = "VIVANT";
        break;
      case Sante.MORT_NE:
        data['sante'] = "MORT_NE";
        break;
      case Sante.AVORTE:
        data['sante'] = "AVORTE";
        break;
      default :
        data['sante'] = "VIVANT";
    }
    return data;
  }
}

class CompleteLambModel extends LambModel {
  final _df = new DateFormat('dd/MM/yyyy');
  late String _numBoucleMere;
  late String _numMarquageMere;
  late DateTime _dateAgnelage;

  String get numBoucleMere => _numBoucleMere;

  String get numMarquageMere => _numMarquageMere;

  DateTime get dateAgnelage => _dateAgnelage;

  CompleteLambModel.fromResult(result) : super.fromResult(result) {
    _numBoucleMere = result["numBoucleMere"];
    _numMarquageMere = result["numMarquageMere"];
    _dateAgnelage = _df.parse(result["dateAgnelage"]);
  }
}
