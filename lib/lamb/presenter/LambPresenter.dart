import 'dart:async';
import 'dart:developer' as debug;

import 'package:flutter_gismo/core/repository/AbstractRepository.dart';
import 'package:flutter_gismo/individu/ui/PeseePage.dart';
import 'package:flutter_gismo/lamb/ui/Bouclage.dart';
import 'package:flutter_gismo/lamb/ui/LambPage.dart';
import 'package:flutter_gismo/lamb/ui/LambTimeLine.dart';
import 'package:flutter_gismo/lamb/ui/Mort.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/model/StatusBluetooth.dart';
import 'package:flutter_gismo/services/BluetoothService.dart';
import 'package:flutter_gismo/services/LambingService.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/traitement/ui/Sanitaire.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class LambTimeLinePresenter {
  final LambTimelineContract _view;
  final LambingService service = LambingService();

  LambTimeLinePresenter(this._view);

  void view(LambModel lamb) {
    this._view.goNextPage(LambPage.edit(lamb));
  }

  void boucle(LambModel lamb) async {
    Bete ? bete = await this._view.goNextPage( BouclagePage(lamb));
    if (bete == null)
      return;
    try {
      this.service.boucler(lamb, bete);
      if (bete.idBd != null)
        lamb.idDevenir = bete.idBd;
      lamb.numBoucle = bete.numBoucle;
      lamb.numMarquage = bete.numMarquage;
    } on GismoException catch (e) {
      this._view.showMessage(e.message, true);
    }
  }

  void mort(LambModel lamb) {
    this._view.goNextPage( MortPage(lamb));
  }

  void peser(LambModel lamb) async {
    await this._view.goNextPage(  PeseePage( null, lamb ));
    this._view.hideSaving();
  }

  void traitement(LambModel lamb) async {
    await this._view.goNextPage( LambSanitairePage(lamb));
    this._view.hideSaving();
  }

}

class LambPresenter {
  final LambContract _view;
  final LambingService service = LambingService();
  LambPresenter(this._view);

  void addLamb(String marquage, Sex sex, MethodeAllaitement allaitement, Sante sante ) {
    this._view.backWithObject(LambModel(marquage, sex, allaitement, sante));
  }

  void saveLamb(LambModel lamb, String marquage, Sex sex, MethodeAllaitement allaitement, Sante sante ) {
    try {
      lamb.marquageProvisoire = marquage;
      lamb.sex = sex;
      lamb.allaitement = allaitement;
      lamb.sante = sante;
      this.service.saveLamb(lamb);
      this._view.backWithObject(lamb);
    } on GismoException catch(e) {
      this._view.showMessage(e.message, true);
    }
  }

}

class BouclagePresenter {

  final BouclageContract _view;
  final _blService = BluetoothService();
  BouclagePresenter(this._view);

  void createBete(LambModel lamb, String numBoucle, String numMarquage) async {
    lamb.numMarquage = numMarquage;
    lamb.numBoucle = numBoucle;
    Bete bete = new Bete(null, numBoucle, numMarquage, null, null, null, lamb.sex, 'NAISSANCE');
    this._view.returnBete(bete);
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
        String _foundBoucle = event.data!;
        if (_foundBoucle.length > 15)
          _foundBoucle = _foundBoucle.substring(_foundBoucle.length - 15);
        String numBoucle = _foundBoucle.substring(_foundBoucle.length - 5);
        String numMarquage = _foundBoucle.substring(0, _foundBoucle.length - 5);

        this._view.updateBoucle(numBoucle, numMarquage);
      }
      this._view.bluetoothState = event;
    }
  }

  void stopReadBluetooth() {
    _blService.stopReadBluetooth();
  }


}

class DeathPresenter {
  final LambingService _service = LambingService();
  final MortContract _view;

  DeathPresenter(this._view);

  Future<String> saveDeath(LambModel lamb, String dateMort, String? motif) async {
    try {
      _view.showSaving();
      return this._save(lamb, dateMort, motif);
      _view.hideSaving();

    } on GismoException catch(e) {
      this._view.showMessage(e.message, true);
    }  on MissingDeathDateException {
      this._view.showMessage(S.current.no_death_date, true);
    } on MissingMotifException {
      this._view.showMessage(S.current.death_cause_mandatory, true);
    }
    throw Exception();
  }

  Future<String> _save(LambModel lamb, String dateMort, String? motif) async {
    if (dateMort.isEmpty) {
      throw MissingDeathDateException();
    }
    if (motif == null) {
      throw MissingMotifException();
    }
    if (motif.isEmpty) {
      throw MissingMotifException();
    }
    String message  = await this._service.mort(lamb, motif, dateMort);
    return message;
  }

}

class MissingDeathDateException implements Exception {}
class MissingMotifException implements Exception {}