import 'package:flutter_gismo/Gismo.dart';
import 'package:flutter_gismo/Lot/ui/LotAffectationViewPage.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/model/AffectationLot.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LotModel.dart';
import 'package:flutter_gismo/search/ui/SearchPage.dart';
import 'package:flutter_gismo/services/LotService.dart';
import 'package:intl/intl.dart';

class LotAffectionPresenter {

  final _df = new DateFormat('dd/MM/yyyy');
  final LotAffectationContract _view;
  LotModel  _currentLot;
  int _currentViewIndex=0;

  int get currentViewIndex => _currentViewIndex;

  LotAffectionPresenter(this._view,  this._currentLot);
  final LotService _service = LotService();

  Future<String> deleteAffectation(Affectation event) async {
    String message = await this._service.deleteAffectation(event);
    return message;
  }

  Future<String?> addBete() async {
    Bete ? selectedBete = await this._view.goNextPage(SearchPage(GismoPage.lot));
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

  Future<void> save(String campagne, String codeLot, String dateDebut, String dateFin) async {
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
    this._view.currentLot = currentLot;
  }

  Future<List<Affectation>> ? getBeliers(int idLot)  {
    return this._service.getBeliersForLot(idLot);
  }

  Future<List<Affectation>> getBrebis(int idLot)  {
    return this._service.getBrebisForLot(idLot);
  }

  void changePage(int index) {
    if (this._view.currentLot.idb == null ) {
      this._view.showMessage(S.current.batch_warning);
      return;
    }
      _currentViewIndex = index;
      switch (_currentViewIndex) {
        case 0:
          this._view.currentView = View.fiche;
          break;
        case 1:
          this._view.currentView = View.ram;
          break;
        case 2:
          this._view.currentView = View.ewe;
          break;
      }
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