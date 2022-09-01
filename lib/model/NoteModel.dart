import 'dart:core';

class NoteTextuelModel {
  int ? id;
  int ? bete_id;
  String ? numBoucle;
  String ? numMarquage;
  String ? debut;
  String ? fin;
  String ? note;
  bool isExpanded=false;

  NoteTextuelModel();

  NoteTextuelModel.fromResult(result) {
    id = result["id"];
    debut = result["debut"];
    fin = result["fin"];
    numBoucle = result["numBoucle"];
    numMarquage = result["numMarquage"];
    note = result["note"];
    bete_id = result["bete_id"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = id;
    data["debut"] = debut;
    data["fin"] = fin;
    data["note"] = note;
    data["bete_id"] = bete_id;
    return data;
  }
}