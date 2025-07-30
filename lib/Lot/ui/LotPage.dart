import 'dart:developer' as debug;

import 'package:flutter/material.dart';
import 'package:gismo/Lot/presenter/LotPresenter.dart';
import 'package:gismo/Lot/ui/LotAffectationViewPage.dart';
import 'package:gismo/bloc/GismoBloc.dart';
import 'package:gismo/core/ui/SimpleGismoPage.dart';
import 'package:gismo/generated/l10n.dart';
import 'package:gismo/model/LotModel.dart';
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
        if (lotSnap.connectionState == ConnectionState.none && lotSnap.hasData == null) {
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
                leading:  IconButton(icon: Icon(Icons.delete), onPressed: () =>  _showDialog(context, lot), ),
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

  Future _showDialog(BuildContext context, LotModel lot) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).title_delete),
          content: Text( S.of(context).text_delete),
          actions: [
            _cancelButton(),
            _continueButton(lot),
          ],
        );
      },
    );
  }
  Widget _cancelButton() {
    return TextButton(
      child: Text(S.of(context).bt_cancel),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _continueButton(LotModel lot) {
    return TextButton(
      child: Text(S.of(context).bt_continue),
      onPressed: () {
        this._presenter.delete(lot);
        Navigator.of(context).pop();
      },
    );
  }

}