import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gismo/Exception/EventException.dart';
import 'package:flutter_gismo/bloc/GismoRepository.dart';
import 'package:flutter_gismo/bloc/LocalDataProvider.dart';
import 'package:flutter_gismo/bloc/WebDataProvider.dart';
import 'package:flutter_gismo/model/AffectationLot.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/BuetoothModel.dart';
import 'package:flutter_gismo/model/EchographieModel.dart';
import 'package:flutter_gismo/model/Event.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/model/LotModel.dart';
import 'package:flutter_gismo/model/NECModel.dart';
import 'package:flutter_gismo/model/MemoModel.dart';
import 'package:flutter_gismo/model/ParcelleModel.dart';
import 'package:flutter_gismo/model/PeseeModel.dart';
import 'package:flutter_gismo/model/SaillieModel.dart';
import 'package:flutter_gismo/model/StatusBluetooth.dart';
import 'package:flutter_gismo/model/TraitementModel.dart';
import 'package:flutter_gismo/model/User.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry/sentry.dart' hide User, Event;
import 'package:sqflite/sqflite.dart';



import 'dart:developer' as debug;


class GismoBloc {

  User ? _currentUser;
  GismoRepository ? _repository;
  static const  BLUETOOTH_CHANNEL = const MethodChannel('nemesys.rfid.bluetooth');

  GismoBloc();
  /*
  Gestion des exceptions avec sentry
   */
  // FRom https://flutter.dev/docs/cookbook/maintenance/error-reporting
  bool get isInDebugMode {
    // Assume you're in production mode.
    bool inDebugMode = false;
    // Assert expressions are only evaluated during development. They are ignored
    // in production. Therefore, this code only sets `inDebugMode` to true
    // in a development environment.
    assert(inDebugMode = true);
    return inDebugMode;
  }

  Future<void> reportError(dynamic error, dynamic stackTrace) async {
    // Print the exception to the console.
    print('Caught error: $error');
    if (isInDebugMode) {
      // Print the full stacktrace in debug mode.
      print(stackTrace);
    } else {
      // Send the Exception and Stacktrace to Sentry in Production mode.
      Sentry.captureException(error,stackTrace: stackTrace);
    }
  }

  Stream<BluetoothState> streamConnectBluetooth(String address) async* {
    BluetoothState state;
    /*FlutterSecureStorage storage = new FlutterSecureStorage();
    String address = await storage.read(key: "address");*/
    try {
      String status = await BLUETOOTH_CHANNEL.invokeMethod("connectBlueTooth", { 'address': address});
      debug.log("Connect status " + status, name: "streamConnectBluetooth");
      yield  state = BluetoothState.fromResult(json.decode(status));
    } on PlatformException catch(e) {
      debug.log("Erreur ", error: e );
    }
  }

  Future<BluetoothState> startReadBluetooth() async {
    BluetoothState state;
    //FlutterSecureStorage storage = new FlutterSecureStorage();
    //String address = await storage.read(key: "address");
    //debug.log("read data status " + address, name: "GismoBloc::startReadBluetooth");
    String status = await BLUETOOTH_CHANNEL.invokeMethod("readBlueTooth" ); //, { 'address': address});
    debug.log("read status " + status, name: "GismoBloc::startReadBluetooth");
    state = BluetoothState.fromResult(json.decode(status));
    return state;
  }

  void stopBluetooth() {
    BLUETOOTH_CHANNEL.invokeMethod("stopBlueTooth");
  }

  void stopReadBluetooth() {
    BLUETOOTH_CHANNEL.invokeMethod("stopReadBlueTooth");
  }

