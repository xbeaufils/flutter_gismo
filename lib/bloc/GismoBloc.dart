import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_gismo/bloc/GismoRepository.dart';
import 'package:flutter_gismo/bloc/WebDataProvider.dart';
import 'package:flutter_gismo/model/AffectationLot.dart';
import 'package:flutter_gismo/model/Event.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/model/LotModel.dart';
import 'package:flutter_gismo/model/NECModel.dart';
import 'package:flutter_gismo/model/TraitementModel.dart';
import 'package:flutter_gismo/model/User.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/BeteModel.dart';

import 'dart:developer' as debug;

class GismoBloc {

  //AuthService service = new AuthService();
  User _currentUser;
  GismoRepository _repository;

  GismoBloc();

  Future<Null> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String cheptel = prefs.getString('cheptel');
    bool subscribe = prefs.getBool('subscribe');
    String email =  prefs.getString('email');
    String token =  prefs.getString('token');
    debug.log('email : $email - token: $token - cheptel: $cheptel', name: "GismoBloc::init");
    if (cheptel != null) {
      if (token != null ) {
        _currentUser = new User(cheptel);
        _currentUser.subscribe = subscribe;
        _currentUser.setToken(token);
        _currentUser.setEmail(email);
        _repository = new GismoRepository(RepositoryType.web);
        await (_repository.dataProvider as WebDataProvider).auth(_currentUser);
      }
      else {
        _currentUser = new User(cheptel);
        _repository = new GismoRepository(RepositoryType.local);
      }
    }

  }

  bool isLogged() {
     if (_currentUser == null)
      return false;
     debug.log("Cheptel is " + _currentUser.cheptel, name:"GismoBloc::isLogged");
     return (_currentUser.cheptel != null);
  }

   final dio = new Dio();

  User get user => _currentUser;
  void setUser(User user) {
    this._currentUser = user;
  }

  Future<User> auth(User user) async {
    WebDataProvider aProvider = new WebDataProvider();
    this._currentUser = user;
    return aProvider.auth(user);
   }

  Future<String> saveLambing(LambingModel lambing ) async {
    return this._repository.dataProvider.saveLambing(lambing);

  }
  Future<List<LambingModel>> getLambs(int idBete) {
    return this._repository.dataProvider.getLambs(idBete);
  }

  Future<LambingModel> searchLambing(int idBd) {
    return this._repository.dataProvider.searchLambing(idBd);
  }
  /*
  Future<String> saveLamb(List<LambModel> lambs ) async {
    return this._repository.dataProvider.saveLamb(lambs);
  }
  */
  Future<String> saveSortie(String date, String motif, List<Bete> betes ) async {
    debug.log("Motif " + motif + " date " + date + " nb Betes " + betes.length.toString(), name: "GismoBloc::saveSortie");
    this._repository.dataProvider.saveSortie(date, motif, betes);
    return "Enregistrement effectué";
  }

  Future<String> saveEntree(String date, String motif, List<Bete> betes ) async {
    debug.log("Motif " + motif + " date " + date + " nb Betes " + betes.length.toString(), name: "GismoBloc::saveEntree");
    this._repository.dataProvider.saveEntree(this._currentUser.cheptel, date, motif, betes);
    return "OK";
  }

  Future<String> saveTraitement(TraitementModel traitement) {
    return this._repository.dataProvider.saveTraitement(traitement);
  }

  Future<List<TraitementModel>> getTraitements(Bete bete) {
    return this._repository.dataProvider.getTraitements(bete);
  }

  Future<TraitementModel> searchTraitement(int idBd) {
    return this._repository.dataProvider.searchTraitement(idBd);
  }

  Future<String> saveBete(Bete bete) {
    bete.cheptel = _currentUser.cheptel;
    return this._repository.dataProvider.saveBete(bete);
  }

  Future<List<Event>> getEvents(Bete bete) async {
    List<Event> lstEvents = new List();
    List<LambingModel> lstLambs = await this._repository.dataProvider.getLambs(bete.idBd);
    List<TraitementModel> lstTraitement = await this._repository.dataProvider.getTraitements(bete);
    List<NoteModel> lstNotes = await this._repository.dataProvider.getNec(bete);
    lstLambs.forEach((lambing) => { lstEvents.add( new Event.name(lambing.idBd, EventType.agnelage, lambing.dateAgnelage, lambing.lambs.length.toString()))});
    lstTraitement.forEach( (traitement) => {lstEvents.add(new Event.name(traitement.idBd, EventType.traitement, traitement.debut, traitement.medicament))});
    lstNotes.forEach( (note) => {lstEvents.add(new Event.name(note.idBd, EventType.NEC, note.date, note.note.toString()))});
    lstEvents.sort((a, b) =>  _compareDate(a, b));
    return lstEvents;
  }

  int _compareDate(Event a, Event b) {
    DateFormat format = DateFormat("dd/MM/yyyy");
    return format.parse(b.date).compareTo( format.parse(a.date));
  }

  Future<String> boucler (LambModel lamb, Bete bete ) {
    bete.cheptel = this._currentUser.cheptel;
    this._repository.dataProvider.boucler(lamb, bete);
  }

  Future<String>  mort(LambModel lamb, String motif, String date) async {
    try {
      await this._repository.dataProvider.mort(lamb, motif, date);
      return "Enregistrement effectué";
    }
    catch (e) {
      print (e);
      return "Exception";
    }
  }

  Future<List<Bete>> getBetes() {
    return this._repository.dataProvider.getBetes(_currentUser.cheptel);
  }

  Future<String> saveWebConfig(String cheptel, String email, String token) async {
    User anUser = new User(cheptel);
    anUser.setEmail(email);
    anUser.setToken(token);
    anUser.subscribe = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("subscribe", true);
    prefs.setString("email", anUser.email);
    prefs.setString("token", anUser.token);
    prefs.setString("cheptel", anUser.cheptel);
    this._currentUser = anUser;
    _repository = new GismoRepository(RepositoryType.web);
    return "Enregistrement effectué";
  }
  Future<bool> saveLocalConfig(String cheptel) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _repository = new GismoRepository(RepositoryType.local);
    this._currentUser = new User(cheptel);
    prefs.setBool("subscribe", false);
    prefs.remove("email");
    prefs.remove("token");
    return prefs.setString("cheptel", cheptel);
  }

  Future<String> saveNec(Bete bete, NEC nec, String date) async{
    try {
      //await Future.delayed(Duration(seconds: 3), () => print('Large Latte'));
      NoteModel note = new NoteModel();
      note.note = nec.note;
      note.date = date;
      note.idBete = bete.idBd;
      await this._repository.dataProvider.saveNec(note);
      return "Enregistrement effectué";
    }
    catch(e) {
      return "Une erreur est survenue";
    }
  }

  Future<LotModel> saveLot(LotModel lot) async {
    lot.cheptel = this._currentUser.cheptel;
    LotModel newLot  = await this._repository.dataProvider.saveLot(lot);
    return newLot;
  }

  Future<List<LotModel>> getLots() {
    return this._repository.dataProvider.getLots(_currentUser.cheptel);
  }

  Future<List<Affectation>> getBrebisForLot(int idLot) {
    return this._repository.dataProvider.getBrebisForLot(idLot);
  }

  Future<List<Affectation>> getBeliersForLot(int idLot) {
    return this._repository.dataProvider.getBeliersForLot(idLot);
  }

  Future<String> addBete(LotModel lot, Bete bete, String dateEntree) {
    return this._repository.dataProvider.addBete(lot, bete, dateEntree);
  }

  Future<String> removeFromLot(Affectation bete, String dateSortie) {

  }

  Future<List<Bete>> getBrebis() {
    return this._repository.dataProvider.getBrebis();
  }

  Future<List<Bete>> getBeliers() {
    return this._repository.dataProvider.getBeliers();
  }

}

