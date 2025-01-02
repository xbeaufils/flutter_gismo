import 'dart:developer' as debug;

import 'package:flutter/material.dart';
import 'package:flutter_gismo/Lot/LotAffectationViewPage.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/model/LotModel.dart';
import 'package:intl/intl.dart';


class LotPage extends StatefulWidget {
  final GismoBloc _bloc;

  LotPage(this._bloc,{Key ? key}) : super(key: key);
  @override
  _LotPageState createState() => new _LotPageState(this._bloc);
}

class _LotPageState extends State<LotPage> {
  final GismoBloc _bloc;
  _LotPageState(this._bloc);

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
          onPressed: _createLot,
          backgroundColor: Colors.lightGreen[700],
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
                trailing: IconButton(icon: Icon(Icons.chevron_right), onPressed: () => _viewDetails(lot), )
              )
            );
          },
        );
      },
      future: _getLots(),
    );
  }

  void _viewDetails(LotModel lot ) async {
    String message = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LotAffectationViewPage(this._bloc, lot ),
      ),
    ).whenComplete(() =>
      setState(() {
      })
    );
  }

  void _delete(LotModel lot) async {
    var message  = await _bloc.deleteLot(lot);
    setState(() {
      this._showMessage(message);
    });
  }

  void _showMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //_scaffoldKey.currentState.showSnackBar(snackBar);
  }


  Future<List<LotModel>> _getLots()  {
    return this._bloc.getLots();
  }

  void _createLot(){
    var navigationResult = Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LotAffectationViewPage(this._bloc, new LotModel()),
      ),
    );
    navigationResult.then( (message) {
      setState(() {
        if (message != null) debug.log(message);
      });
    });
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
        _delete(lot);
        Navigator.of(context).pop();
      },
    );
  }

}