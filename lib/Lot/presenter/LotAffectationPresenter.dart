import 'package:flutter_gismo/Gismo.dart';
import 'package:flutter_gismo/Lot/ui/AffectationPage.dart';
import 'package:flutter_gismo/Lot/ui/LotAffectationViewPage.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/model/AffectationLot.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LotModel.dart';
import 'package:flutter_gismo/search/ui/SearchPage.dart';
import 'package:flutter_gismo/search/ui/SelectMultiplePage.dart';
import 'package:flutter_gismo/services/BeteService.dart';
import 'package:flutter_gismo/services/LotService.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

enum view {Lot, male, femelle}

class LotAffectionPresenter {

  final _df = new DateFormat('dd/MM/yyyy');
  final LotAffectationContract _view;
  List<Affectation?> ? _presentBeliers;
  List<Affectation?> ? _presentBrebis;

  List<Affectation?>? get presentBeliers => _presentBeliers;
  List<Affectation?>? get presentBrebis => _presentBrebis;

  LotModel  _currentLot;
  view _currentViewIndex= view.Lot;

  view get currentViewIndex => _currentViewIndex;

  LotAffectionPresenter(this._view,  this._currentLot)  {
   }
  final LotService _service = LotService();
  final BeteService _beteService = BeteService();

  Future<void> deleteAffectation(Affectation event) async {
    String message = await this._service.deleteAffectation(event);
    this._view.showMessage(message);
  }

  Future<void> addBete() async {
    SearchPage search = SearchPage(GismoPage.lot);
    if (currentViewIndex == view.male)
      search.searchSex = Sex.male;
    if (currentViewIndex == view.femelle)
      search.searchSex = Sex.femelle;
    Bete ? selectedBete = await this._view.goNextPage(search);
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
    List<Bete> ? selectedBetes = null;
    List<Affectation> toAdd = [];
    List<Affectation> toRemove = [];
    switch (_currentViewIndex) {
      case view.male:
        selectedBetes = await this._buildNewListBetes(Sex.male);
        toAdd = this._buildToAdd(Sex.male, selectedBetes!);
        toRemove = this._buildToRemove(Sex.male, selectedBetes) ;
        break;
      case view.femelle:
        selectedBetes = await this._buildNewListBetes(Sex.femelle);
        if (selectedBetes != null) {
          toAdd = this._buildToAdd(Sex.femelle, selectedBetes);
          toRemove = this._buildToRemove(Sex.femelle, selectedBetes);
        }
        break;
      default:
        break;
    }
    String ?  message = await this._service.updateAffectationInLot(toAdd!, toRemove!);
  }

  List<Affectation> _buildToAdd(Sex sex, List<Bete> selectedBetes) {
    List<Affectation> toAdd = [];
    if (_getPresent(sex) != null) {
      for (Bete bete in selectedBetes) {
        Affectation ? foundAffect =  _getPresent(sex)!.firstWhereOrNull((affect) => bete.idBd == affect!.brebisId);
        if (foundAffect == null) {
          toAdd.add(Affectation.create(null, bete.idBd!, _currentLot.idb!));
        }
      }
    }
    return toAdd;
  }

  List<Affectation> _buildToRemove(Sex sex, List<Bete> selectedBetes) {
    List<Affectation> toRemove = [];
    if (_getPresent(sex) != null) {
      for( Affectation ? affect in _getPresent(sex)!) {
        Bete? foundBete  = selectedBetes.firstWhereOrNull((bete) => bete.idBd == affect!.brebisId);
        if (foundBete == null)
          toRemove.add(affect!);
      }
    }
    return toRemove;
  }

  Future<List<Bete>?> _buildNewListBetes(Sex sex) async {
    SelectMultiplePage? page = null;
    List<Bete ?> betes = await this._getBete(sex);
    List<Bete> selectedBetes = [];
    if (_getPresent(sex) != null)
      for (Affectation ? affect in _getPresent(sex)!) {
        Bete ? selectedBete = betes.firstWhereOrNull((bete) => bete!.idBd == affect!.brebisId);
        if (selectedBete != null)
          selectedBetes.add(selectedBete);
      }
    page =  SelectMultiplePage(GismoPage.lot, selectedBetes);
    page.searchSex = sex;
    List<Bete>? newListBetes = null;
    newListBetes = await this._view.goNextPage(page);
    return newListBetes;
  }

  Future<List<Bete>> _getBete(Sex sex) async {
    if (sex == Sex.male)
      return await this._beteService.getBeliers();
    else
      return await this._beteService.getBrebis();
  }

  List<Affectation?> ? _getPresent(Sex sex) {
    if (sex == Sex.male)
      return _presentBeliers;
    else
      return _presentBrebis;
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

  Future<void> changePage(view index) async {
    if (this._view.currentLot.idb == null ) {
      this._view.showMessage(S.current.batch_warning);
      return;
    }
      _currentViewIndex = index;
      switch (_currentViewIndex) {
        case view.Lot:
          this._view.currentView = view.Lot;
          break;
        case view.male:
          if (this._presentBeliers == null)
            this._presentBeliers = await this._service.getBeliersForLot(this._currentLot.idb!);
          this._view.currentView = view.male;
          break;
        case view.femelle:
          if (this._presentBrebis == null)
            this._presentBrebis = await this._service.getBrebisForLot(this._currentLot.idb!);
          this._view.currentView = view.femelle;
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