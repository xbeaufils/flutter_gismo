class Pesee {
  int id;
  int bete_id;
  double poids;
  String datePesee;
  Pesee();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (id != null)
      data["id"] = id ;
    data["datePesee"] = datePesee;
    data["poids"] = poids.toString();
    data["bete_id"] = bete_id.toString();
    return data;
  }

  Pesee.fromResult(result) {
    id = result["id"] ;
    datePesee = result["datePesee"];
    poids = result["poids"];
    bete_id = result["bete_id"];
  }

}