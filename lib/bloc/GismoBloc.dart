import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gismo/bloc/GismoRepository.dart';
import 'package:flutter_gismo/bloc/WebDataProvider.dart';
import 'package:flutter_gismo/model/AffectationLot.dart';
import 'package:flutter_gismo/model/Event.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/model/LotModel.dart';
import 'package:flutter_gismo/model/NECModel.dart';
import 'package:flutter_gismo/model/ParcelleModel.dart';
import 'package:flutter_gismo/model/PeseeModel.dart';
import 'package:flutter_gismo/model/TraitementModel.dart';
import 'package:flutter_gismo/model/User.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../model/BeteModel.dart';

import 'dart:developer' as debug;


class GismoBloc {

  User _currentUser;
  GismoRepository _repository;

  GismoBloc();

  Future<String> init() async {
    // Read value
    FlutterSecureStorage storage = new FlutterSecureStorage();
    try {
      String email = await storage.read(key: "email");
      if (email == null) {
        this._currentUser = new User(null, null);
        _currentUser.setCheptel("00000000");
        _currentUser.subscribe = false;
        _repository = new GismoRepository(this, RepositoryType.local);
        debug.log("Mode autonome", name: "GismoBloc::init");
        return "Mode autonome";
      }
      String password = await storage.read(key: "password");

      this._currentUser = new User(email, password);
      this._currentUser.setCheptel("");
      this._currentUser.setToken("Nothing");
      _repository = new GismoRepository(this, RepositoryType.web);
      this._currentUser =
      await (_repository.dataProvider as WebDataProvider).login(
          this._currentUser);
      debug.log(
          'Mode connecté email : $email - cheptel: $this._currentUser.cheptel',
          name: "GismoBloc::init");
      return "Mode connecté";
    }
    on PlatformException catch(e) {
      this._currentUser = new User(null, null);
      _currentUser.setCheptel("00000000");
      _currentUser.subscribe = false;
      _repository = new GismoRepository(this, RepositoryType.local);
      debug.log("Mode autonome", name: "GismoBloc::init");
      return "Mode autonome";
    }
  }



  bool isLogged() {
     if (_currentUser == null)
      return false;
     debug.log("Cheptel is " + _currentUser.cheptel, name:"GismoBloc::isLogged");
     return _currentUser.subscribe ;
  }

   final dio = new Dio();

  User get user => _currentUser;
  void setUser(User user) {
    this._currentUser = user;
  }

  Future<User> auth(User user) async {
    WebDataProvider aProvider = new WebDataProvider(this);
    this._currentUser = user;
    return aProvider.auth(user);
  }

  Future<User> login(User user) async {
    WebDataProvider aProvider = new WebDataProvider(this);
    this._currentUser = user;
    return aProvider.login(user);
  }

  String logout() {
    this._currentUser = new User(null, null);
    _currentUser.setCheptel("00000000");
    _currentUser.subscribe = false;
    _repository = new GismoRepository(this, RepositoryType.local);
    debug.log("Mode autonome", name: "GismoBloc::init");
    return "Mode autonome";
  }

  Future<String> saveLambing(LambingModel lambing ) async {
    if (lambing.lambs.length == 0)
      return "Pas d'agneaux de saisie";
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
    try {
      List<Event> lstEvents = new List();
      debug.log("get lambs", name: "GismoBloc::getEvents");
      List<LambingModel> lstLambs = await this._repository.dataProvider.getLambs(bete.idBd);
      debug.log("get traitements", name: "GismoBloc::getEvents");
      List<TraitementModel> lstTraitement = await this._repository.dataProvider.getTraitements(bete);
      debug.log("get lots", name: "GismoBloc::getEvents");
      List<Affectation> lstAffect = await this._repository.dataProvider.getAffectationForBete(bete.idBd);
      debug.log("get nec", name: "GismoBloc::getEvents");
      List<NoteModel> lstNotes = await this._repository.dataProvider.getNec(bete);
      List<Pesee> lstPoids  = await this._repository.dataProvider.getPesee(bete);
      lstLambs.forEach((lambing) => { lstEvents.add( new Event.name(lambing.idBd, EventType.agnelage, lambing.dateAgnelage, lambing.lambs.length.toString()))});
      lstTraitement.forEach( (traitement) => {lstEvents.add(new Event.name(traitement.idBd, EventType.traitement, traitement.debut, traitement.medicament))});
      lstNotes.forEach( (note) => {lstEvents.add(new Event.name(note.idBd, EventType.NEC, note.date, note.note.toString()))});
      lstPoids.forEach( (poids) => {lstEvents.add(new Event.name(poids.id, EventType.pesee, poids.datePesee, poids.poids.toString()))});
      lstAffect.forEach( (affect) => {lstEvents.addAll ( _makeEventforAffectation(affect) )});
      lstEvents.sort((a, b) =>  _compareDate(a, b));
      return lstEvents;
    }
    catch(e) {
      print(e);
    }
  }

