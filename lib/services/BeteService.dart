import 'package:flutter/material.dart';
import 'package:flutter_gismo/Exception/EventException.dart';
import 'package:flutter_gismo/bloc/NavigationService.dart';
import 'package:flutter_gismo/repository/BeteRepository.dart';
import 'package:flutter_gismo/bloc/ConfigProvider.dart';
import 'package:flutter_gismo/repository/EchoRepository.dart';
import 'package:flutter_gismo/repository/LambRepository.dart';
import 'package:flutter_gismo/repository/LotRepository.dart';
import 'package:flutter_gismo/repository/MemoRepository.dart';
import 'package:flutter_gismo/repository/NecRepository.dart';
import 'package:flutter_gismo/repository/PeseeRepository.dart';
import 'package:flutter_gismo/repository/SaillieRepository.dart';
import 'package:flutter_gismo/repository/TraitementRepository.dart';
import 'package:flutter_gismo/model/AffectationLot.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/EchographieModel.dart';
import 'package:flutter_gismo/model/Event.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as debug;
import 'package:sentry/sentry.dart';

import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/model/MemoModel.dart';
import 'package:flutter_gismo/model/NECModel.dart';
import 'package:flutter_gismo/model/PeseeModel.dart';
import 'package:flutter_gismo/model/SaillieModel.dart';
import 'package:flutter_gismo/model/TraitementModel.dart';

class BeteService {

  final ConfigProvider _provider = Provider.of<ConfigProvider>(NavigationService.navigatorKey.currentContext!, listen: false);
  late BeteRepository _repository;
  late PeseeRepository _peseeRepository;
  late Traitementrepository _traitementrepository;
  late NecRepository _necRepository;
  late LambRepository _lambRepository;
  late SaillieRepository _saillieRepository;
  late Echorepository _echoRepository;
  late Memorepository _memorepository;
  late LotRepository _lotRepository;

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  BeteService() {
    if (_provider.isSubscribing() ) {
      _repository = WebBeteRepository(_provider.getToken());
      _traitementrepository = WebTraitementRepository(_provider.getToken());
      _peseeRepository = WebPeseeRepository(_provider.getToken());
      _necRepository = WebNecRepository(_provider.getToken());
      _lambRepository = WebLambRepository(_provider.getToken());
      _saillieRepository = WebSaillieRepository(_provider.getToken());
      _echoRepository = WebEchoRepository(_provider.getToken());
      _memorepository = WebMemoRepository(_provider.getToken());
      _lotRepository = WebLotRepository(_provider.getToken());
    }
    else {
      _repository = LocalBeteRepository();
      _traitementrepository = LocalTraitementRepository();
      _peseeRepository = LocalPeseeRepository();
      _necRepository = LocalNecRepository();
      _lambRepository = LocalLambRepository();
      _saillieRepository = LocalSaillieRepository();
      _echoRepository = LocalEchoRepository();
      _memorepository = LocalMemoRepository();
    }
  }

  Future<List<Bete>> getBetes() {
    return this._repository.getBetes(_provider.getCheptel()!);
  }

  Future<List<Bete>> getBeliers() {
    return this._repository.getBeliers();
  }

  Future<List<Bete>> getBrebis() {
    return this._repository.getBrebis();
  }

  Future<Bete?> getPere(Bete bete) {
    return this._repository.getPere(bete);
  }

  Future<Bete?> getMere(Bete bete) {
    return this._repository.getMere(bete);
  }

  Future<String> deleteEvent(Event event) async {
    String message = "";
    switch (event.type) {
      case EventType.pesee:
        message = await this._peseeRepository.deletePesee(event.idBd);
        break;
      case EventType.traitement:
        message = await this._traitementrepository.deleteTraitement(event.idBd);
        break;
      case EventType.NEC:
        message = await this._necRepository.delete(event.idBd);
        break;
      case EventType.saillie:
        message = await this._saillieRepository.deleteSaillie(event.idBd);
        break;
    }
    return message;
  }

  Future<List<Event>> getEvents(Bete bete) async {
    try {
      List<Event> lstEvents = [];
      debug.log("get lambs", name: "GismoBloc::getEvents");
      List<LambingModel> lstLambs = await this._lambRepository.getLambs(bete.idBd!);
      debug.log("get traitements", name: "GismoBloc::getEvents");
      List<TraitementModel> lstTraitement = await this._traitementrepository.getTraitements(bete);
      debug.log("get lots", name: "GismoBloc::getEvents");
      List<Affectation> lstAffect = await this._lotRepository.getAffectationForBete(bete.idBd!);
      debug.log("get nec", name: "GismoBloc::getEvents");
      List<NoteModel> lstNotes = await this._necRepository.get(bete);
      List<Pesee> lstPoids  = await this._peseeRepository.getPesee(bete);
      List<EchographieModel> lstEcho = await this._echoRepository.getEcho(bete);
      List<SaillieModel> lstSaillie = await this._saillieRepository.getSaillies(bete);
      List<MemoModel> lstMemos = await this._memorepository.getMemos(bete);
      lstLambs.forEach((lambing)  { lstEvents.add( new Event(lambing.idBd!, EventType.agnelage, lambing.dateAgnelage!, lambing.lambs.length.toString()));});
      lstTraitement.forEach( (traitement)  {lstEvents.add(new Event(traitement.idBd!, EventType.traitement, traitement.debut, traitement.medicament));});
      lstNotes.forEach( (note)  {lstEvents.add(new Event(note.idBd!, EventType.NEC, note.date, note.note.toString()));});
      lstPoids.forEach( (poids)  {lstEvents.add(new Event(poids.id!, EventType.pesee, poids.datePesee, poids.poids.toString()));});
      lstAffect.forEach( (affect)  {lstEvents.addAll ( _makeEventforAffectation(affect) );});
      lstEcho.forEach((echo) {lstEvents.add(new Event(echo.idBd!, EventType.echo, echo.dateEcho, echo.nombre.toString())); });
      lstSaillie.forEach((saillie) {
        String numBoucleConjoint;
        if (bete.sex == Sex.male)
          numBoucleConjoint = saillie.numBoucleMere!;
        else
          numBoucleConjoint = saillie.numBouclePere!;
        lstEvents.add(new Event(saillie.idBd!, EventType.saillie, saillie.dateSaillie!, numBoucleConjoint));

      });
      lstMemos.forEach((note) {lstEvents.add(new Event(note.id!, EventType.memo, note.debut!, note.note!)); });
      lstEvents.sort((a, b) =>  _compareDate(a, b));
      return lstEvents;
    }
    catch(e, stackTrace) {
      Sentry.captureException(e,stackTrace: stackTrace);
    }
    throw EventException("");
  }

  List<Event> _makeEventforAffectation(Affectation affect) {
    List<Event> lstEvents = [];
    lstEvents.add(new Event(affect.idAffectation!, EventType.entreeLot, affect.dateEntree!, affect.lotName!));
    lstEvents.add(new Event(affect.idAffectation!, EventType.sortieLot, affect.dateSortie!, affect.lotName!));
    return lstEvents;
  }

  int _compareDate(Event a, Event b) {
    return b.date.compareTo( a.date);
  }

  Future<LambingModel?> searchLambing(int idBd) {
    return this._lambRepository.searchLambing(idBd);
  }

  Future<TraitementModel?> searchTraitement(int idBd) {
    return this._traitementrepository.searchTraitement(idBd);
  }

  Future<EchographieModel?> searchEcho(int idBd) {
    return this._echoRepository.searchEcho(idBd);
  }

  Future<MemoModel?> searchMemo(int idBd) {
    return this._memorepository.searchMemo(idBd);
  }



}