  Future<String> init() async {
    // Read value
    FlutterSecureStorage storage = new FlutterSecureStorage();

    try {
      String? email = await storage.read(key: "email");
      if (email == null) {
        this._currentUser = new User(null, null);
        _currentUser!.setCheptel("00000000");
        _currentUser!.subscribe = false;
        _currentUser!.setToken("Nothing");
        _repository = new GismoRepository(this, RepositoryType.local);
        debug.log("Mode autonome", name: "GismoBloc::init");
        // Ajout des pubs
        //Admob.initialize();
        FacebookAudienceNetwork.init(
          testingId: "a77955ee-3304-4635-be65-81029b0f5201",
          iOSAdvertiserTrackingEnabled: true,
        );
        if (Platform.isIOS) {
          //await Admob.requestTrackingAuthorization();
        }
        return "Mode autonome";
      }
      String? password = await storage.read(key: "password");

      this._currentUser = new User(email, password);
      this._currentUser?.setCheptel("");
      this._currentUser?.setToken("Nothing");
      _repository = new GismoRepository(this, RepositoryType.web);
      this._currentUser =
      await (_repository?.dataProvider as WebDataProvider).login(
          this._currentUser!);
      debug.log(
          'Mode connecté email : $email - cheptel: $this._currentUser.cheptel',
          name: "GismoBloc::init");
      return "Mode connecté";
    }
    on PlatformException catch(e) {
      this._currentUser = new User(null, null);
      _currentUser?.setCheptel("00000000");
      _currentUser?.subscribe = false;
      _repository = new GismoRepository(this, RepositoryType.local);
      debug.log("Mode autonome", name: "GismoBloc::init");
      return "Mode autonome";
    }
  }

  bool? isLogged() {
     if (_currentUser == null)
      return false;
     debug.log("Cheptel is " + _currentUser!.cheptel!, name:"GismoBloc::isLogged");
     return _currentUser?.subscribe ;
  }

   //final dio = new Dio();

