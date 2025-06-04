import 'dart:developer' as debug;

import 'package:flutter_gismo/model/ReportModel.dart';
import 'package:flutter_gismo/core/repository/AbstractRepository.dart';

import 'package:path/path.dart';
import 'package:sentry/sentry.dart';
import 'package:sqflite/sqflite.dart';

class LocalRepository {

  static Database ? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _init();
    return _database!;
  }

  Future<void> resetDatabase() async{
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'gismo_database.db');
    await deleteDatabase(path);
    _database = null;
  }

  Future<Database> _init() async{
    // Open the database and store the reference.
    Sqflite.setDebugModeOn(true);
//    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    Database database =  await openDatabase(
      // Set the path to the database.

      join(await getDatabasesPath() , 'gismo_database.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        _createTableAgnelage(db);
        _createTableAgneaux(db);
        _createTableBete(db);
        _createTableNec(db);
        _creatTableTraitement(db);
        _createTableLot(db);
        _createTableAffectation(db);
        _createTablePesee(db);
        _createTableEcho(db);
        _createTableSaillie(db);
        _createTableMemo(db);
      },
      onUpgrade:(db, oldVersion, newVersion) {
        if (oldVersion < 2) {
          this._migrate1to2(db);
        }
        if (oldVersion < 3) {
          this._migrate2to3(db);
        }
        if (oldVersion < 4) {
          this._migrate3to4(db);
        }
        if (oldVersion < 5) {
          this._migrate4to5(db);
        }
        if (oldVersion < 6) {
          this._migrate5to6(db);
        }
        if (oldVersion < 7) {
          this._migrate6to7(db);
        }
        if (oldVersion <8) {
          this._migrate7to8(db);
        }
        if (oldVersion < 9) {
          this._migrate8to9(db);
        }
        if (oldVersion < 10) {
          this._migrate9to10(db);
        }
        if (oldVersion < 11 )
          this._migrate10to11(db);
        if (oldVersion < 12 )
          this._migrate11to12(db);
        if (oldVersion < 13 )
          this._migrate12to13(db);

      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version:13,
    );
    this._sendReport(database);
    return database;
  }

  void _sendReport(Database database ) async {
    WebRepository web = WebRepository("");
    Report report = new Report();
    report.cheptel ="";
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
      final response = await web.doPostWeb(
          '/send', report.toJson());
    }
    catch(e,stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      //super.bloc.reportError(e, stackTrace);
      debug.log("message"  , name: "LocalDataProvider::_init");
    }

  }

  void _migrate1to2(Database db) {
    _createTableAffectation(db);
    _createTableLot(db);
    db.execute("alter table 'bete' add COLUMN 'nom' TEXT;");
  }
  void _migrate2to3(Database db) {
    db.execute("alter table 'bete' add COLUMN 'nom' TEXT;");
  }
  void _migrate3to4(Database db) {
    _createTablePesee(db);
  }
  void _migrate4to5(Database db) {
    db.execute("ALTER TABLE 'NEC' RENAME COLUMN 'id' TO 'idBd'");
  }
  void _migrate5to6(Database db) {
    _createTableEcho(db);
  }
  void _migrate6to7(Database db) {
    db.execute("ALTER TABLE 'agneaux' ADD COLUMN `allaitement` TEXT");
  }
  void _migrate7to8(Database db) {
    db.execute("ALTER TABLE 'pesee' ADD COLUMN `lamb_id` INTEGER NULL DEFAULT NULL");
    _createTableLot(db);
    _createTableAffectation(db);
  }
  void _migrate8to9(Database db) {
    _createTableLot(db);
    _createTableAffectation(db);
    db.execute("ALTER TABLE 'traitement' ADD COLUMN `lambId` INTEGER NULL DEFAULT NULL");
    db.execute("ALTER TABLE 'bete' ADD COLUMN `observations` TEXT");
  }
  void _migrate9to10(Database db) {
    db.execute("ALTER TABLE `agnelage` ADD COLUMN `observations` TEXT ");
    db.execute("ALTER TABLE 'agneaux' ADD COLUMN `sante` TEXT");
    db.execute("UPDATE 'agneaux' set sante='VIVANT' where sante IS NULL");
  }
  void _migrate10to11(Database db) {
    _createTableSaillie(db);
    db.execute("ALTER TABLE `agnelage` ADD COLUMN `pere_id` INTEGER NULL DEFAULT NULL");
  }
  void _migrate11to12(Database db) {
  }
  void _migrate12to13(Database db) {
    _createTableMemo(db);
  }

  void _createTableAgnelage(Database db) {
    db.execute("CREATE TABLE `agnelage` ( "
        "`id` INTEGER PRIMARY KEY,"
        "`dateAgnelage` TEXT,"
        "`observations` TEXT,"
        "`adoption` INTEGER NULL DEFAULT NULL,"
        "`qualite` INTEGER NULL DEFAULT NULL,"
        "`mere_id` INTEGER,"
        "`pere_id` INTEGER NULL DEFAULT NULL)");
  }
  void _createTableAgneaux(Database db) {
    db.execute("CREATE TABLE `agneaux` ( "
        "`id` INTEGER PRIMARY KEY NOT NULL,"
        "`marquageProvisoire` TEXT NULL DEFAULT NULL,"
        "`sex` INTEGER NULL DEFAULT NULL,"
        "`agnelage_id` INTEGER NULL DEFAULT NULL,"
        "`dateDeces` TEXT,"
        "`motifDeces` TEXT,"
        "`devenir_id` INTEGER NULL DEFAULT NULL,"
        "`sante` TEXT,"
        "`allaitement` TEXT)");
  }
  void _createTableBete(Database db) {
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
        "`observations` TEXT,"
        "`sex` INTEGER)");
  }
  void _createTableNec(Database db) {
    db.execute("CREATE TABLE `NEC` ( "
        "`idBd` INTEGER PRIMARY KEY,"
        "`date` TEXT,"
        "`note` INTEGER NULL DEFAULT NULL,"
        "`bete_id` INTEGER)");
  }
  void _createTableAffectation(Database db) {
    db.execute("CREATE TABLE IF NOT EXISTS `affectation` ("
        "`idBd` INTEGER PRIMARY KEY NOT NULL,"
        "`dateEntree` TEXT NULL DEFAULT NULL,"
        "`dateSortie` TEXT NULL DEFAULT NULL,"
        "`brebisId` INTEGER NULL DEFAULT NULL,"
        "`lotId` INTEGER NULL DEFAULT NULL)");
  }
  void _createTableLot(Database db) {
    db.execute("CREATE TABLE IF NOT EXISTS `lot` ("
        "`idBd` INTEGER PRIMARY KEY NOT NULL,"
        "`cheptel` TEXT NULL DEFAULT NULL,"
        "`codeLotLutte` TEXT NULL DEFAULT NULL,"
        "`dateDebutLutte` TEXT NULL DEFAULT NULL,"
        "`dateFinLutte` TEXT NULL DEFAULT NULL,"
        "`campagne` TEXT NULL DEFAULT NULL)");
  }
  void _createTablePesee(Database db) {
    db.execute("CREATE TABLE `pesee` ("
        "`id` INTEGER NOT NULL,"
        "`datePesee` TEXT NULL DEFAULT NULL,"
        "`poids` REAL NULL DEFAULT NULL,"
        "`bete_id` INTEGER NULL DEFAULT NULL,"
        "`lamb_id` INTEGER NULL DEFAULT NULL,"
        " PRIMARY KEY('id'))");
  }
  void _creatTableTraitement(Database db) {
    db.execute("CREATE TABLE `traitement` ("
        "`idBd` INTEGER PRIMARY KEY NOT NULL,"
        "`debut` TEXT,"
        "`fin` TEXT,"
        "`intervenant` TEXT,"
        "`medicament` TEXT,"
        "`motif` TEXT,"
        "`observation`TEXT,"
        "`beteId` INTEGER NULL DEFAULT NULL,"
        "`lambId` INTEGER NULL DEFAULT NULL,"
        "`dose` TEXT,"
        "`duree` TEXT,"
        "`rythme` TEXT,"
        "`voie` TEXT,"
        "`ordonnance` TEXT)",);
  }

  void _createTableEcho(Database db) {
    db.execute("create table Echo ("
        "id INTEGER PRIMARY KEY NOT NULL, "
        "dateAgnelage TEXT, "
        "dateEcho TEXT, "
        "dateSaillie TEXT, "
        "nombre INTEGER, "
        "bete_id INTEGER)");
  }

  void _createTableSaillie(Database db) {
    db.execute("CREATE TABLE `saillie` ("
        "`idBd` INTEGER NOT NULL,"
        "`dateSaillie` TEXT NULL DEFAULT NULL,"
        "`idMere` INTEGER NULL DEFAULT NULL,"
        "`idPere` INTEGER NULL DEFAULT NULL,"
        " PRIMARY KEY('idBd'))");

  }
  void _createTableMemo(Database db) {
    db.execute("CREATE TABLE `memo` ("
        "`id` INTEGER NOT NULL,"
        "`debut` TEXT NULL DEFAULT NULL,"
        "`fin` TEXT NULL DEFAULT NULL,"
        "`classe` TEXT NULL DEFAULT NULL,"
        "`note` TEXT NULL DEFAULT NULL,"
        "`bete_id` INTEGER NULL DEFAULT NULL,"
        "PRIMARY KEY (`id`))");
  }


}