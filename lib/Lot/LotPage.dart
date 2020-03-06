import 'dart:convert';
import 'dart:developer' as debug;

import 'package:flutter/material.dart';
import 'package:flutter_gismo/Lot/LotAffectationViewPage.dart';
import 'package:flutter_gismo/main.dart';
import 'package:flutter_gismo/model/LotModel.dart';


class LotPage extends StatefulWidget {
  LotPage({Key key}) : super(key: key);
  @override
  _LotPageState createState() => new _LotPageState();
}

class _LotPageState extends State<LotPage> {
  @override
  void initState(){
    super.initState();
    //this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Lot'),
      ),
      body:
      new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _listLotWidget(),
           ]

      ),
      floatingActionButton:
        FloatingActionButton(
          onPressed: null,
          backgroundColor: Colors.lightGreen[700],
          child: Icon(Icons.add),),
    );
  }

  Widget _listLotWidget() {
    return FutureBuilder(
      builder: (context, LotSnap) {
        if (LotSnap.connectionState == ConnectionState.none && LotSnap.hasData == null) {
          return Container();
        }
        if (LotSnap.connectionState == ConnectionState.waiting)
          return CircularProgressIndicator();
        return ListView.builder(
          shrinkWrap: true,
          itemCount: LotSnap.data.length,
          itemBuilder: (context, index) {
            LotModel lot = LotSnap.data[index];
            return Column(
              children: <Widget>[
                Card(child:
                    ListTile(
                      title: Text(lot.codeLotLutte),
                      subtitle: Text(lot.dateDebutLutte),
                      trailing: IconButton(icon: Icon(Icons.chevron_right), onPressed: () => _viewDetails(lot), )
                    )
                )
              ],
            );
          },
        );
      },
      future: _getLots(),
    );
  }

  void _viewDetails(LotModel lot ) {
    var navigationResult = Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LotAffectationViewPage(lot),
      ),
    );
    navigationResult.then( (message) {if (message != null) debug.log(message);} );
  }

  Future<List<LotModel>> _getLots()  {
    return gismoBloc.getLots();
  }

  void buttonPressed(){}

}