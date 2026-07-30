import 'dart:developer' as debug;

import 'package:flutter/material.dart';
import 'package:flutter_gismo/Lot/presenter/LotPresenter.dart';
import 'package:flutter_gismo/core/ui/SimpleGismoPage.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/model/LotModel.dart';
import 'package:intl/intl.dart';


class LotPage extends StatefulWidget {

  LotPage() ;
  @override
  _LotPageState createState() => new _LotPageState();
}
abstract class LotContract extends GismoContract {

}

class _LotPageState extends GismoStatePage<LotPage> implements LotContract {
  _LotPageState();

  late LotPresenter _presenter;

  @override
  void initState() {
    super.initState();
    _presenter = LotPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(S.of(context).batch),
      ),
      body:
          SingleChildScrollView(
            child:
              new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _listLotWidget(),
                   ]

              ),
          ),
      floatingActionButton:
        FloatingActionButton(
          onPressed: this._presenter.createLot,
          child: Icon(Icons.add),),
    );
  }

  Widget _listLotWidget() {
    return FutureBuilder(
      builder: (context, AsyncSnapshot lotSnap) {
        if (lotSnap.connectionState == ConnectionState.none && lotSnap.data == null) {
          return Container();
        }
        if (lotSnap.connectionState == ConnectionState.waiting)
          return CircularProgressIndicator();
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: lotSnap.data.length,
          itemBuilder: (context, index) {
            LotModel lot = lotSnap.data[index];
            return Card(child:
              ListTile(
                leading:  IconButton(icon: Icon(Icons.delete), onPressed: () =>  this._presenter.delete(lot), ),
                title: Text(lot.codeLotLutte!),
                subtitle: Text(DateFormat.yMd().format( lot.dateDebutLutte!)),
                trailing: IconButton(icon: Icon(Icons.chevron_right), onPressed: () => this._presenter.viewDetails(lot), )
              )
            );
          },
        );
      },
      future: this._presenter.getLots(),
    );
  }

}