import 'package:intl/intl.dart';

class Affectation {
  int ? idAffectation;
  String ? numBoucle;
  String ? numMarquage;
  late int brebisId;
  late int lotId;
  String ? lotName;
  DateTime ? dateEntree;
  DateTime ? dateSortie;

  Affectation();
  Affectation.create(this.idAffectation, this.brebisId, this.lotId);

  Map<String, dynamic> toJson() {
    final _df = new DateFormat('dd/MM/yyyy');
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (idAffectation != null)
      data["idBd"] = idAffectation;
    data["numBoucle"] = numBoucle;
    data["numMarquage"] = numMarquage;
    data["brebisId"] = brebisId;
    data["lotId"] = lotId;
    if (dateEntree != null)
      data["dateEntree"] = _df.format(dateEntree!) ;
    if (dateSortie != null)
      data["dateSortie"] = _df.format(dateSortie!);
    return data;
  }

  Affectation.fromResult(Map result) {
    //result.containsKey("dateFinLutte")
    final _df = new DateFormat('dd/MM/yyyy');

    idAffectation = result["idBd"];
    numBoucle = result["numBoucle"];
    numMarquage = result["numMarquage"];
    brebisId = result["brebisId"];
    lotId = result["lotId"];
    lotName = result["lotName"];
    if (result['dateEntree'] != null)
      dateEntree = _df.parse(result["dateEntree"]);
    else {
      if (result['dateDebutLutte'] != null)
        dateEntree = _df.parse(result["dateDebutLutte"]);
    }
    if (result["dateSortie"] != null)
      dateSortie = _df.parse(result["dateSortie"]);
    else {
      if (result['dateFinLutte'] != null)
        dateSortie = _df.parse(result["dateFinLutte"]);
    }
  }
}
