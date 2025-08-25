import 'dart:developer' as debug;

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
    this._view.showSaving();
    String message = await this._service.deleteAffectation(event);
    if (_currentViewIndex == view.male)
      await this._reloadPresent(Sex.male);
    if (_currentViewIndex == view.femelle)
      await this._reloadPresent(Sex.femelle);
    this._view.hideSaving();
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
    String? message;
    message = await this._service.addBete(this._currentLot, selectedBete);
    await this._reloadPresent(search.searchSex!);
    if (message != null) this._view.showMessage(message);
    this._view.currentLot = this._currentLot;
  }

  Future<String?> addMultipleBete() async {
    Sex sex = (_currentViewIndex == view.male) ? Sex.male: Sex.femelle;
    String ?  message = await this._addMultipleBete(sex);
    return message;
  }

  Future<String?> _addMultipleBete(Sex sex) async {
    List<Bete> ? selectedBetes = null;
    List<Affectation> toAdd = [];
    List<Affectation> toRemove = [];
    selectedBetes = await this._buildNewListBetes(sex);
    this._view.showSaving();
    if (selectedBetes == null) {
      this._view.hideSaving();
      return null;
    }
    toAdd = this._buildToAdd(sex, selectedBetes!);
    toRemove = this._buildToRemove(sex, selectedBetes);
    String ? message = await this._service.updateAffectationInLot(
        toAdd, toRemove);
    await this._reloadPresent(sex);

    this._view.hideSaving();
    return message;
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

  Future<void> _reloadPresent(Sex sex) async {
    if (sex == Sex.male)
      _presentBeliers = await this._service.getBeliersForLot(this._currentLot.idb!);
    else
      _presentBrebis = await this._service.getBrebisForLot(this._currentLot.idb!);
  }

  Future<void> edit(Affectation affectation) async {
    this._view.showSaving();
    Affectation ? affect = await this._view.goNextPage(AffectationPage(affectation));
    if (affect != null)
      debug.log("$affect", name: "LotAffectionPresenter:edit");
    this._view.hideSaving();
  }

  Future<void> save(String campagne, String codeLot, String dateDebut, String dateFin) async {
    if (dateDebut.isNotEmpty)
      this._currentLot.dateDebutLutte = DateFormat.yMd().parse(dateDebut);
    if (dateFin.isNotEmpty)
      this._currentLot.dateFinLutte = DateFormat.yMd().parse(dateFin);
    this._currentLot.campagne = campagne;
    this._currentLot.codeLotLutte = codeLot;
    try {
      _currentLot = (await this._service.saveLot(this._currentLot))!;
    } on DateDebutException {
      this._view.showMessage(S.current.batch_no_date_debut, true);
    } on DateFinException {
      this._view.showMessage(S.current.batch_no_date_fin, true);
    } on CodeLotException {
      this._view.showMessage(S.current.batch_no_code, true);
    }

    this._view.currentLot = _currentLot;
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