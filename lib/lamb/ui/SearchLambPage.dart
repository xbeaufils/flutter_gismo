import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gismo/core/ui/SimpleGismoPage.dart';
import 'package:gismo/generated/l10n.dart';
import 'package:gismo/lamb/presenter/SearchLambPresenter.dart';
import 'package:gismo/model/BeteModel.dart';
import 'package:gismo/model/LambModel.dart';
import 'package:intl/intl.dart';

class SearchLambPage extends StatefulWidget {
  SearchLambPage( { Key? key }) : super(key: key);
  @override
  _SearchLambPageState createState() => new _SearchLambPageState();
}

abstract class SearchLambContract extends GismoContract {
  List<CompleteLambModel> get lambs;
  set lambs(List<CompleteLambModel> value);
  List<CompleteLambModel> get filteredLambs;
  set filteredLambs(List<CompleteLambModel> value);
}

class _SearchLambPageState extends GismoStatePage<SearchLambPage> implements SearchLambContract {
  // final formKey = new GlobalKey<FormState>();
  // final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _filter = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late SearchLambPresenter _presenter = SearchLambPresenter(this);

  String _searchText = "";
  List<CompleteLambModel> _filteredLambs = <CompleteLambModel>[];

  List<CompleteLambModel> get filteredLambs => _filteredLambs;

  set filteredLambs(List<CompleteLambModel> value) {
    setState(() {
      _filteredLambs = value;
    });
  } //new List();
  List<CompleteLambModel> _lambs =<CompleteLambModel>[];

  set lambs(List<CompleteLambModel> value) {
    _lambs = value;
  }
  List<CompleteLambModel> get lambs => _lambs; // new List();

  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text( S.current.provisional_number );

  _SearchLambPageState() {
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

    this._presenter.getLambs();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      key: _scaffoldKey,
      body:
        Column(children: [
          _showCount(S.current.herd_size + ": " + _filteredLambs.length.toString()),
          Expanded (
            child: _buildListLamb(),// _buildFutureLambs(), //
          ),
        ],),
      resizeToAvoidBottomInset: false,
    );
  }

  Widget _showCount(String libelle) {
    return Row(children: <Widget>[
      Expanded(child:
        Card( color: Theme.of(context).primaryColor,  child:
          Center(child:
            Text( libelle, style: TextStyle(fontSize: 16.0, color: Colors.white),),
          ),
        ),
      ),
    ],);
  }

  AppBar _buildBar(BuildContext context) {
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

  Widget _buildListLamb() {
    if (_searchText.isNotEmpty) {
      List<CompleteLambModel> tempList = <CompleteLambModel>[]; //new List();
      for (int i = 0; i < _filteredLambs.length; i++) {
        if (_filteredLambs[i].marquageProvisoire != null) {
          if (_filteredLambs[i].marquageProvisoire!.isNotEmpty) {
            if (_filteredLambs[i].marquageProvisoire!.toLowerCase().contains(
                _searchText.toLowerCase())) {
              tempList.add(_filteredLambs[i]);
            }
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
                (_filteredLambs[index].marquageProvisoire == null)? Container() : Text( _filteredLambs[index].marquageProvisoire!),),
              IconButton( icon: new Icon(Icons.delete), onPressed: () => _showDialog(context, _filteredLambs[index])),
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

  // set up the buttons
  Widget _cancelButton() {
    return TextButton(
      child: Text("Annuler"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _continueButton(CompleteLambModel lamb) {
    return TextButton(
      child: Text("Continuer"),
      onPressed: () {
        this._presenter.deleteLamb(lamb);
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
}