  List<Event> _makeEventforAffectation(Affectation affect) {
    List<Event> lstEvents = new List();
    lstEvents.add(new Event.name(affect.idAffectation, EventType.entreeLot, affect.dateEntree, affect.lotName));
    lstEvents.add(new Event.name(affect.idAffectation, EventType.sortieLot, affect.dateSortie, affect.lotName));
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

  Future<String> saveLogin(String email, String password) async {
    try {
      final storage = new FlutterSecureStorage();
      User user = User(email, password);
      this._currentUser = await this.login(user);
      this._repository = new GismoRepository(this, RepositoryType.web);
      storage.write(key: "email", value: email);
      storage.write(key: "password", value: password);
      return "Connexion réussie";
    }
    catch (e) {
      throw e;
    }
  }

  Future<String> saveWebConfig(String cheptel, String email, String token) async {
    throw ("Deprecated");
    /*
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
     */
  }

  Future<bool> saveLocalConfig(String cheptel) async {
    throw ("Deprecated");
    /*
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _repository = new GismoRepository(RepositoryType.local);
    this._currentUser = new User(cheptel);
    prefs.setBool("subscribe", false);
    prefs.remove("email");
    prefs.remove("token");
    return prefs.setString("cheptel", cheptel);

     */
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

  Future<String> savePesee(Bete bete, double poids, String date ) async {
    try {
      Pesee pesee = new Pesee();
      pesee.bete_id = bete.idBd;
      pesee.datePesee = date;
      pesee.poids = poids;
      await this._repository.dataProvider.savePesee(pesee);
    }
    catch (e) {
      return "Une erreur et survenue";
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

  Future<String> removeFromLot(Affectation affect, String dateSortie) {
    affect.dateSortie = dateSortie;
    return this._repository.dataProvider.remove(affect);
  }

  Future<List<Affectation>> getAffectations(int idBete) {
    return this._repository.dataProvider.getAffectationForBete(idBete);
  }

  Future<List<Bete>> getBrebis() {
    return this._repository.dataProvider.getBrebis();
  }

  Future<List<Bete>> getBeliers() {
    return this._repository.dataProvider.getBeliers();
  }

  Future<String> getCadastre(LocationData myPosition) async {
    if (this._repository.dataProvider is WebDataProvider) {
       String cadastre = await (this._repository.dataProvider as WebDataProvider).getCadastre(myPosition);
       return cadastre;
    }
    throw ("Uniquement web");
  }

  Future<String> getParcelle(LatLng touchPosition) async {
    if (this._repository.dataProvider is WebDataProvider) {
      String cadastre = await (this._repository.dataProvider as WebDataProvider).getParcelle(touchPosition);
      return cadastre;
    }
    throw ("Uniquement web");
  }

  Future<List<Parcelle>> getParcelles()  async{
    if (this._repository.dataProvider is WebDataProvider) {
      List<Parcelle> parcelles = await (this._repository.dataProvider as WebDataProvider).getParcelles();
      return parcelles;
    }
    throw ("Uniquement web");
  }

  Future<Pature> getPature(String idu) async {
    if (this._repository.dataProvider is WebDataProvider) {
      Pature pature = await (this._repository.dataProvider as WebDataProvider).getPature(idu);
      return pature;
    }
    throw ("Uniquement web");
  }

  Future<String> savePature(Pature pature) async {
    if (this._repository.dataProvider is WebDataProvider) {
      String message = await (this._repository.dataProvider as WebDataProvider).savePature(pature);
      return message;
    }
    throw ("Uniquement web");
   }

}