  User ? get user => _currentUser;
  void setUser(User ? user) {
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

  Future<void> loginWeb(User user ) async {
    _repository = new GismoRepository(this, RepositoryType.web);
    this._currentUser = user;
    this._currentUser = await (_repository?.dataProvider as WebDataProvider).login(user);
  }

  String logout() {
    this._currentUser = new User(null, null);
    _currentUser?.setCheptel("00000000");
    _currentUser?.subscribe = false;
    _repository = new GismoRepository(this, RepositoryType.local);
    debug.log("Mode autonome", name: "GismoBloc::init");
    return "Mode autonome";
  }

   Future<String> ? saveLambing(LambingModel lambing ) async {
    if (lambing.lambs.length == 0)
      return "Pas d'agneaux de saisie";
    return this._repository!.dataProvider.saveLambing(lambing);
  }

  Future<String> saveLamb(LambModel lamb ) async {
    return this._repository!.dataProvider.saveLamb(lamb);
  }

  Future<String> deleteLamb(LambModel lamb ) async {
    return this._repository!.dataProvider.deleteLamb(lamb.idBd!);
  }

  Future<List<LambingModel>> getLambs(int idBete) {
    return this._repository!.dataProvider.getLambs(idBete);
  }

  Future<List<CompleteLambModel>> getAllLambs() {
    return this._repository!.dataProvider.getAllLambs(_currentUser!.cheptel!);
  }

  Future<LambingModel?> searchLambing(int idBd) {
    return this._repository!.dataProvider.searchLambing(idBd);
  }
  /*
  Future<String> saveLamb(List<LambModel> lambs ) async {
    return this._repository.dataProvider.saveLamb(lambs);
  }
  */
  Future<String> saveSortie(DateTime date, String motif, List<Bete> betes ) async {
    debug.log("Motif " + motif + " date " + date.toString() + " nb Betes " + betes.length.toString(), name: "GismoBloc::saveSortie");
    this._repository!.dataProvider.saveSortie(date, motif, betes);
    return "Enregistrement effectué";
  }

  Future<String> saveEntree(DateTime date, String motif, List<Bete> betes ) async {
    debug.log("Motif " + motif + " date " + date.toString() + " nb Betes " + betes.length.toString(), name: "GismoBloc::saveEntree");
    this._repository!.dataProvider.saveEntree(this._currentUser!.cheptel!, date, motif, betes);
    return "OK";
  }

  Future<String> deleteTraitement(int idBd) {
    return this._repository!.dataProvider.deleteTraitement(idBd);
  }

  Future<String> saveTraitement(TraitementModel traitement) {
    return this._repository!.dataProvider.saveTraitement(traitement);
  }

  Future<String> saveTraitementCollectif(TraitementModel traitement, List<Bete> betes) {
    return this._repository!.dataProvider.saveTraitementCollectif(traitement, betes);
  }

  Future<List<TraitementModel>> getTraitements(Bete bete) {
    return this._repository!.dataProvider.getTraitements(bete);
  }

  Future<TraitementModel?> searchTraitement(int idBd) {
    return this._repository!.dataProvider.searchTraitement(idBd);
  }

  Future<EchographieModel?> searchEcho(int idBd) {
    return this._repository!.dataProvider.searchEcho(idBd);
  }

  Future<String> saveBete(Bete bete) {
    bete.cheptel = _currentUser!.cheptel!;
    return this._repository!.dataProvider.saveBete(bete);
  }

  Future<bool> checkBete(Bete bete) {
    return this._repository!.dataProvider.checkBete(bete);
  }

  Future<List<Event>> getEvents(Bete bete) async {
    try {
      List<Event> lstEvents = [];
      debug.log("get lambs", name: "GismoBloc::getEvents");
      List<LambingModel> lstLambs = await this._repository!.dataProvider.getLambs(bete.idBd!);
      debug.log("get traitements", name: "GismoBloc::getEvents");
      List<TraitementModel> lstTraitement = await this._repository!.dataProvider.getTraitements(bete);
      debug.log("get lots", name: "GismoBloc::getEvents");
      List<Affectation> lstAffect = await this._repository!.dataProvider.getAffectationForBete(bete.idBd!);
      debug.log("get nec", name: "GismoBloc::getEvents");
      List<NoteModel> lstNotes = await this._repository!.dataProvider.getNec(bete);
      List<Pesee> lstPoids  = await this._repository!.dataProvider.getPesee(bete);
      List<EchographieModel> lstEcho = await this._repository!.dataProvider.getEcho(bete);
      List<SaillieModel> lstSaillie = await this._repository!.dataProvider.getSaillies(bete);
      List<MemoModel> lstMemos = await this._repository!.dataProvider.getMemos(bete);
      lstLambs.forEach((lambing) => { lstEvents.add( new Event.name(lambing.idBd!, EventType.agnelage, DateFormat.yMd().format(lambing.dateAgnelage!), lambing.lambs.length.toString()))});
      lstTraitement.forEach( (traitement) => {lstEvents.add(new Event.name(traitement.idBd!, EventType.traitement, DateFormat.yMd().format(traitement.debut), traitement.medicament))});
      lstNotes.forEach( (note) => {lstEvents.add(new Event.name(note.idBd!, EventType.NEC, DateFormat.yMd().format(note.date), note.note.toString()))});
      lstPoids.forEach( (poids) => {lstEvents.add(new Event.name(poids.id!, EventType.pesee, DateFormat.yMd().format(poids.datePesee), poids.poids.toString()))});
      lstAffect.forEach( (affect) => {lstEvents.addAll ( _makeEventforAffectation(affect) )});
      lstEcho.forEach((echo) {lstEvents.add(new Event.name(echo.idBd!, EventType.echo, DateFormat.yMd().format(echo.dateEcho), echo.nombre.toString())); });
      lstSaillie.forEach((saillie) {
        String numBoucleConjoint;
        if (bete.sex == Sex.male)
          numBoucleConjoint = saillie.numBoucleMere!;
        else
          numBoucleConjoint = saillie.numBouclePere!;
        lstEvents.add(new Event.name(saillie.idBd!, EventType.saillie, DateFormat.yMd().format(saillie.dateSaillie!), numBoucleConjoint));

      });
      lstMemos.forEach((note) {lstEvents.add(new Event.name(note.id!, EventType.memo, DateFormat.yMd().format(note.debut!), note.note!)); });
      lstEvents.sort((a, b) =>  _compareDate(a, b));
      return lstEvents;
    }
    catch(e, stackTrace) {
      this.reportError(e, stackTrace);
    }
    throw EventException("");
  }

  Future<List<Event>> getEventsForLamb(LambModel lamb) async {
    try {
      List<Event> lstEvents = [];
      List<Pesee> lstPoids  = await this._repository!.dataProvider.getPeseeForLamb(lamb);
      lstPoids.forEach( (poids) => {lstEvents.add(new Event.name(poids.id!, EventType.pesee, DateFormat.yMd().format( poids.datePesee) , poids.poids.toString()))});
      List<TraitementModel> lstTraits = await this._repository!.dataProvider.getTraitementsForLamb(lamb);
      lstTraits.forEach((traitement) {lstEvents.add(new Event.name(traitement.idBd!, EventType.traitement,  DateFormat.yMd().format(traitement.debut), traitement.medicament)); });
      return lstEvents;
    }
    catch(e, stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      //this.reportError(e, stackTrace);
    }
    throw EventException("");
  }

  Future<String> deleteEvent(Event event) async {
    String message = "";
    switch (event.type) {
      case EventType.pesee:
        message = await this._repository!.dataProvider.deletePesee(event.idBd);
        break;
      case EventType.traitement:
        message = await this._repository!.dataProvider.deleteTraitement(event.idBd);
        break;
      case EventType.NEC:
        message = await this._repository!.dataProvider.deleteNec(event.idBd);
        break;
      case EventType.saillie:
        message = await this._repository!.dataProvider.deleteSaillie(event.idBd);
        break;
    }
    return message;
  }

  List<Event> _makeEventforAffectation(Affectation affect) {
    List<Event> lstEvents = [];
    lstEvents.add(new Event.name(affect.idAffectation!, EventType.entreeLot, (affect.dateEntree !=null) ?affect.dateEntree!: "", affect.lotName!));
    lstEvents.add(new Event.name(affect.idAffectation!, EventType.sortieLot, (affect.dateSortie!=null)?affect.dateSortie!:"", affect.lotName!));
    return lstEvents;
  }

  int _compareDate(Event a, Event b) {
    return DateFormat.yMd().parse(b.date).compareTo( DateFormat.yMd().parse(a.date));
  }

  Future<String> boucler (LambModel lamb, Bete bete ) {
    bete.cheptel = this._currentUser!.cheptel!;
    return this._repository!.dataProvider.boucler(lamb, bete);
  }

  Future<String>  mort(LambModel lamb, String motif, String date) async {
    try {
      await this._repository!.dataProvider.mort(lamb, motif, date);
      return "Enregistrement effectué";
    }
    catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      //this.reportError(e, stackTrace);
      return "Exception";
    }
  }

