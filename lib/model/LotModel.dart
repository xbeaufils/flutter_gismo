import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:intl/intl.dart';

class LotModel {
  int ? _idb;
  String ? _cheptel;
  String ? _codeLotLutte;
  String ? _campagne;
  DateTime ? _dateDebutLutte;
  DateTime ? _dateFinLutte;
  bool ? _codeLutteMain;
  late List<Bete> _brebis;
  late List<Bete> _beliers;
  final _df = new DateFormat('dd/MM/yyyy');

  int ? get idb => _idb;

  set idb(int ? value) {
    _idb = value;
  }

  LotModel();

  LotModel.fromResult(result) {
    _idb = result["idBd"];
    _campagne = result["campagne"];
    _codeLotLutte = result["codeLotLutte"];
    _dateDebutLutte = _df.parse(result["dateDebutLutte"]);
    _dateFinLutte = _df.parse(result["dateFinLutte"]);
    _cheptel = result["cheptel"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (_idb != null)
      data["idBd"] = _idb ;
    data["campagne"] = _campagne;
    data["codeLotLutte"] = _codeLotLutte;
    data["dateDebutLutte"] = _df.format(_dateDebutLutte!);
    data["dateFinLutte"] = _dateFinLutte;
    data["cheptel"] = _cheptel ;
    return data;
  }

  String ? get codeLotLutte => _codeLotLutte;

  set codeLotLutte(String ? value){
    _codeLotLutte = value;
  }

  DateTime ? get dateDebutLutte => _dateDebutLutte;

  set dateDebutLutte(DateTime ? value) {
    _dateDebutLutte = value;
  }

  DateTime ? get dateFinLutte => _dateFinLutte;

  set dateFinLutte(DateTime ? value) {
    _dateFinLutte = value;
  }

  bool ? get codeLutteMain => _codeLutteMain;

  set codeLutteMain(bool ? value) {
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

  String ? get cheptel => _cheptel;

  set cheptel(String ? value) {
    _cheptel = value;
  }

  String ? get campagne => _campagne;

  set campagne(String ? value) {
    _campagne = value;
  }


}