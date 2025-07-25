import 'package:intl/intl.dart';

class Parcelle {
  late int id;
  late String idu;
  late String numero;
  late String cheptel;
  late String nomCommune;
  late String? secteurName;
  late int? secteurId;

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
  int ? id;
  int ? lotId;
  String ? lot;
  DateTime ? debut;
  DateTime ? fin;
  late int parcelleId;
  final _df = new DateFormat('dd/MM/yyyy');

  Pature.fromResult(result) {
    id = result['id'];
    lotId = result['lotId'];
    lot = result['lot'];
    if (result['debut'] != null )
      debut = _df.parse(result['debut']);
    if (result['fin'] != null)
      fin = _df.parse(result['fin']);
    parcelleId = result['parcelleId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (id != null)
      data['id'] = id;
    if (lotId != null)
      data['lotId'] =lotId;
    data['debut'] = _df.format(debut!);
    if (fin != null)
      data['fin'] = _df.format(fin!);
    data['parcelleId'] = parcelleId;
    return data;
  }
}