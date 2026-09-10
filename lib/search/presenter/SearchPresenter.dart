import 'dart:async';
import 'dart:developer' as debug;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_classic_bluetooth/flutter_classic_bluetooth.dart';
import 'package:flutter_gismo/Gismo.dart';
import 'package:flutter_gismo/individu/ui/EchoPage.dart';
import 'package:flutter_gismo/individu/ui/NECPage.dart';
import 'package:flutter_gismo/individu/ui/PeseePage.dart';
import 'package:flutter_gismo/individu/ui/SailliePage.dart';
import 'package:flutter_gismo/individu/ui/TimeLine.dart';
import 'package:flutter_gismo/lamb/ui/lambing.dart';
import 'package:flutter_gismo/memo/ui/MemoPage.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/BoucleModel.dart';
import 'package:flutter_gismo/model/StatusBluetooth.dart';
import 'package:flutter_gismo/search/ui/SearchPage.dart';
import 'package:flutter_gismo/services/BeteService.dart';
import 'package:flutter_gismo/services/BluetoothService.dart';
import 'package:sentry_flutter/sentry_flutter.dart';


class SearchPresenter {

  final SearchContract _view;
  final TextEditingController _filter = new TextEditingController();

  List<Bete> _filteredBetes = <Bete>[];
  List<Bete> _betes = <Bete>[];
  BeteService _service = BeteService();
  BluetoothGismoService _blService = BluetoothGismoService();

  SearchPresenter(this._view){
    debug.log("Constructor", name: "SearchPresenter::SearchPresenter");
    if (_blService.connectedDevice != null) {
      this._blService.init(onConnectionStateChanged, onConnectionError, onDataReceived);
      this._view.bluetoothState = BtcConnectionState.connected;
    }
  }

  void onConnectionStateChanged(BtcConnectionState state) {
    debug.log("state " + state.name , name: "SearchPresenter::onConnectionStateChanged");
    state = BtcConnectionState.disconnected;
    if (state.name.startsWith("ERR")) {
    }
    this._view.bluetoothState = state;
  }

  void onConnectionError(error) {
    debug.log("error " + error.toString(), name: "SearchPresenter::onConnectionError");
  }

  void onDataReceived(Uint8List data) {
    debug.log("Current Route ${this._view.isCurrent()}", name: "SearchPresenter::onDataReceived");
    if (! this._view.isCurrent())
      return;
    BoucleModel boucle = this._blService.formatData(data);
    debug.log("received ${boucle.marquage}-${boucle.ordre}", name: "SearchPresenter::onDataReceived");
    _filter.text = boucle.ordre;
    this._view.setBoucle(boucle.ordre);
  }


  void filtre(String searchText) {
    _filteredBetes.clear();
    if (searchText.isNotEmpty) {
      for (int i = 0; i < _betes.length; i++) {
        if (_betes[i].numBoucle.toLowerCase().contains(
            searchText.toLowerCase())) {
          _filteredBetes.add(_betes[i]);
        }
      }

    } else {
      _filteredBetes.addAll(_betes);
    }
    this._view.filteredBetes = _filteredBetes;
  }


  void getBetes(Sex ? searchSex) async {
    if (searchSex == null) {
      _betes = await this._service.getBetes();
    }
    else {
      switch (searchSex) {
        case Sex.femelle:
          _betes = await this._service.getBrebis();
          break;
        case Sex.male :
          _betes = await this._service.getBeliers();
          break;
      }
    }
    _filteredBetes.addAll(_betes);
    this._view.filteredBetes = _betes;
  }

  void selectBete(Bete bete) async {
    StatefulWidget ? page;
    switch (this._view.nextPage) {
      case GismoPage.lamb:
        page = LambingPage(bete);
        break;
    /*case GismoPage.sanitaire:
        page = SanitairePage(this._bloc, bete, null);
        break; */
      case GismoPage.individu:
        page = TimeLinePage( bete);
        break;
      case GismoPage.etat_corporel:
        page = NECPage( bete);
        break;
      case GismoPage.pesee:
        page = PeseePage( bete, null);
        break;
      case GismoPage.echo:
        page = EchoPage(bete);
        break;
      case GismoPage.saillie:
        page = SailliePage(bete);
        break;
      case GismoPage.note:
        page = MemoPage(bete);
        break;
      case GismoPage.sortie:
      case GismoPage.lot:
      case GismoPage.sailliePere:
      case GismoPage.sanitaire:
        page = null;
        break;
    }

    if (page  == null) {
      this._view.goPreviousPage(bete);
      //Navigator.of(context).pop(bete);
    }
    else {
      //this._blService.pauseStream();
      String ? message = await this._view.goNextPage(page);
      if (message != null)
        this._view.showMessage(message);
      //this._blService.resumeStream();
    }
  }

  void dispose() {
    this._blService.stopStream();
  }


}