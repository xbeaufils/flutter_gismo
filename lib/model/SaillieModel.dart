import 'package:intl/intl.dart';

class SaillieModel {
  int ? idBd;
  DateTime ? dateSaillie;
  late int idMere;
  String ? numBoucleMere;
  String ? numMarquageMere;
  late int idPere;
  String ? numBouclePere;
  String ? numMarquagePere;
  final _df = new DateFormat('dd/MM/yyyy');

  SaillieModel();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (idBd != null)
      data["idBd"] = idBd;
    data["idMere"] = idMere;
    data["idPere"] = idPere;
    data["dateSaillie"] = _df.format(dateSaillie!);
    return data;
  }

  SaillieModel.fromResult(result) {
    idBd = result["idBd"];
    dateSaillie = _df.parse(result["dateSaillie"]);
    idMere = result["idMere"];
    numBoucleMere = result["numBoucleMere"];
    numMarquageMere = result["numMarquageMere"];
    idPere = result["idPere"];
    numBouclePere = result["numBouclePere"];
    numMarquagePere = result["numMarquagePere"];
  }

}