  Future<List<Bete>> getBetes() {
    return this._repository!.dataProvider.getBetes(_currentUser!.cheptel!);
  }

  Future<Bete?> getMere(Bete bete) {
    return this._repository!.dataProvider.getMere(bete);
  }

  Future<Bete?> getPere(Bete bete) {
      return this._repository!.dataProvider.getPere(bete);
  }

  Future<String> saveConfig(bool isSubscribe, String email, String password) async {
    try {
      final storage = new FlutterSecureStorage();
      if (isSubscribe) {
        User user = User(email, password);
        this._currentUser = await this.login(user);
        this._repository = new GismoRepository(this, RepositoryType.web);
        storage.write(key: "email", value: email);
        storage.write(key: "password", value: password);
      }
      else {
        this._currentUser = new User(null, null);
        this._currentUser!.setCheptel("00000000");
        this._currentUser!.subscribe = false;
        this._repository = new GismoRepository(this, RepositoryType.local);
        storage.delete(key: "email");
        storage.delete(key: "password");
      }
      return "Configuration enregistrée";
    }
    catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      //this.reportError(e, stackTrace);
      throw e;
    }

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
    catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      //this.reportError(e, stackTrace);
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

  Future<String> saveNec(Bete bete, NEC nec, DateTime date) async{
    try {
      //await Future.delayed(Duration(seconds: 3), () => print('Large Latte'));
      NoteModel note = new NoteModel();
      note.note = nec.note;
      note.date = date;
      note.idBete = bete.idBd!;
      return await this._repository!.dataProvider.saveNec(note);

    }
    catch(e, stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      //this.reportError(e, stackTrace);
      return "Une erreur est survenue";
    }
  }

