import 'package:flutter/material.dart';
import 'package:flutter_gismo/Sanitaire.dart';
import 'package:flutter_gismo/individu/NECPage.dart';
import 'package:flutter_gismo/individu/TimeLine.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/lamb/lambing.dart';
import 'package:flutter_gismo/main.dart';
import 'package:flutter_gismo/model/BeteModel.dart';

class SearchPage extends StatefulWidget {
  GismoBloc _bloc;
  GismoPage _nextPage;
  Sex searchSex;
  get bloc => _bloc;
  get nextPage => _nextPage;
  SearchPage(this._bloc, this._nextPage, { Key key }) : super(key: key);
  @override
  _SearchPageState createState() => new _SearchPageState();
}


class _SearchPageState extends State<SearchPage> {
  // final formKey = new GlobalKey<FormState>();
  // final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _filter = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _searchText = "";
  List<Bete> _betes = new List();
  List<Bete> filteredNames = new List();
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text( 'Recherche boucle' );

  _SearchPageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredNames = _betes;
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
    this._getBetes();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      key: _scaffoldKey,
      body: Container(
        child: /*(filteredNames == null) ? CircularProgressIndicator(): */_buildList(),
      ),
      //floatingActionButton: _buildAddButton(),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: _appBarTitle,
       actions: <Widget>[
        IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Recherche',
            onPressed: _searchPressed
            ),
      ],
    );
  }

  Widget _buildList() {
    if (!(_searchText.isEmpty)) {
      List<Bete> tempList = new List();
      for (int i = 0; i < filteredNames.length; i++) {
        if (filteredNames[i].numBoucle.toLowerCase().contains(_searchText.toLowerCase())) {
          tempList.add(filteredNames[i]);
        }
      }
      filteredNames = tempList;
    }
    return ListView.builder(
      itemCount: _betes == null ? 0 : filteredNames.length,
      itemBuilder: (BuildContext context, int index) {
        return new ListTile(
          title: Text( filteredNames[index].numBoucle),
          subtitle: Text(filteredNames[index].numMarquage),

          onTap: () => selectBete(filteredNames[index]),
        );
      },
    );
  }

  void selectBete(Bete bete) {
    var page;
    switch (this.widget.nextPage) {
      case GismoPage.lamb:
        page = LambPage(bete);
        break;
      case GismoPage.sanitaire:
        page = SanitairePage(bete);
        break;
      case GismoPage.individu:
        //page = FicheBetePage(bete);
        page = TimeLinePage(bete);
        break;
      case GismoPage.etat_corporel:
        page = NECPage(bete);
        break;
      case GismoPage.sortie:
      case GismoPage.lot:
        page = null;
        break;
    }

    if (page  == null) {
      Navigator
          .of(context)
          .pop(bete);

    }
    else {
      var navigationResult = Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => page,
        ),
      );

      navigationResult.then((message) {
        if (message != null)
          _showMessage(message);
      });
    }
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
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search),
              hintText: 'Boucle...'
          ),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text( 'Recherche boucle' );
        filteredNames = _betes;
        _filter.clear();
      }
    });
  }

  void _getBetes() async {
    List<Bete> lstBetes = null;
    switch (this.widget.searchSex ) {
      case Sex.femelle:
        lstBetes = await gismoBloc.getBrebis();
        break;
      case Sex.male :
        lstBetes = await gismoBloc.getBeliers();
        break;
      default :
        lstBetes = await gismoBloc.getBetes();
    }
    fillList(lstBetes);
   }

  void fillList(List<Bete> lstBetes) {
    setState(() {
      _betes = lstBetes;
      //names.shuffle();
      filteredNames = _betes;
    });

  }
}