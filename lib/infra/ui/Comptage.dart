import 'package:flutter/material.dart';
import 'package:flutter_gismo/core/ui/SimpleGismoPage.dart';
import 'package:flutter_gismo/infra/presenter/ComptagePresenter.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LotModel.dart';
import 'package:flutter_gismo/sheepyGreenScheme.dart';

class ComptagePage extends StatefulWidget {

  ComptagePage();
  int ? _currentLotId;

  @override
  _ComptagePageState createState() => new _ComptagePageState();
}

abstract class WelcomeContract extends GismoContract {
  set currentLotId(int ? value);
  int ? get currentLotId;

}

class _ComptagePageState extends GismoStatePage<ComptagePage> implements WelcomeContract {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late ComptagePresenter _presenter;

  _ComptagePageState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text('Comptage'),
      ),
      body:
        Column(children: <Widget>[
          FutureBuilder<List<LotModel>>(
              future: this._presenter.getLots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Container();
                }
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                return DropdownButton(
                  hint: Text('Lot en paturage'),
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
          Row (children: [
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
            const VerticalDivider(width: 1, thickness: 1),
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
                        this._presenter.countBete(bete),
                  );
                }))
            ])
    ],)
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
  }

}