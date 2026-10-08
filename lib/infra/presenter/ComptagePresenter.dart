import 'dart:developer' as debug;
import 'package:collection/collection.dart';

import 'package:flutter_gismo/infra/ui/Comptage.dart';
import 'package:flutter_gismo/model/AffectationLot.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/BoucleModel.dart';
import 'package:flutter_gismo/model/LotModel.dart';
import 'package:flutter_gismo/model/StatusBluetooth.dart';
import 'package:flutter_gismo/services/BeteService.dart';
import 'package:flutter_gismo/services/BluetoothService.dart';
import 'package:flutter_gismo/services/LotService.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ComptagePresenter {
  ComptageContract _view;

  ComptagePresenter(this._view);

  LotService  _lotService = LotService();
  BeteService _beteService = BeteService();
  BluetoothService _blService = BluetoothService();

  List<Bete> _countedBetes = [];
  List<Bete> _allBetes = [];

  List<Bete> get countedBetes => _countedBetes;

  void init() {
    this._populateBetes();
  }
  Future<void> startService() async{
    try {
      debug.log("Start service ", name: "SearchPresenter::startService");
      StatusBlueTooth status= await this._blService.startReadBluetooth();
      this._view.bluetoothState = status;
      if (status.connectionStatus == 'CONNECTED') {
        await this._blService.readBluetooth();
        this._blService.handleData(this.handleBlueTooth);
      }
    } on Exception catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      debug.log(e.toString());
    }
  }

   void _populateBetes()  {
     _beteService.getBetes().then((lstBetes) {
       _allBetes = lstBetes;
       this._view.hideSaving();
     });
  }

  Future<List<LotModel>> getLots()  {
    return _lotService.getLots();
  }

  Future<void> getBetes() async {
      if (_view.currentLotId != null) {
        _allBetes.clear();
        List<Affectation> beliers = await _lotService.getBeliersForLot(this._view.currentLotId!);
        beliers.forEach((belier) {
          _allBetes.add(Bete.fromAffectation(belier));
        });
        List<Affectation> brebis = await _lotService.getBrebisForLot(this._view.currentLotId!);
        brebis.forEach((brebis) {
          _allBetes.add(Bete.fromAffectation(brebis));
        });
        _allBetes.sort((bete1 , bete2) => bete1.numBoucle.compareTo(bete2.numBoucle));
      }
      else
        _allBetes = await _beteService.getBetes();
      _countedBetes .clear();
      this._view.hideSaving();
  }

  void countBete(Bete bete) {
    _allBetes.remove(bete);
    _countedBetes.add(bete);
    _countedBetes.sort( (b1, b2) => b1.numBoucle.compareTo(b2.numBoucle) );
    this._view.hideSaving();
  }

  void uncountBete(Bete bete) {
    _countedBetes.remove(bete);
    _allBetes.add(bete);
    _allBetes.sort( (b1, b2) => b1.numBoucle.compareTo(b2.numBoucle) );
    this._view.hideSaving();
  }

  void handleBlueTooth(StatusBlueTooth event) {
    if ( event.connectionStatus != null)
      debug.log("Status " + event.connectionStatus!, name: "SearchPresenter::handleBlueTooth");
    if (this._view.bluetoothState.dataStatus != event.dataStatus
        || this._view.bluetoothState.connectionStatus != event.dataStatus ) {
      if(event.connectionStatus == 'NONE')
        return;
      if (event.dataStatus == 'AVAILABLE') {
        BoucleModel boucle= BoucleModel(event.data!);
        Bete ? bete = this._allBetes.firstWhereOrNull((Bete bete) => bete.numBoucle == boucle.ordre && bete.numMarquage == boucle.marquage);
        if (bete != null)
          this.countBete(bete);
      }
      this._view.bluetoothState = event;
    }
  }

  List<Bete> get allBetes => _allBetes;
}