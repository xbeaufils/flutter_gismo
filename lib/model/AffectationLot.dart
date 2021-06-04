class Affectation {
  late int idAffectation;
  late String numBoucle;
  late String numMarquage;
  late int brebisId;
  late int lotId;
  late String lotName;
  late String dateEntree;
  late String dateSortie;

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

  Affectation.fromResult(Map result) {
    //result.containsKey("dateFinLutte")
    idAffectation = result["idBd"];
    numBoucle = result["numBoucle"];
    numMarquage = result["numMarquage"];
    brebisId = result["brebisId"];
    lotId = result["lotId"];
    lotName = result["lotName"];
    dateEntree = result["dateEntree"];
    if (dateEntree == null)
      dateEntree = result["dateDebutLutte"];
    else if (dateEntree.isEmpty)
      dateEntree = result["dateDebutLutte"];
    dateSortie = result["dateSortie"];
    if (dateSortie == null)
      dateSortie = result["dateFinLutte"];
    else if (dateSortie.isEmpty)
      dateSortie = result["dateFinLutte"];
  }
}
