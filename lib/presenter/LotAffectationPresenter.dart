import 'package:flutter_gismo/Lot/LotAffectationViewPage.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/model/AffectationLot.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LotModel.dart';
import 'package:flutter_gismo/services/LotService.dart';
import 'package:intl/intl.dart';

class LotAffectionPresenter {

  final _df = new DateFormat('dd/MM/yyyy');
  final GismoBloc _bloc;
  final LotAffectationContract _view;
  LotModel  _currentLot;
  LotAffectionPresenter(this._view, this._bloc, this._currentLot);
  final LotService _service = LotService();

  Future<String> deleteAffectation(Affectation event) async {
    String message = await this._bloc.deleteAffectation(event);
    return message;
  }

  Future<String?> addBete() async {
    Bete? selectedBete = await this._view.selectBete();
    String ? dateEntree = await this._view.selectDateEntree();
    String? message;
    if (dateEntree != null) {
      message = await this._service.addBete(this._currentLot, selectedBete!, dateEntree);
    }
    return message;
  }

  Future<String?> removeBete(Affectation affect,  String ? dateSortie) async {
    String? message;
    if (dateSortie != null ) {
      message = await this._service.removeFromLot(affect, dateSortie);
    }
    return message;
  }

  Future<LotModel> save(String campagne, String codeLot, String dateDebut, String dateFin) async {
    LotModel currentLot = LotModel();
    currentLot.dateDebutLutte = DateFormat.yMd().parse(dateDebut);
    if (currentLot.dateDebutLutte == "") {
      throw DateDebutException();
    }
    if (_df.parse(dateDebut).year.toString() != campagne) {
      throw new DebutCampagneException();
    }
    currentLot.dateFinLutte =  DateFormat.yMd().parse(dateFin);
    if (currentLot.dateFinLutte == "") {
      throw DateFinException();
    }
    currentLot.campagne = campagne;
    currentLot.codeLotLutte = codeLot;
    if (currentLot.codeLotLutte == "") {
      throw CodeLotException();
    }
    currentLot = (await this._service.saveLot(currentLot))!;
    return currentLot;
  }

  Future<List<Affectation>> getBeliers(int idLot)  {
    return this._service.getBeliersForLot(idLot);
  }

  Future<List<Affectation>> getBrebis(int idLot)  {
    return this._service.getBrebisForLot(idLot);
  }


}

class DateDebutException implements Exception {

}

class DebutCampagneException implements Exception {

}

class DateFinException implements Exception {

}

class CodeLotException implements Exception {

}