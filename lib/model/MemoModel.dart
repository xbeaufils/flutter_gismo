import 'dart:core';

enum MemoClasse {ALERT, WARNING, INFO}

class MemoModel {
  int ? id;
  int ? bete_id;
  String ? numBoucle;
  String ? numMarquage;
  String ? debut;
  String ? fin;
  MemoClasse ? classe;
  String ? note;
  bool isExpanded=false;

  MemoModel();

  MemoModel.fromResult(result) {
    id = result["id"];
    debut = result["debut"];
    fin = result["fin"];
    numBoucle = result["numBoucle"];
    numMarquage = result["numMarquage"];
    //classe = result["classe"];
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
    data["debut"] = debut;
    data["fin"] = fin;
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

