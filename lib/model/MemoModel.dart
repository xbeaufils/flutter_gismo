import 'dart:core';

import 'package:intl/intl.dart';

enum MemoClasse {ALERT, WARNING, INFO}

class MemoModel {
  int ? id;
  int ? bete_id;
  String ? numBoucle;
  String ? numMarquage;
  DateTime ? debut;
  DateTime ? fin;
  MemoClasse ? classe;
  String ? note;
  bool isExpanded=false;
  final _df = new DateFormat('dd/MM/yyyy');

  MemoModel();

  MemoModel.fromResult(result) {
    id = result["id"];
    debut = _df.parse( result["debut"]);
    if (result["fin"] != null)
      fin = _df.parse(result["fin"]);
    numBoucle = result["numBoucle"];
    numMarquage = result["numMarquage"];
    note = result["note"];
    bete_id = result["bete_id"];
    switch (result["classe"]) {
      case "ALERT":
        classe = MemoClasse.ALERT;
        break;
      case "WARNING":
        classe = MemoClasse.WARNING;
        break;
      case "INFO":
        classe = MemoClasse.INFO;
        break;
      default:
        classe = MemoClasse.ALERT;
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = id;
    data["debut"] = _df.format(debut!);
    if (fin != null)
      data["fin"] = _df.format(fin!);
    data["classe"] = classe;
    data["note"] = note;
    data["bete_id"] = bete_id;
    switch (classe) {
      case MemoClasse.ALERT:
        data["classe"] = MemoClasse.ALERT.name  ;
        break;
      case MemoClasse.WARNING:
        data["classe"] = MemoClasse.WARNING.name;
        break;
      case MemoClasse.INFO:
        data["classe"] = MemoClasse.INFO.name;
        break;
      default:
        classe = MemoClasse.ALERT;
    }
    return data;
  }
}