  Future<String> savePesee(Bete bete, double poids, DateTime date ) async {
    try {
      Pesee pesee = new Pesee();
      pesee.bete_id = bete.idBd;
      pesee.datePesee = date;
      pesee.poids = poids;
      return this._repository!.dataProvider.savePesee(pesee);
    }
    catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      //this.reportError(e, stackTrace);
      return "Une erreur et survenue";
    }
  }

  Future<String> savePeseeLamb(LambModel lamb, double poids, DateTime date ) async {
    try {
      Pesee pesee = new Pesee();
      pesee.lamb_id = lamb.idBd!;
      pesee.datePesee = date;
      pesee.poids = poids;
      return this._repository!.dataProvider.savePesee(pesee);
    }
    catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      //this.reportError(e, stackTrace);
      return "Une erreur et survenue";
    }
  }

  Future<String> saveEcho(EchographieModel echo) async {
    try {
      return this._repository!.dataProvider.saveEcho(echo);
    }
    catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      //this.reportError(e, stackTrace);
      return "Une erreur et survenue";
    }
  }

  Future<String> deleteEcho(EchographieModel echo) {
    return this._repository!.dataProvider.deleteEcho(echo);
  }

  Future<String> saveSaillie(SaillieModel saillie) async {
    try {
      return this._repository!.dataProvider.saveSaillie(saillie);
    }
    catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      return "Une erreur et survenue";
    }
  }
  // Lots
  Future<LotModel ?> saveLot(LotModel lot) async {
    lot.cheptel = this._currentUser!.cheptel!;
    LotModel ? newLot  = await this._repository!.dataProvider.saveLot(lot);
    return newLot;
  }

  Future<String> deleteLot(LotModel lot) {
    return this._repository!.dataProvider.deleteLot(lot);
  }

  Future<List<LotModel>> getLots() {
    return this._repository!.dataProvider.getLots(_currentUser!.cheptel!);
  }

  Future<List<Affectation>> getBrebisForLot(int idLot) {
    return this._repository!.dataProvider.getBrebisForLot(idLot);
  }

  Future<List<Affectation>> getBeliersForLot(int idLot) {
    return this._repository!.dataProvider.getBeliersForLot(idLot);
  }

  Future<String> addBete(LotModel lot, Bete bete, String dateEntree) {
    return this._repository!.dataProvider.addBete(lot, bete, dateEntree);
  }

  Future<String> removeFromLot(Affectation affect, String dateSortie) {
    affect.dateSortie = dateSortie;
    return this._repository!.dataProvider.remove(affect);
  }

  Future<String> deleteAffectation(Affectation affect) {
    return this._repository!.dataProvider.deleteAffectation(affect);
  }

  Future<List<Affectation>> getAffectations(int idBete) {
    return this._repository!.dataProvider.getAffectationForBete(idBete);
  }

  Future<List<Bete>> getBrebis() {
    return this._repository!.dataProvider.getBrebis();
  }

  Future<List<Bete>> getBeliers() {
    return this._repository!.dataProvider.getBeliers();
  }

  Future<List<Bete>> getSaillieBeliers(LambingModel lambing) {
    return this._repository!.dataProvider.getSaillieBeliers(lambing);
  }

  Future<List<Bete>> getLotBeliers(LambingModel lambing) {
    return this._repository!.dataProvider.getLotBeliers(lambing);
  }
  // Notes
  Future<List<MemoModel>> getCheptelNotes() {
    return this._repository!.dataProvider.getCheptelMemos(_currentUser!.cheptel!);
  }
  Future<List<MemoModel>> getBeteNotes(Bete bete) {
    return this._repository!.dataProvider.getMemos(bete);
  }

  Future<String> saveNote(MemoModel note) {
    return this._repository!.dataProvider.saveMemo(note);
  }

  Future<String> deleteNote(MemoModel note) {
    return this._repository!.dataProvider.delete(note);
  }
  Future<MemoModel?> searchMemo(int idBd) {
    return this._repository!.dataProvider.searchMemo(idBd);
  }

  // Cadastre
  Future<String> getCadastre(LatLng /*Position*/ myPosition) async {
    if (this._repository!.dataProvider is WebDataProvider) {
       String cadastre = await (this._repository!.dataProvider as WebDataProvider).getCadastre(myPosition);
       return cadastre;
    }
    throw ("Uniquement web");
  }

  Future<String> getParcelle(LatLng touchPosition) async {
    if (this._repository!.dataProvider is WebDataProvider) {
      String cadastre = await (this._repository!.dataProvider as WebDataProvider).getParcelle(touchPosition);
      return cadastre;
    }
    throw ("Uniquement web");
  }

  Future<List<Parcelle>> getParcelles()  async{
    if (this._repository!.dataProvider is WebDataProvider) {
      List<Parcelle> parcelles = await (this._repository!.dataProvider as WebDataProvider).getParcelles();
      return parcelles;
    }
    throw ("Uniquement web");
  }

  Future<Pature> getPature(String idu) async {
    if (this._repository!.dataProvider is WebDataProvider) {
      Pature pature = await (this._repository!.dataProvider as WebDataProvider).getPature(idu);
      return pature;
    }
    throw ("Uniquement web");
  }

  Future<String> savePature(Pature pature) async {
    if (this._repository!.dataProvider is WebDataProvider) {
      String message = await (this._repository!.dataProvider as WebDataProvider).savePature(pature);
      return message;
    }
    throw ("Uniquement web");
   }

   Future<String ?> copyBD() async {
     //return (_repository.dataProvider as LocalDataProvider).copyBd();
     final df = new DateFormat('yyyy-MM-dd');
     DateTime date = DateTime.now();
     String databasePath = await getDatabasesPath();
     String databaseFile = join(databasePath , 'gismo_database.db');
     final Directory ? extDir = await getExternalStorageDirectory();
     Directory backupdir =  Directory(extDir!.path + '/backup');
     if ( ! backupdir.existsSync() )
       backupdir.createSync();
     String backupFile = join(backupdir.path, 'gismo_database_'+ df.format(date) + '.json');
     //File(databaseFile).copy(backupFile);
     File file = new File(backupFile);
     file.createSync();
     String base = await  (this._repository!.dataProvider as LocalDataProvider).backupBd();
     file.writeAsStringSync(base);
   }

   void deleleteBackup(String filename) async {
     final Directory ? extDir = await getExternalStorageDirectory();
     Directory backupdir =  Directory(extDir!.path + '/backup');
     if ( backupdir.existsSync() ) {
       String backupFile = join(backupdir.path, filename);
        File(backupFile).deleteSync();
     }
   }

  void restoreBackup(String filename) async {
    final Directory ? extDir = await getExternalStorageDirectory();
    Directory backupdir =  Directory(extDir!.path + '/backup');
    if ( backupdir.existsSync() ) {
      String backupFile = join(backupdir.path, filename);
      await (this._repository!.dataProvider as LocalDataProvider).restoreBd(backupFile);
      // File(backupFile).copySync(databaseFile);
    }
  }

}

