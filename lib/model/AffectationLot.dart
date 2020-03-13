class Affectation {
  int idAffectation;
  String numBoucle;
  String numMarquage;
  int brebisId;
  int lotId;
  String dateEntree;
  String dateSortie;

  Affectation();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (idAffectation != null)
      data["idBd"] = idAffectation;
    data["numBoucle"] = numBoucle;
    data["numMarquage"] = numMarquage;
    data["brebisId"] = brebisId;
    data["lotId"] = lotId;
    data["dateEntree"] = dateEntree;
    data["dateSortie"] = dateSortie;
  }

  Affectation.fromResult(result) {
    idAffectation = result["idBd"];
    numBoucle = result["numBoucle"];
    numMarquage = result["numMarquage"];
    brebisId = result["brebisId"];
    lotId = result["lotId"];
    dateEntree = result["dateEntree"];
    dateSortie = result["dateSortie"];

  }
}
