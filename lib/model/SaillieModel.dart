class SaillieModel {
  int ? idBd;
  String ? dateSaillie;
  late int idMere;
  String ? numBoucleMere;
  String ? numMarquageMere;
  late int idPere;
  String ? numBouclePere;
  String ? numMarquagePere;

  SaillieModel();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (idBd != null)
      data["idBd"] = idBd;
    data["idMere"] = idMere;
    data["idPere"] = idPere;
    data["dateSaillie"] = dateSaillie;
    return data;
  }

  SaillieModel.fromResult(result) {
    idBd = result["idBd"];
    dateSaillie = result["dateSaillie"];
    idMere = result["idMere"];
    numBoucleMere = result["numBoucleMere"];
    numMarquageMere = result["numMarquageMere"];
    idPere = result["idPere"];
    numBouclePere = result["numBouclePere"];
    numMarquagePere = result["numMarquagePere"];
  }

}