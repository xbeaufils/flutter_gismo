import 'dart:core';

enum NoteClasse {ALERT, WARNING, INFO}

class NoteTextuelModel {
  int ? id;
  int ? bete_id;
  String ? numBoucle;
  String ? numMarquage;
  String ? debut;
  String ? fin;
  NoteClasse ? classe;
  String ? note;
  bool isExpanded=false;

  NoteTextuelModel();

  NoteTextuelModel.fromResult(result) {
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
        classe = NoteClasse.ALERT;
        break;
      case "WARNING":
        classe = NoteClasse.WARNING;
        break;
      case "INFO":
        classe = NoteClasse.INFO;
        break;
      default:
        classe = NoteClasse.ALERT;
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
      case NoteClasse.ALERT:
        data["classe"] = NoteClasse.ALERT.name  ;
        break;
      case NoteClasse.WARNING:
        data["classe"] = NoteClasse.WARNING.name;
        break;
      case NoteClasse.INFO:
        data["classe"] = NoteClasse.INFO.name;
        break;
      default:
        classe = NoteClasse.ALERT;
    }
    return data;
  }
}

