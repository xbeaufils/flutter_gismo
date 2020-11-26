import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/lamb/LambPage.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/LambModel.dart';

class SearchLambPage extends StatefulWidget {
  final GismoBloc _bloc;
  SearchLambPage(this._bloc, { Key key }) : super(key: key);
  @override
  _SearchLambPageState createState() => new _SearchLambPageState(_bloc);
}


class _SearchLambPageState extends State<SearchLambPage> {
  // final formKey = new GlobalKey<FormState>();
  // final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _filter = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GismoBloc _bloc;

  String _searchText = "";
  List<CompleteLambModel> _filteredLambs = new List();
  List<CompleteLambModel> _lambs = new List();

  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text( 'Numéro provisoire' );

  _SearchLambPageState(this._bloc) {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          _filteredLambs = _lambs;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  void initState() {
    this._getLambs();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      key: _scaffoldKey,
      body:
        Container (
          child: _buildListLamb(),// _buildFutureLambs(), //
        ),
      resizeToAvoidBottomPadding: false,
    );
  }


  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: _appBarTitle,
      actions: <Widget>[
        IconButton(
            icon: this._searchIcon,
            tooltip: 'Recherche',
            onPressed: _searchPressed
            ),
      ],
    );
  }

  Widget _buildFutureLambs() {
    return FutureBuilder(
        builder: (context, lambSnap) {
          if (lambSnap.connectionState == ConnectionState.none && lambSnap.hasData == null) {
            return Container();
          }
          if (lambSnap.connectionState == ConnectionState.waiting)
            return Center(child:CircularProgressIndicator());
          return ListView.builder(
              itemCount: _lambs == null ? 0 : _filteredLambs.length,
              itemBuilder: (BuildContext context, int index) {
                return new ListTile(
                  leading: (_filteredLambs[index].sex == Sex.male) ? ImageIcon(
                      AssetImage("assets/male.png")) : ImageIcon(
                      AssetImage("assets/female.png")),
                  title: Row(
                    children: <Widget>[
                      Expanded(child:
                      Text(_filteredLambs[index].marquageProvisoire),
                      ),
                      IconButton(icon: new Icon(Icons.delete),
                          onPressed: () =>
                              _showDialog(context, _filteredLambs[index])),
                    ],),
                  subtitle:
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(_filteredLambs[index].numBoucleMere,),
                      SizedBox(width: 16,),
                      Text(_filteredLambs[index].dateAgnelage),
                    ],),
                  trailing:
                  IconButton(
                    icon: new Icon(Icons.keyboard_arrow_right),
                    onPressed: () => _selectLambs(_filteredLambs[index]),),
                  //          onTap: () => _selectLambs(_filteredLambs[index]),
                );
              });
            },
      future: _getAllLambs()
    );
  }

  Widget _buildListLamb() {
    if (_searchText.isNotEmpty) {
      List<CompleteLambModel> tempList = new List();
      for (int i = 0; i < _filteredLambs.length; i++) {
        if (_filteredLambs[i].marquageProvisoire.isNotEmpty) {
          if (_filteredLambs[i].marquageProvisoire.toLowerCase().contains(
              _searchText.toLowerCase())) {
            tempList.add(_filteredLambs[i]);
          }
        }
      }
      _filteredLambs = tempList;
    }
    return ListView.builder(
      itemCount: _lambs == null ? 0 : _filteredLambs.length,
      itemBuilder: (BuildContext context, int index) {
        return new ListTile(
          leading: (_filteredLambs[index].sex == Sex.male) ? ImageIcon(  AssetImage("assets/male.png")): ImageIcon(  AssetImage("assets/female.png")),
          title: Row(
            children: <Widget>[
              Expanded( child:
                Text( _filteredLambs[index].marquageProvisoire),
              ),
              IconButton( icon: new Icon(Icons.delete), onPressed: () => _showDialog(context, _filteredLambs[index])),
            ],),
          subtitle:
            Row (
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text( _filteredLambs[index].numBoucleMere, ),
                SizedBox(width: 16,),
                Text(_filteredLambs[index].dateAgnelage),
            ],),
          trailing:
            IconButton(
              icon: new Icon(Icons.keyboard_arrow_right),
              onPressed: () => _selectLambs(_filteredLambs[index]),),

//          onTap: () => _selectLambs(_filteredLambs[index]),
        );
      },
    );

  }

  void _selectLambs(CompleteLambModel lamb) async  {
    LambModel newLamb = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LambPage.edit( this._bloc, lamb)),
    );
    if (newLamb == null)
      return;
    this._bloc.saveLamb(newLamb);
    _lambs.forEach((aLamb) {
      if (aLamb.idBd == newLamb.idBd) {
        aLamb.sex = newLamb.sex;
        aLamb.allaitement = newLamb.allaitement;
        aLamb.marquageProvisoire = newLamb.marquageProvisoire;
        aLamb.dateDeces = newLamb.dateDeces;
        aLamb.motifDeces = newLamb.motifDeces;
        aLamb.numBoucle = newLamb.numBoucle;
        aLamb.numMarquage = newLamb.numMarquage;
      }
    });
    setState(() {

    });
  }

  // set up the buttons
  Widget _cancelButton() {
    return FlatButton(
      child: Text("Annuler"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _continueButton(CompleteLambModel lamb) {
    return FlatButton(
      child: Text("Continuer"),
      onPressed: () {
        _deleteLamb(lamb);
        Navigator.of(context).pop();
      },
    );
  }

  Future _showDialog(BuildContext context, CompleteLambModel lamb) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Suppression"),
            content: Text(
                "Voulez vous supprimer cet enregistrement ?"),
            actions: [
              _cancelButton(),
              _continueButton(lamb),
            ],
          );
        },
      );
    }

  void _deleteLamb(CompleteLambModel lamb) async {
    String message = await this._bloc.deleteLamb(lamb);
    _lambs  = await this._bloc.getAllLambs();
    setState(() {
       _filteredLambs = _lambs;

    });
    this._showMessage(message);
  }

  void _showMessage(String message) {
      final snackBar = SnackBar(
        content: Text(message),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);

    }

  void _searchPressed() {
      setState(() {
        if (this._searchIcon.icon == Icons.search) {
          this._searchIcon = new Icon(Icons.close);
          this._appBarTitle = new TextField(
            autofocus: true,
            controller: _filter,
            keyboardType: TextInputType.number,
            decoration: new InputDecoration(
                prefixIcon: new Icon(Icons.search),
                hintText: 'Boucle...'
            ),
          );
        } else {
          this._searchIcon = new Icon(Icons.search);
          this._appBarTitle = new Text( 'Recherche boucle' );
          _filteredLambs = _lambs;
          _filter.clear();
        }
      });
    }

  Future<List<CompleteLambModel>> _getAllLambs() async {
    _lambs  = await this._bloc.getAllLambs();
    _filteredLambs = _lambs;
    return _filteredLambs;
  }

  void _getLambs() async {
    _lambs = await this._bloc.getAllLambs();
    setState(() {
      _filteredLambs = _lambs;
    });
  }

}