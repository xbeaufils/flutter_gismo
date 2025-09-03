import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gismo/core/ui/SimpleGismoPage.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/lamb/presenter/SearchLambPresenter.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/sheepyGreenScheme.dart';
import 'package:intl/intl.dart';

class SearchLambPage extends StatefulWidget {
  SearchLambPage( { Key? key }) : super(key: key);
  @override
  _SearchLambPageState createState() => new _SearchLambPageState();
}

abstract class SearchLambContract extends GismoContract {
  List<CompleteLambModel> get filteredLambs;
  set filteredLambs(List<CompleteLambModel> value);
}

class _SearchLambPageState extends GismoStatePage<SearchLambPage> implements SearchLambContract {
  final TextEditingController _filter = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late SearchLambPresenter _presenter = SearchLambPresenter(this);

  List<CompleteLambModel> _filteredLambs = <CompleteLambModel>[];

  List<CompleteLambModel> get filteredLambs => _filteredLambs;

  set filteredLambs(List<CompleteLambModel> value) {
    setState(() {
      _filteredLambs = value;
    });
  }

  _SearchLambPageState() {
  }

  @override
  void initState() {
    this._presenter.getLambs();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        title: _builSearchBar(),
      ),
      key: _scaffoldKey,
      body:
        Column(children: [
          Expanded (
            child: _buildListLamb(),// _buildFutureLambs(), //
          ),
        ],),
      resizeToAvoidBottomInset: false,
    );
  }

  Widget _builSearchBar() {
    return SearchBar(
      leading: Badge(label: Text(_filteredLambs.length.toString()), child: Icon(Icons.search)),
      hintText:  S.of(context).search,
      onChanged: (text) {this._presenter.filtre(text);},
      controller: _filter,
    );
  }

  Widget _buildListLamb() {
     return ListView.builder(
      itemCount: _filteredLambs.length,
      itemBuilder: (BuildContext context, int index) {
        return new ListTile(
          leading: (_filteredLambs[index].sex == Sex.male) ? ImageIcon(  AssetImage("assets/male.png")): ImageIcon(  AssetImage("assets/female.png")),
          title: Row(
            children: <Widget>[
              Expanded( child:
                (_filteredLambs[index].marquageProvisoire == null)? Container() : Text( _filteredLambs[index].marquageProvisoire!),),
              IconButton( icon: new Icon(Icons.delete), onPressed: () => this._presenter.deleteLamb( _filteredLambs[index])),
            ],),
          subtitle:
            Row (
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text( _filteredLambs[index].numBoucleMere, ),
                SizedBox(width: 16,),
                Text(DateFormat.yMd().format(_filteredLambs[index].dateAgnelage)),
            ],),
          trailing:
            IconButton(
              icon: new Icon(Icons.keyboard_arrow_right),
              onPressed: () {
                setState(() {
                  this._presenter.selectLambs(_filteredLambs[index]);
                });
                },),

//          onTap: () => _selectLambs(_filteredLambs[index]),
        );
      },
    );

  }

}