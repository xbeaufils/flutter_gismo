class Parcelle {
  late int id;
  late String idu;
  late String numero;
  late String cheptel;
  late String nomCommune;
  late String secteurName;
  late int secteurId;

  Parcelle.fromResult(result) {
    id= result['id'];
    idu= result["idu"] ;
    numero = result["numero"];
    cheptel = result["cheptel"];
    nomCommune = result["nomCommune"];
    secteurName = result['secteurName'];
    secteurId = result['secteurId'];
  }
}

class Pature {
  late int id;
  late int lotId;
  late String lot;
  late String debut;
  late String fin;
  late int parcelleId;

  Pature.fromResult(result) {
    id = result['id'];
    lotId = result['lotId'];
    lot = result['lot'];
    debut = result['debut'];
    fin = result['fin'];
    parcelleId = result['parcelleId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (id != null)
      data['id'] = id;
    if (lotId != null)
      data['lotId'] =lotId;
    data['debut'] = debut;
    if (fin != null)
      data['fin'] = fin;
    data['parcelleId'] = parcelleId;
    return data;
  }
}