import 'package:flutter_gismo/Gismo.dart';
import 'package:flutter_gismo/Lot/ui/AffectationPage.dart';
import 'package:flutter_gismo/Lot/ui/LotAffectationViewPage.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/individu/ui/Bete.dart';
import 'package:flutter_gismo/model/AffectationLot.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LotModel.dart';
import 'package:flutter_gismo/search/ui/SearchPage.dart';
import 'package:flutter_gismo/search/ui/SelectMultiplePage.dart';
import 'package:flutter_gismo/services/LotService.dart';
import 'package:intl/intl.dart';

enum view {Lot, male, femelle}

class LotAffectionPresenter {

  final _df = new DateFormat('dd/MM/yyyy');
  final LotAffectationContract _view;
  late final List<Bete> beliers;
  late final List<Bete> brebis;

  LotModel  _currentLot;
  view _currentViewIndex= view.Lot;

  view get currentViewIndex => _currentViewIndex;

  LotAffectionPresenter(this._view,  this._currentLot) {
    beliers = this._currentLot.beliers;
    brebis = this._currentLot.brebis;
  }
  final LotService _service = LotService();

  Future<void> deleteAffectation(Affectation event) async {
    String message = await this._service.deleteAffectation(event);
    this._view.showMessage(message);
  }

  Future<void> addBete() async {
    Bete ? selectedBete = await this._view.goNextPage(SearchPage(GismoPage.lot));
    if (selectedBete == null)
      return null;
    String ? dateEntree = await this._view.showDateDialog(
        S.current.dateEntry,
        "Saisir une date d'entrée si différente de la date de début de lot",
        S.current.dateEntry);
    String? message;
    if (dateEntree != null) {
      message = await this._service.addBete(this._currentLot, selectedBete!, dateEntree);
    }
    if (message != null) this._view.showMessage(message);
    this._view.currentLot = this._currentLot;
  }

  Future addMultipleBete() async {
    List<Bete>? betes = await this._view.goNextPage(SelectMultiplePage( GismoPage.sanitaire, []));
  }

  Future<void> edit(Affectation affectation) async {
    this._view.goNextPage(AffectationPage(affectation));
  }

  Future<void> removeBete(Affectation affect) async {
    String ? dateSortie = await this._view.showDateDialog(
        S.current.dateDeparture,
        "Saisir une date de sortie si différente de la date de fin de lot",
        S.current.dateDeparture);
    String? message;
    if (dateSortie != null ) {
      message = await this._service.removeFromLot(affect, dateSortie);
    }
    if (message != null)
      this._view.showMessage(message);
    this._view.currentLot = this._currentLot;
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

  void changePage(view index) {
    if (this._view.currentLot.idb == null ) {
      this._view.showMessage(S.current.batch_warning);
      return;
    }
      _currentViewIndex = index;
      switch (_currentViewIndex) {
        case view.Lot:
          this._view.currentView = View.fiche;
          break;
        case view.male:
          this._view.currentView = View.ram;
          break;
        case view.femelle:
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