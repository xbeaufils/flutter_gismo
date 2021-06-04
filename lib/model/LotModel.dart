import 'package:flutter_gismo/model/BeteModel.dart';

class LotModel {
  late int _idb;
  late String _cheptel;
  late String _codeLotLutte;
  late String _campagne;
  //<xsd:element name="DateDebutLutte" type="xsd:date"/>
  late String _dateDebutLutte;
  //<xsd:element name="DateFinLutte" type="xsd:date"/>
  late String _dateFinLutte;
  //<xsd:element name="CodeReproduction" type="CODEMETHODEREPRODUCTION:TypeCodeMethodeReproduction"/>
  //<xsd:element name="CodeLutteMain" type="xsd:boolean"/>
  late bool _codeLutteMain;
  //<xsd:element name="NombreDeBrebis" type="Nombre4Chiffres" minOccurs="0"/>
  //<xsd:element name="NombreDeBeliers" type="Nombre4Chiffres" minOccurs="0"/>
  //<xsd:element name="CodeRacePereSuppose" type="CODERACEOVIN:TypeCodeRacePhenotypiqueOvin" minOccurs="0"/>
  late List<Bete> _brebis;
  late List<Bete> _beliers;

  int get idb => _idb;

  set idb(int value) {
    _idb = value;
  }

  LotModel();

  LotModel.fromResult(result) {
    _idb = result["idBd"];
    _campagne = result["campagne"];
    _codeLotLutte = result["codeLotLutte"];
    _dateDebutLutte = result["dateDebutLutte"];
    _dateFinLutte = result["dateFinLutte"];
    _cheptel = result["cheptel"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (_idb != null)
      data["idBd"] = _idb ;
    data["campagne"] = _campagne;
    data["codeLotLutte"] = _codeLotLutte;
    data["dateDebutLutte"] = _dateDebutLutte;
    data["dateFinLutte"] = _dateFinLutte;
    data["cheptel"] = _cheptel ;
    return data;
  }

  String get codeLotLutte => _codeLotLutte;

  set codeLotLutte(String value){
    _codeLotLutte = value;
  }

  String get dateDebutLutte => _dateDebutLutte;

  set dateDebutLutte(String value) {
    _dateDebutLutte = value;
  }

  String get dateFinLutte => _dateFinLutte;

  set dateFinLutte(String value) {
    _dateFinLutte = value;
  }

  bool get codeLutteMain => _codeLutteMain;

  set codeLutteMain(bool value) {
    _codeLutteMain = value;
  }

  List<Bete> get brebis => _brebis;

  set brebis(List<Bete> value) {
    _brebis = value;
  }

  List<Bete> get beliers => _beliers;

  set beliers(List<Bete> value) {
    _beliers = value;
  }

  String get cheptel => _cheptel;

  set cheptel(String value) {
    _cheptel = value;
  }

  String get campagne => _campagne;

  set campagne(String value) {
    _campagne = value;
  }


}