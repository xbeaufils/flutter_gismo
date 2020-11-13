import 'package:flutter_gismo/model/BeteModel.dart';

class MethodeAllaitementNotFoundException implements Exception {}

class LambingModel {
  int _idBd;
  String _dateAgnelage;
  int _idMere;
  String _numBoucleMere;
  String _numMarquageMere;
  int _qualite;
  int _adoption;
  List<LambModel> _lambs;

  int get qualite => _qualite;

  set qualite(int value) {
    _qualite = value;
  }

  String get dateAgnelage => _dateAgnelage ;
  void setDateAgnelage(String dateAgnelage) {
    this._dateAgnelage = dateAgnelage;
  }
  int get idMere => _idMere;
  void setIdMere(int idMere) {
    this._idMere = idMere;
  }

  String get numMarquageMere => _numMarquageMere;

  set numMarquageMere(String value) {
    _numMarquageMere = value;
  }

  String get numBoucleMere => _numBoucleMere;

  set numBoucleMere(String value) {
    _numBoucleMere = value;
  }

  int get idBd => _idBd;
  set idBd(int value) {
    _idBd = value;
  }
  int get adoption => _adoption;

  set adoption(int value) {
    _adoption = value;
  }

  List<LambModel> get lambs => _lambs;

  set lambs(List<LambModel> value) {
    _lambs = value;
  }

  LambingModel(this._idMere) {
    this._lambs = new List();
  }

  LambingModel.fromResult (result){
    _idBd = result["id"];
    _idMere = result["mere_id"];
    _numBoucleMere = result["numBoucleMere"];
    _numMarquageMere = result["numMarquageMere"];
    _dateAgnelage = result["dateAgnelage"];
    _qualite = result["qualite"];
    _adoption = result["adoption"];
    if (result['agneaux'] != null) {
      if (result['agneaux'].length > 0) {
        this._lambs = new List();
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
    data["dateAgnelage"]= this.dateAgnelage;
    data["qualite"] = this._qualite;
    data["adoption"] = this._adoption;
    data["agneaux"] = this._lambs.map((lamb) => lamb.toJson()).toList();
    return data;
  }

  Map<String, dynamic> toBdJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._idBd != null)
      data['id'] = this._idBd;
    data["mere_id"]= this.idMere;
    data["dateAgnelage"]= this.dateAgnelage;
    data["qualite"] = this._qualite;
    data["adoption"] = this._adoption;
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
    return null;
  }
}

class LambModel {
  int _idBd;
  int _idAgnelage;
  int _idDevenir;
  Sex _sex = Sex.male;
  String _marquageProvisoire;

  String _numBoucle;
  String _numMarquage;
  String _dateDeces;
  String _motifDeces;
  MethodeAllaitement _allaitement;

  String get marquageProvisoire => _marquageProvisoire;
  set marquageProvisoire(String value) {
    _marquageProvisoire = value;
  }

  Sex get sex => _sex;
  set sex(Sex value) {
    _sex = value;
  }

  int get idBd => _idBd;

  int get idAgnelage => _idAgnelage;

  set idAgnelage(int value) {
    _idAgnelage = value;
  }

  int get idDevenir => _idDevenir;

  set idDevenir(int value) {
    _idDevenir = value;
  }

  String get numBoucle => _numBoucle;

  set numBoucle(String value) {
    _numBoucle = value;
  }

  String get numMarquage => _numMarquage;

  set numMarquage(String value) {
    _numMarquage = value;
  }

  set idBd(int value) {
    _idBd = value;
  }

  String get dateDeces => _dateDeces;

  set dateDeces(String value) {
    _dateDeces = value;
  }

  String get motifDeces => _motifDeces;

  set motifDeces(String value) {
    _motifDeces = value;
  }

  MethodeAllaitement get allaitement => _allaitement;

  set allaitement(MethodeAllaitement value) {
    _allaitement = value;
  }

  LambModel(this._marquageProvisoire, this._sex, this._allaitement) ;

  LambModel.fromResult (result){
    _idBd = result["id"];
    _sex = Sex.values.firstWhere((e) => e.toString() == 'Sex.' + result["sex"]);
    _marquageProvisoire = result["marquageProvisoire"];
    _numMarquage = result["numMarquage"];
    _numBoucle = result["numBoucle"];
    _idAgnelage= result["agnelage_id"];
    _idDevenir = result["devenir_id"];
    _dateDeces = result["dateDeces"];
    _motifDeces = result["motifDeces"];
    _allaitement = MethodeAllaitement.getMethodeAllaitement(result["allaitement"]);
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
    return data;
  }



}
/*
class Bouclage {
  final LambModel _lamb;
  Bete _bete;

  LambModel get lamb => _lamb;

   final String _dateBouclage;

  Bouclage( this._lamb, this._dateBouclage);

  Bete get bete => _bete;

  set bete(Bete value) {
    _bete = value;
  }

  String get dateBouclage => _dateBouclage;
}
 */