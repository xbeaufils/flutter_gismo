import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_gismo/bloc/AbstractDataProvider.dart';
import 'package:flutter_gismo/config.dart';
import 'package:flutter_gismo/main.dart';
import 'package:flutter_gismo/model/AffectationLot.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/model/LotModel.dart';
import 'package:flutter_gismo/model/NECModel.dart';
import 'package:flutter_gismo/model/ReportModel.dart';
import 'package:flutter_gismo/model/TraitementModel.dart';
import 'package:path/path.dart';
//import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'dart:developer' as debug;

class LocalDataProvider extends DataProvider{

  // only have a single app-wide reference to the database
  static Database _database;
  static BaseOptions options = new BaseOptions(
    baseUrl: urlWebTarget,
    connectTimeout: 5000,
    receiveTimeout: 3000,
  );
  final Dio _dio = new Dio(options);

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _init();
    return _database;
  }

  Future<Database> _init() async{
    // Open the database and store the reference.
    //await deleteDatabase(join(await getDatabasesPath(), 'gismo_database.db'));
    Sqflite.setDebugModeOn(true);
//    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    Database database =  await openDatabase(
      // Set the path to the database.

        join(await getDatabasesPath() /*documentsDirectory.path*/, 'gismo_database.db'),
          onCreate: (db, version) {
          // Run the CREATE TABLE statement on the database.
            db.execute("CREATE TABLE `agnelage` ( "
                "`id` INTEGER PRIMARY KEY,"
                "`dateAgnelage` TEXT,"
                "`adoption` INTEGER NULL DEFAULT NULL,"
                "`qualite` INTEGER NULL DEFAULT NULL,"
                "`mere_id` INTEGER)");

            db.execute("CREATE TABLE `agneaux` ( "
            "`id` INTEGER PRIMARY KEY NOT NULL,"
            "`marquageProvisoire` TEXT NULL DEFAULT NULL,"
            "`sex` INTEGER NULL DEFAULT NULL,"
            "`agnelage_id` INTEGER NULL DEFAULT NULL,"
            "`dateDeces` TEXT,"
            "`motifDeces` TEXT,"
            "`devenir_id` INTEGER NULL DEFAULT NULL)");

            db.execute("CREATE TABLE `bete` ( "
            "`id` INTEGER PRIMARY KEY NOT NULL,"
            "`cheptel` TEXT,"
            "`dateEntree` TEXT,"
            "`motifEntree` TEXT,"
            "`dateNaissance` TEXT,"
            "`dateSortie` TEXT,"
            "`motifSortie` TEXT,"
            "`numBoucle` TEXT,"
            "`numMarquage` TEXT,"
            "`nom` TEXT,"
            "`sex` INTEGER)");

            db.execute("CREATE TABLE `NEC` ( "
                "`id` INTEGER PRIMARY KEY,"
                "`date` TEXT,"
                "`note` INTEGER NULL DEFAULT NULL,"
                "`bete_id` INTEGER)");

            return db.execute("CREATE TABLE `traitement` ("
            "`idBd` INTEGER PRIMARY KEY NOT NULL,"
            "`debut` TEXT,"
            "`fin` TEXT,"
            "`intervenant` TEXT,"
            "`medicament` TEXT,"
            "`motif` TEXT,"
            "`observation`TEXT,"
            "`beteId` INTEGER NULL DEFAULT NULL,"
            "`dose` TEXT,"
            "`duree` TEXT,"
            "`rythme` TEXT,"
            "`voie` TEXT,"
            "`ordonnance` TEXT)",);

          },
      onDowngrade: (db, oldVersion, newVersion) {
          db.execute("DROP TABLE `lot`");
          db.execute("DROP TABLE `affectation`");
      },
        onUpgrade:(db, oldVersion, newVersion) {
          if (oldVersion == 1) {
            db.execute("CREATE TABLE `affectation` ("
                "`idBd` INTEGER PRIMARY KEY NOT NULL,"
                "`dateEntree` TEXT NULL DEFAULT NULL,"
                "`dateSortie` TEXT NULL DEFAULT NULL,"
                "`brebisId` INTEGER NULL DEFAULT NULL,"
                "`lotId` INTEGER NULL DEFAULT NULL)");
            db.execute("CREATE TABLE `lot` ("
                "`idBd` INTEGER PRIMARY KEY NOT NULL,"
                "`cheptel` TEXT NULL DEFAULT NULL,"
                "`codeLotLutte` TEXT NULL DEFAULT NULL,"
                "`dateDebutLutte` TEXT NULL DEFAULT NULL,"
                "`dateFinLutte` TEXT NULL DEFAULT NULL,"
                "`campagne` TEXT NULL DEFAULT NULL)");
            db.execute("alter table 'bete' add COLUMN 'nom' TEXT;");
          }
          if (oldVersion == 2) {
            db.execute("alter table 'bete' add COLUMN 'nom' TEXT;");
          }
        },
        // Set the version. This executes the onCreate function and provides a
        // path to perform database upgrades and downgrades.
        version:3,
    );
    Report report = new Report();
    report.cheptel = gismoBloc.user.cheptel;
    List<Map<String, dynamic>> maps = await database.rawQuery("select count(*) as nb from bete");
    report.betes = maps[0]['nb'];
    maps = await database.rawQuery("select count(*) as nb from lot");
    report.lots = maps[0]['nb'];
    maps = await database.rawQuery("select count(*) as nb from affectation");
    report.affectations = maps[0]['nb'];
    maps = await database.rawQuery("select count(*) as nb from traitement");
    report.traitements = maps[0]['nb'];
    maps = await database.rawQuery("select count(*) as nb from agneaux");
    report.agneaux = maps[0]['nb'];
    maps = await database.rawQuery("select count(*) as nb from agnelage");
    report.agnelages = maps[0]['nb'];
    maps = await database.rawQuery("select count(*) as nb from NEC");
    report.nec = maps[0]['nb'];
    try {
      final response = await _dio.post(
          '/send', data: report.toJson());
    }
    catch(e) {
      debug.log("message" + e , name: "LocalDataProvider::_init");
    }
    finally {
      return database;
    }
  }

  @override
  Future<List<Bete>> getBetes(String cheptel) async {
    Database db = await this.database;
    //deleteDatabase(join(await getDatabasesPath(), 'gismo_database.db'));
    final Future<List<Map<String, dynamic>>> futureMaps = db.query('bete', where: 'cheptel = ? AND dateSortie IS NULL', whereArgs: [cheptel]);
    //final Future<List<Map<String, dynamic>>> futureMaps = client.query('car', where: 'id = ?', whereArgs: [id]);
    //futureMaps.then(onValue)
    var maps = await futureMaps;
    List<Bete> tempList = new List();
    for (int i = 0; i < maps.length; i++) {
      tempList.add(new Bete.fromResult(maps[i]));
    }
    return tempList;
  }

  Future<Bete> _searchBete(int idBd) async {
    Database db = await this.database;
    List<Map<String, dynamic>> futureMaps = await db.query('bete' ,where: 'id = ?', whereArgs: [idBd]);
    if (futureMaps.length == 0) {
      debug.log("Bete non trouvéé " + idBd.toString(), name: "LocalDataProvider::searchBete");
      return null;
    }
    return Bete.fromResult(futureMaps[0]);
  }

  @override
  Future<String> saveBete(Bete bete) async {
    Database db = await this.database;
    int res =   await db.update("bete", bete.toJson(),
        where: "id = ?", whereArgs: <int>[bete.idBd]);
    return res.toString() + " enregistrement modifié";
  }

  @override
  Future<List<LambingModel>> getLambs(int idBete) async {
    try {
      Database db = await this.database;
      final Future<List<Map<String, dynamic>>> futureMaps = db.query('agnelage',where: 'mere_id = ?', whereArgs: [idBete]);
      var maps = await futureMaps;
      List<LambingModel> tempList = new List();
      for (int i = 0; i < maps.length; i++) {
        LambingModel current = new LambingModel.fromResult(maps[i]);
        current.lambs = new List();
        List<Map<String, dynamic>> agneaux = await db.query('agneaux',where: 'agnelage_id = ?', whereArgs: [current.idBd]);
        for (int j = 0; j < agneaux.length; j++) {
          LambModel lamb = LambModel.fromResult(agneaux[j]);
          if (lamb.idDevenir != null) {
            Bete devenu = await this._searchBete(lamb.idDevenir);
            lamb.numBoucle = devenu.numBoucle;
            lamb.numMarquage = devenu.numMarquage;
          }
          current.lambs.add(lamb);
        }
        tempList.add(current);
      }
      return tempList;
    } catch (e) {
      // No specified type, handles all
      print('Something really unknown: $e');
    }
  }

  @override
  Future<String> saveLambing(LambingModel lambing ) async {
    Database db = await this.database;
    db.transaction((txn) async {
      int idAgnelage = await _saveLambing(lambing, txn);
      lambing.lambs.forEach((lamb) => {
        _saveLamb(lamb, txn, idAgnelage)
      });
    });
    return "Enregistrement effectué";
  }

  Future<int> _saveLambing(LambingModel lambing, Transaction tx) {
    return tx.insert(
        'agnelage',
        lambing.toBdJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);

  }

  Future<int> _saveLamb(LambModel lamb,Transaction tx, int idAgnelage) {
    lamb.idAgnelage = idAgnelage;
    return tx.insert(
        'agneaux',
        lamb.toBdJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);

  }

  @override
  Future<LambingModel> searchLambing(int idBd) async {
    Database db = await this.database;
    final List<Map<String, dynamic>> futureMaps = await db.query('agnelage',where: 'id = ?', whereArgs: [idBd]);
    if (futureMaps.length == 0) {
      debug.log("Agnelage non trouvé " + idBd.toString(), name: "LocalDataProvider::searchLambing" );
      return null;
    }
    LambingModel current = new LambingModel.fromResult(futureMaps[0]);
    Bete mere = await this._searchBete(current.idMere);
    current.numMarquageMere = mere.numMarquage;
    current.numBoucleMere = mere.numBoucle;
    current.lambs = new List();
    List<Map<String, dynamic>> agneaux = await db.query('agneaux',where: 'agnelage_id = ?', whereArgs: [current.idBd]);
    for (int j = 0; j < agneaux.length; j++) {
      LambModel aLamb = LambModel.fromResult(agneaux[j]);
      if (aLamb.idDevenir != null ) {
        Bete devenu = await this._searchBete(idBd);
        aLamb.numMarquage = devenu.numMarquage;
        aLamb.numBoucle = devenu.numBoucle;
      }
      current.lambs.add(aLamb);
    }
    return current;
  }

  @override
  Future<String> saveSortie( String date, String motif, List<Bete> lstBete) async {
    Database db = await this.database;
    Batch batch = db.batch();
    lstBete.forEach((bete) => { _updateSortie(batch, date, motif, bete)});
    var results = await batch.commit();
    print(results);

  }

  void _updateSortie(Batch batch, String date, String motif, Bete bete) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["motifSortie"] = motif;
    data["dateSortie"] = date;
    batch.update("bete", data , where: "id = ?", whereArgs: <int>[bete.idBd]);
  }

  @override
  Future<String> saveEntree(String cheptel, String date, String motif, List<Bete> lstBete) async {
    Database db = await this.database;
    Batch batch = db.batch();
    lstBete.forEach((bete) => { _insertEntree(batch, cheptel, date, motif, bete)});
    var results = await batch.commit();
    print(results);
  }

  void _insertEntree(Batch batch, String cheptel, String date, String motif, Bete bete) async {
    //Database db = await this.database;
    bete.cheptel = cheptel;
    bete.motifEntree = motif;
    bete.dateEntree = date;
    batch.insert(
        'bete',
        bete.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<String> boucler(LambModel lamb, Bete bete) async {
    Database db = await this.database;
    int idBete = await db.insert('bete', bete.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    lamb.idDevenir = idBete;
    db.update('agneaux', lamb.toBdJson(),where: "id = ?", whereArgs: <int>[lamb.idBd]);
  }

  @override
  Future<String> saveTraitement(TraitementModel traitement) async{
    try {
      Database db = await this.database;
      await db.insert("traitement", traitement.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      return " Enregistrement effectué";
    }
    catch(e) {
      debug.log("Error", error: e);
    }
  }

  @override
  Future<List<TraitementModel>> getTraitements(Bete bete) async{
    Database db = await this.database;
    List<Map<String, dynamic>> futureMaps = await db.query('traitement',where: 'beteId = ?', whereArgs: [bete.idBd]);
    List<TraitementModel> tempList = new List();
    for (int i = 0; i < futureMaps.length; i++) {
      tempList.add(TraitementModel.fromResult(futureMaps[i]));
    }
    return tempList;
  }

  @override
  Future<TraitementModel> searchTraitement(int idBd) async {
    Database db = await this.database;
    List<Map<String, dynamic>> futureMaps = await db.query('traitement',where: 'idBd = ?', whereArgs: [idBd]);
    if (futureMaps.length == 0)
      return null;
    return TraitementModel.fromResult(futureMaps[0]);
  }

  @override
  Future<void> mort(LambModel lamb,  String motif, String date) async {
      Database db = await this.database;
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data["dateDeces"] = date;
      data["motifDeces"] = motif;
      db.update("agneaux", data, where: "id = ?", whereArgs: <int>[lamb.idBd]);
  }

  @override
  Future<String> saveNec(NoteModel note) async {
    try {
      Database db = await this.database;
      await db.insert('NEC', note.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    catch(e) {

    }
  }

  @override
  Future<List<NoteModel>> getNec(Bete bete) async {
    Database db = await this.database;
    List<Map<String, dynamic>> futureMaps = await db.query('NEC',where: 'bete_id = ?', whereArgs: [bete.idBd]);
    List<NoteModel> tempList = new List();
    for (int i = 0; i < futureMaps.length; i++) {
      tempList.add(NoteModel.fromResult(futureMaps[i]));
    }
    return tempList;
  }

  @override
  Future<List<LotModel>> getLots(String cheptel) async {
    Database db = await this.database;
    List<Map<String, dynamic>> maps = await db.query('lot' ,where: 'cheptel = ?', whereArgs: [cheptel]);
    List<LotModel> tempList = new List();
    for (int i = 0; i < maps.length; i++) {
      tempList.add(new LotModel.fromResult(maps[i]));
    }
    return tempList;
  }

  @override
  Future<List<Affectation>> getBeliersForLot(int idLot) async {
    Database db = await this.database;
    List<Map<String, dynamic>> maps = await db.rawQuery(
        'Select affectation.idBd, bete.numBoucle, bete.numMarquage, affectation.dateEntree, affectation.dateSortie '
        'from affectation INNER JOIN bete ON affectation.brebisId = bete.id '
        'where lotId = ' + idLot.toString()
        + " AND bete.sex = 'male' ");
    List<Affectation> tempList = new List();
    for (int i = 0; i < maps.length; i++) {
      tempList.add(new Affectation.fromResult(maps[i]));
    }
    return tempList;
  }

  @override
  Future<List<Affectation>> getBrebisForLot(int idLot) async {
    Database db = await this.database;
    List<Map<String, dynamic>> maps = await db.rawQuery(
        'Select affectation.idBd, bete.numBoucle, bete.numMarquage, affectation.dateEntree, affectation.dateSortie '
            'from affectation INNER JOIN bete ON affectation.brebisId = bete.id '
            'where lotId = ' + idLot.toString()
            + " AND bete.sex = 'femelle' ");
    List<Affectation> tempList = new List();
    for (int i = 0; i < maps.length; i++) {
      tempList.add(new Affectation.fromResult(maps[i]));
    }
    return tempList;
  }

  @override
  Future<void> remove(Affectation affect) async{
    Database db = await this.database;
    db.update("affectation", affect.toJson(), where: "id = ?", whereArgs: <int>[affect.idAffectation]);
  }

  @override
  Future<LotModel> saveLot(LotModel lot) async {
    try {
      Database db = await this.database;
      int id = await db.insert("lot", lot.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      lot.idb = id;
      return lot;
    }
    catch(e) {
      debug.log("Error", error: e);
    }

  }

  @override
  Future<String> addBete(LotModel lot, Bete bete, String dateEntree) async {
    try {
      Affectation affect = new Affectation();
      affect.lotId = lot.idb;
      affect.brebisId = bete.idBd;
      if (dateEntree != null)
        if (dateEntree.isNotEmpty)
          affect.dateEntree = dateEntree;
      Map<String, dynamic> dataDb = new Map.from(affect.toJson());
      dataDb.remove("numBoucle");
      dataDb.remove("numMarquage");
      Database db = await this.database;
      await db.insert("affectation", dataDb,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    catch (e) {
      return "Une erreur est survenue :" + e.toString();
    }
    return "Enregistrement efectué";
  }

  @override
  Future<List<Affectation>> getAffectationForBete(int idBete) async {
    try {
      Database db = await this.database;
      List<Map<String, dynamic>> maps = await db.rawQuery(
          "SELECT affec.*, lot.codeLotLutte as lotName, lot.dateDebutLutte, lot.dateFinLutte FROM affectation affec "
              "LEFT outer JOIN lot lot ON affec.lotId = lot.idBd "
              "WHERE brebisId= " + idBete.toString());
      List<Affectation> tempList = new List();
      for (int i = 0; i < maps.length; i++) {
        tempList.add(new Affectation.fromResult(maps[i]));
      }
      return tempList;
    }
    on DatabaseException catch (e) {
      debug.log("message " + e.toString());
    }
  }

  @override
  Future<List<Bete>> getBeliers() async{
    Database db = await this.database;
    List<Map<String, dynamic>> maps = await db.rawQuery(
        'Select * from bete '
            + "WHERE bete.sex = 'male' "
            "AND cheptel = '" + gismoBloc.user.cheptel + "'");
    List<Bete> tempList = new List();
    for (int i = 0; i < maps.length; i++) {
      tempList.add(new Bete.fromResult(maps[i]));
    }
    return tempList;
  }

  @override
  Future<List<Bete>> getBrebis() async {
    Database db = await this.database;
    List<Map<String, dynamic>> maps = await db.rawQuery(
        'Select * from bete '
            + "WHERE bete.sex = 'femelle' "
    "AND cheptel = '" + gismoBloc.user.cheptel + "'");
    List<Bete> tempList = new List();
    for (int i = 0; i < maps.length; i++) {
      tempList.add(new Bete.fromResult(maps[i]));
    }
     return tempList;
  }

}

