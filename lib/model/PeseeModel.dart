class Pesee {
  int id;
  int bete_id;
  int lamb_id;
  double poids;
  String datePesee;
  Pesee();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (id != null)
      data["id"] = id ;
    data["datePesee"] = datePesee;
    data["poids"] = poids.toString();
    if (bete_id != null)
      data["bete_id"] = bete_id.toString();
    if (lamb_id != null)
      data["lamb_id"] = lamb_id.toString();
    return data;
  }

  Pesee.fromResult(result) {
    id = result["id"] ;
    datePesee = result["datePesee"];
    poids = result["poids"];
    bete_id = result["bete_id"];
    lamb_id = result["lamb_id"];
  }

}