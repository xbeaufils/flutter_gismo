import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gismo/core/ui/SimpleGismoPage.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/infra/presenter/ComptagePresenter.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LotModel.dart';
import 'package:flutter_gismo/model/StatusBluetooth.dart';
import 'package:flutter_gismo/services/AuthService.dart';
import 'package:flutter_gismo/sheepyGreenScheme.dart';

class ComptagePage extends StatefulWidget {

  ComptagePage();
  int ? _currentLotId;

  @override
  _ComptagePageState createState() => new _ComptagePageState();
}

abstract class ComptageContract extends GismoContract {
  set currentLotId(int ? value);
  int ? get currentLotId;
  StatusBlueTooth get bluetoothState;
  set bluetoothState(StatusBlueTooth value);

}

class _ComptagePageState extends GismoStatePage<ComptagePage> implements ComptageContract {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late ComptagePresenter _presenter;
  StatusBlueTooth _bluetoothState = StatusBlueTooth.none();

  set bluetoothState(StatusBlueTooth value) {
    setState(() {
      _bluetoothState = value;
    });
  }
  StatusBlueTooth get bluetoothState => _bluetoothState;

  _ComptagePageState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text(S.current.count_compteur),
      ),
      body:
        Column(children: <Widget>[
          Container(child:
            Padding(padding: EdgeInsetsGeometry.all(10),
              child:
              FutureBuilder<List<LotModel>>(
                future: this._presenter.getLots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return Container();
                  }
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return DropdownButton(
                    hint: Text(S.current.batch_select),
                    items: snapshot.data.map <DropdownMenuItem<int>>((LotModel lot) {
                      return DropdownMenuItem(
                        child: Text( ( lot.codeLotLutte==null)?"": lot.codeLotLutte! ),
                        value: lot.idb,);
                    }).toList(),
                    value: currentLotId,
                    onChanged: (int ? value) {
                      setState(() {
                        currentLotId = value;
                        this._presenter.getBetes();
                      });
                    },
                  );
                }
              ),
              ),
            width:  double.infinity,
            color:  sheepyGreenSheme.colorScheme.primaryContainer,
          ),
          _statusBluetoothBar(),
          Expanded(child:
            Row (children: [
              Expanded( child:
                Column( children: [ //Colonne effectif théorique
                  this._header(S.current.count_theorique,  _presenter.allBetes.length.toString()),
                  Expanded(child:
                     ListView.builder ( //.separated(
                      itemCount: _presenter.allBetes.length,
                      itemBuilder: (context, index) {
                        Bete bete = _presenter.allBetes[index];
                        return ListTile(
                          tileColor: (index % 2 == 0) ? sheepyGreenSheme.colorScheme
                              .primaryContainer : sheepyGreenSheme.colorScheme
                              .surface,
                          title: Text(bete.numBoucle),
                          subtitle: Text(bete.numMarquage),
                          onTap: () =>
                              this._presenter.countBete(bete),
                        );
                      })
                  ),
                ],),
              ),
              const VerticalDivider(width: 1, thickness: 1),
              Expanded(child:
                Column( children: [ //Colonne effectif théorique
                  this._header(S.current.count_presents, _presenter.countedBetes.length.toString()) ,
                Expanded(child:
                  ListView.builder ( //.separated(
                    itemCount: _presenter.countedBetes.length,
                    itemBuilder: (context, index) {
                      Bete bete = _presenter.countedBetes[index];
                      return ListTile(
                        tileColor: (index % 2 == 0) ? sheepyGreenSheme.colorScheme
                            .primaryContainer : sheepyGreenSheme.colorScheme
                            .surface,
                        title: Text(bete.numBoucle),
                        subtitle: Text(bete.numMarquage),
                        onTap: () =>
                            this._presenter.uncountBete(bete),
                      );
                    }))
              ]),
              )],),
      ),])
    );
  }

  @override
  int? get currentLotId => this.widget._currentLotId;

  @override
  set currentLotId(int ? value) {
    this.widget._currentLotId = value;
  }

  @override
  void initState() {
    super.initState();
    this._presenter = ComptagePresenter(this);
    this._presenter.init();
      if (AuthService().subscribe && defaultTargetPlatform == TargetPlatform.android)
      new Future.delayed(Duration.zero,() {
        this._presenter.startService();
      });
}

  Widget _header(String entete, String number) {
    return
      Container(child:
        SizedBox(child:
          Text(entete + " : " + number, style: TextStyle(color: Colors.white),) ,
          height: 40,
        ),
        alignment: Alignment.center,
        width:  double.infinity,
        color:  sheepyGreenSheme.colorScheme.primary);
  }
 Widget _statusBluetoothBar() {
   if (!AuthService().subscribe)
     return Container();
   List<Widget> status = <Widget>[]; //new List();
   if (_bluetoothState.connectionStatus == "CONNECTED")
     switch (_bluetoothState.dataStatus) {
       case "WAITING":
         status.add(Icon(Icons.bluetooth));
         status.add(Expanded(child: LinearProgressIndicator(),));
         break;
       case "AVAILABLE":
         status.add(Icon(Icons.bluetooth));
         status.add(Text(S
             .of(context)
             .data_available));
     }
   else {
     status.add(Icon(Icons.bluetooth));
     status.add(Text(S
         .of(context)
         .not_connected));
   }
    return Container (
      color:  sheepyGreenSheme.colorScheme.surface,
      child: Row(children: status,));
 }
}