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
    //if (dateEntree != null)
    //  if (dateEntree.isNotEmpty)
    data["dateEntree"] = dateEntree;
    //  if (dateSortie != null)
    //    if (dateSortie.isNotEmpty)
    data["dateSortie"] = dateSortie;
    return data;
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
