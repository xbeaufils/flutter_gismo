import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_gismo/core/repository/LocalRepository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'agnelage_test.dart';
import 'mouvement_test.dart';
import 'traitement_test.dart';

void main() async {
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
    testWidgets(
        'Saisir une entrée', (tester,) async {
          RobotTestMouvement robot = RobotTestMouvement(tester);
          await robot.create(jsonData["entree"]);
    });
  });

  group("Test des agnelages", () {
    testWidgets("Saisir un agnelage", (tester,) async {
      RobotTestAgnelage robot = RobotTestAgnelage(tester);
      await robot.testAgnelage(jsonData["agnelages"]);
    });
  });
 //   testLot();
 //   testEcho();
  group("Test des traitements", () {
    testWidgets("Saisir un traitement", (tester,) async {
      RobotTestTraitement robot = RobotTestTraitement(tester);
      await robot.createTraitement(jsonData["traitements"]["creation"]);
    });
    testWidgets(
        'Modification d\'un traitement', (tester,) async {
      RobotTestTraitement robot = RobotTestTraitement(tester);
      await robot.modifyTraitement(jsonData["traitements"]["modification"]);
    });
      //deleteTraitement(jsonData["traitements"]["suppression"])
 //    testPesee();
   });
}





Future<void> testEcho() async {
  testWidgets(
      'Saisir une echographie', (tester,) async {
   });

}

Future<void> testPesee() async {
  testWidgets(
      'Saisir une pesée', (tester,) async {
   });

}



Future<void> testLot() async {
  testWidgets("Saisir un lot", (tester,) async {});
}
