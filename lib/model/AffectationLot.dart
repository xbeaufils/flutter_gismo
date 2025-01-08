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
    final _df = new DateFormat('dd/MM/yyyy');

    idAffectation = result["idBd"];
    numBoucle = result["numBoucle"];
    numMarquage = result["numMarquage"];
    brebisId = result["brebisId"];
    lotId = result["lotId"];
    lotName = result["lotName"];
    dateEntree = _df.parse(result["dateEntree"]);
    if (dateEntree == null)
      dateEntree = _df.parse(result["dateDebutLutte"]);
    dateSortie = _df.parse(result["dateSortie"]);
    if (dateSortie == null)
      dateSortie = _df.parse(result["dateFinLutte"]);
  }
}
