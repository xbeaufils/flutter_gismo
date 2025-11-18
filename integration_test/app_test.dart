import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gismo/core/repository/LocalRepository.dart';
import 'package:flutter_gismo/env/Environnement.dart';
import 'package:flutter_gismo/flavor/FlavorOvin.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'RobotConfigTest.dart';
import 'RobotEchoTest.dart';
import 'RobotPeseeTest.dart';
import 'RobotVerifcationTest.dart';
import 'agnelage_test.dart';
import 'lot_test.dart';
import 'mouvement_test.dart';
import 'traitement_test.dart';

void main() async {
  Environnement.init(
      "https://www.neme-sys.fr/bd", "http://10.0.2.2:8080/gismoApp/api",
      new FlavorOvin());
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  int count = 0;
  //final path = '${Directory.current.path}resource_test/data.json';
  //final String dataTest = await File(path).readAsString();

  String dataTest = await rootBundle.loadString('resource_test/data.json');
  final Map<String, dynamic>  jsonData = jsonDecode(dataTest);
  setUpAll(()  async {
    print("---------");
    print ("| count $count |");
    if (count == 0 ) {
      LocalRepository repo = LocalRepository();
      await repo.resetDatabase();
      FlutterSecureStorage storage = new FlutterSecureStorage();
      print("-------------------");
      print("| Delete database |");
      print("-------------------");
      await storage.deleteAll();
    }
    count ++;
  });
  group('Création du cheptel', () {
    testWidgets('Saisir une entrée', (tester,) async {
          RobotTestMouvement robot = RobotTestMouvement(tester);
          await robot.create(jsonData["entree"]);
    });
  });

  group("Test des echos", () {
    testWidgets("Saisir une echo", (tester) async {
      RobotEchoTest robot = RobotEchoTest(tester);
      await robot.create(jsonData["echo"]);
    }, skip: true);
  });

  group("Test des agnelages", () {
    testWidgets("Saisir un agnelage", (tester,) async {
      RobotTestAgnelage robot = RobotTestAgnelage(tester);
      await robot.create(jsonData["agnelages"]["create"]);
    }, skip: true);
  });


  group("Test des traitements", () {
    testWidgets("Saisir un traitement", (tester,) async {
      RobotTestTraitement robot = RobotTestTraitement(tester);
      await robot.create(jsonData["traitements"]["creation"]);
    }, skip: true);
    testWidgets(
        'Modification d\'un traitement', (tester,) async {
      RobotTestTraitement robot = RobotTestTraitement(tester);
      await robot.modify(jsonData["traitements"]["modification"]);
    }, skip: true);
    //deleteTraitement(jsonData["traitements"]["suppression"])
    testWidgets("Création d'un traitement pour agneau", (tester,) async {
      RobotTestTraitement robot = RobotTestTraitement(tester);
      await robot.createForLamb(jsonData["traitements"]["create_agneau"]);
    }, skip: true);
  });

  group("Test des lots", () {
    testWidgets(
        'Saisir un lot', (tester,) async {
      RobotLotTest robot = RobotLotTest(tester);
      await robot.create(jsonData["Lot"]["create"]);
    }, skip: true);
    testWidgets("Modification date de fin", (tester,) async {
      RobotLotTest robot = RobotLotTest(tester);
      await robot.modifyEnd(jsonData["Lot"]["modification"]);
    }, skip: true);
  });
  group("Test des pesées", () {
    testWidgets(
        'Saisir une pesée de brebis', (tester,) async {
          RobotPeseeTest robot = RobotPeseeTest(tester);
          await robot.create(jsonData["pesees"]["brebis"]);
    }, skip: true);
    testWidgets(
        'Saisir une pesée d\'agneaux', (tester,) async {
      RobotPeseeTest robot = RobotPeseeTest(tester);
      await robot.createPesee(jsonData["pesees"]["agneau"]);
    }, skip: true);
  });

  group("Test des agneaux", () {
    testWidgets(
        'Mort d\'un agneau', (tester,) async {
      RobotTestAgnelage robot = RobotTestAgnelage(tester);
      await robot.mort(jsonData["agnelages"]["mort"]);
    }, skip: true);
    testWidgets(
        'Bouclage d\'un agneau', (tester,) async {
      RobotTestAgnelage robot = RobotTestAgnelage(tester);
      await robot.boucle(jsonData["agnelages"]["bouclage"]);
    }, skip: true);
  });

  group("Vérification des saisies", () {
    testWidgets("Vérification des saisies", (tester) async {
      RobotVerificationTest robot = RobotVerificationTest(tester);
      await robot.verify(jsonData["verifications"]);
    }, skip: true);

  });

  group("Test de sortie", () {
    testWidgets("Sortie de brebis", (tester) async {
      RobotTestMouvement robot = RobotTestMouvement(tester);
      await robot.sortie(jsonData["sortie"]);
    }, skip: true);
  });

  group("Passage à abonné", () {
    testWidgets("Enregistrement abonnement", (tester) async {
      RobotConfigTest robot = RobotConfigTest(tester);
      await robot.login();
    });
  });
}

