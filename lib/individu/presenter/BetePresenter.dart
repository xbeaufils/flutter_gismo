import 'dart:developer' as debug;

import 'package:flutter/foundation.dart';
import 'package:flutter_gismo/core/repository/AbstractRepository.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/individu/ui/Bete.dart';
import 'package:flutter_gismo/individu/ui/HybridationPage.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/BoucleModel.dart';
import 'package:flutter_gismo/model/StatusBluetooth.dart';
import 'package:flutter_gismo/services/BeteService.dart';
import 'package:flutter_gismo/services/BluetoothService.dart';
import 'package:intl/intl.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class BetePresenter {

  final BeteContract _view;
  final BeteService _service = BeteService();
  final BluetoothService _blService = BluetoothService();
  BetePresenter(this._view);

  Future<void> add (String ? numBoucle, String ? numMarquage, Sex ? sex, String ? nom, String ? obs, String dateEntree, String ? motif) async {
    if (numBoucle == null) {
      this._view.showMessage(S.current.identity_number_warn, true);
      return;
    }
    if (numBoucle.isEmpty){
      this._view.showMessage(S.current.identity_number_warn, true);
      return;
    }
    if (numMarquage == null){
      this._view.showMessage(S.current.flock_number_warn, true);
      return;
    }
    if (numMarquage.isEmpty){
      this._view.showMessage(S.current.flock_number_warn, true);
      return;
    }
    if (sex == null){
      this._view.showMessage(S.current.sex_warn, true);
      return;
    }
    Bete newBete =  Bete( null, numBoucle, numMarquage, nom, obs, DateFormat.yMd().parse(dateEntree), sex, motif);
    newBete.genetique = this._view.bete.genetique;
    bool existant = await this._service.check(newBete);
    if (existant)
      this._view.showMessage(S.current.identity_number_error, true);
    else {
      this._view.bete = newBete;
      this._view.backWithBete();
    }
  }

  Future<String?> save(String ? numBoucle, String ? numMarquage, Sex ? sex, String ? nom, String ? obs, String dateEntree, String ? motif) async {
    Bete newBete =  Bete(this._view.bete==null ? null: this._view.bete?.idBd, numBoucle, numMarquage, nom, obs, DateFormat.yMd().parse(dateEntree), sex, motif);
    newBete.genetique = this._view.bete!.genetique;
    try {
      String message = await _service.save(newBete);
      if (this._view.bete != null) {
        this._view.bete!.numBoucle = numBoucle!;
        this._view.bete!.numMarquage = numMarquage!;
        this._view.bete!.sex = sex!;
        this._view.bete!.observations = obs;
        this._view.backWithBete();
      }
      return message;
    } on GismoException catch(e) {
      this._view.showMessage(e.message, true);
    } on MissingNumBoucle {
      this._view.showMessage(S.current.identity_number_warn, true);
    } on MissingNumMarquage {
      this._view.showMessage(S.current.flock_number_warn, true);
    } on MissingSex {
      this._view.showMessage(S.current.sex_warn, true);
    } on ExistingBete {
      this._view.showMessage(S.current.identity_number_error, true);
    }
    return null;
  }

  Future<void> startReadBluetooth() async {
    try {
      StatusBlueTooth status =  await _blService.startReadBluetooth();
      if (status.connectionStatus == 'CONNECTED') {
        await this._blService.readBluetooth();
        this._blService.handleData(this.handleBlueTooth);
      }
    } on Exception catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      debug.log(e.toString());
    }

  }

  void handleBlueTooth(StatusBlueTooth event) {
    if ( event.connectionStatus != null)
      debug.log("Status " + event.connectionStatus!, name: "BetePresenter::handleBlueTooth");
    if (this._view.bluetoothState.dataStatus != event.dataStatus
        || this._view.bluetoothState.connectionStatus != event.dataStatus ) {
      if(event.connectionStatus == 'NONE')
        return;
      if (event.dataStatus == 'AVAILABLE') {
        BoucleModel _foundBoucle = BoucleModel(event.data!);
        this._view.updateBoucle(_foundBoucle);
      }
      this._view.bluetoothState = event;
    }
  }

  void stopReadBluetooth() {
    if ((defaultTargetPlatform == TargetPlatform.android)) {
      _blService.stopReadBluetooth();
    }
  }

  void selectRace() async {
    Hybridation ? hybridation = null;
    if (this._view.bete != null)
      hybridation = this._view.bete!.genetique;
    hybridation = await  this._view.goNextPage(HybridationPage(hybridation));
    if (hybridation != null) {
      debug.log(hybridation.toJson().toString(), name: "BetePresenter::selectRace");
      this._view.bete!.genetique = hybridation;
      this._view.hideSaving();
    }
  }

  void delete(Race race) {
    this._service.delete(this._view.bete!.genetique!.races, race);
  }

  Future<List<Race>> getAllRaces() async {
    return await _service.getAllRaces();
  }
}

class MissingNumBoucle implements Exception {}

class MissingNumMarquage implements Exception {}

class MissingSex implements Exception {}

class ExistingBete implements Exception {}

class HybridationPresenter {

  final HybridationContract _view;
  final BeteService _service = BeteService();
  late Hybridation  _hybridation;

  Hybridation get hybridation => _hybridation;

  set hybridation(Hybridation value) {
    _hybridation = value;
  }

  HybridationPresenter(this._view, Hybridation ? aHybridation){
    if (aHybridation == null) {
      this._hybridation = Hybridation();
      this._hybridation.niveau = Generation.PURE;
    }
    else {
      this._hybridation = new Hybridation();
      this._hybridation.niveau = aHybridation.niveau;
      this._hybridation.races = [];
      aHybridation.races.forEach( (race) =>
          this._hybridation.races.add(Race.fromResult(race.toJson()))
      );

      this._hybridation.races.sort( (a, b) => a.ordre.compareTo(b.ordre));
      debug.log(this._hybridation.toJson().toString(), name: "HybridationPresenter::HybridationPresenter");
    }
  }

  Future<List<Race>> getAllRaces() async {
    List<Race> races = await _service.getAllRaces();
    races.sort((a, b) => a.nom.compareTo(b.nom));
    return races;
  }


  void add(Race race) {
    race.ordre = this._hybridation.races.length + 1;
    this._hybridation.races.add(race);
    debug.log(this._hybridation.toJson().toString(), name: "HybridationPresenter::add");
  }

  void up(int index) {
    Race raceUp = this._hybridation.races[index];
    raceUp.ordre = index;
    Race raceDown = this._hybridation.races[index-1];
    raceDown.ordre = index+1;
    this._hybridation.races[index] = raceDown;
    this._hybridation.races[index - 1] = raceUp;
    this._hybridation.races.sort((a, b) => a.ordre.compareTo(b.ordre));
    debug.log(this._hybridation.toJson().toString(), name: "HybridationPresenter::up");
  }

  void down(int index) {
    if (index == 0) {
      Race downRace = this._hybridation.races[0];
      downRace.ordre = 2;
      Race upRace = this._hybridation.races[1];
      upRace.ordre = 1;
      this._hybridation.races[0] = upRace;
      this._hybridation.races[1] = downRace;
      this._hybridation.races.sort((a, b) => a.ordre.compareTo(b.ordre));
    }
    debug.log(this._hybridation.toJson().toString(), name: "HybridationPresenter::down");
  }

  void remove(int index) {
    this._service.remove(this._hybridation.races, index);
    debug.log(this._hybridation.toJson().toString(), name: "HybridationPresenter::remove");
  }

  void save() {
    this._view.backWithObject(_hybridation);
  }
}