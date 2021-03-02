import 'dart:async';
import 'dart:convert';
import 'dart:developer' as debug;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gismo/Gismo.dart';
import 'package:flutter_gismo/Sanitaire.dart';
import 'package:flutter_gismo/individu/EchoPage.dart';
import 'package:flutter_gismo/individu/NECPage.dart';
import 'package:flutter_gismo/individu/PeseePage.dart';
import 'package:flutter_gismo/individu/TimeLine.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/lamb/lambing.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/BuetoothModel.dart';
import 'package:flutter_gismo/traitement/Sanitaire.dart';
import 'package:sentry/sentry.dart';

class SearchPage extends StatefulWidget {
  final GismoBloc _bloc;
  GismoPage _nextPage;
  Sex searchSex;
  get nextPage => _nextPage;
  SearchPage(this._bloc, this._nextPage, { Key key }) : super(key: key);
  @override
  _SearchPageState createState() => new _SearchPageState(_bloc);
}


class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  // final formKey = new GlobalKey<FormState>();
  // final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _filter = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GismoBloc _bloc;
  static const  PLATFORM_CHANNEL = const MethodChannel('nemesys.rfid.RT610');

  String _searchText = "";
  List<Bete> _betes = new List();
  List<Bete> _filteredBetes = new List();

  String _bluetoothState ="NONE";
  bool _rfidPresent = false;
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text( 'Recherche boucle' );

  _SearchPageState(this._bloc) {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          _filteredBetes = _betes;
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
    this._startService();
    try {
      this.widget._bloc.streamBluetooth().listen(
              (BluetoothState event) {
            //debug.log("Stream " + event.toString());
            setState(() {
              _bluetoothState = event.status;
              if (event.status == 'AVAILABLE') {
                String _foundBoucle = event.data;
                if (_foundBoucle.length > 15)
                  _foundBoucle = _foundBoucle.substring(_foundBoucle.length - 15);
                _foundBoucle = _foundBoucle.substring(_foundBoucle.length - 5);
                _searchText = _foundBoucle;
                _filter.text = _foundBoucle;
                _searchPressed();
              }

            });
          });

    } on Exception catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      debug.log(e.toString());
    }
  }

  @override
  void dispose() {
    PLATFORM_CHANNEL.invokeMethod<String>('stop');
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      key: _scaffoldKey,
      body:
        Column(
          children: [
            _statusBluetoothBar(),
            Expanded(child: _buildList() ),
          ],
        ),
    floatingActionButton: _buildRfid(),
    resizeToAvoidBottomPadding: false,
    );
  }

  Widget _buildRfid() {
    if (_bloc.isLogged() && this._rfidPresent) {
      return FloatingActionButton(
          child: Icon(Icons.wifi),
          backgroundColor: _lecteurColor,
          onPressed: _readRFID);
    }
    else
      return Container();
  }

  void _readBluetooth() async {
    try {
      setState(() {
        _lecteurColor = Colors.red;
      });
      this.widget._bloc.streamBluetooth().listen(
              (BluetoothState event) {
                //debug.log("Stream " + event.toString());
                setState(() {
                  if (event.status == 'NONE')
                    _lecteurColor = Colors.green;
                  if (event.status == 'WAITING') {
                    if (_lecteurColor == Colors.red)
                      _lecteurColor = Colors.orange;
                    else
                      _lecteurColor = Colors.red;
                  }
                  if (event.status == 'AVAILABLE') {
                    _lecteurColor = Colors.green;
                    String _foundBoucle = event.data.replaceAll("\n", " ");
                    _foundBoucle = _foundBoucle.replaceAll("\r", '');
                    _foundBoucle = _foundBoucle.substring(_foundBoucle.length - 5);
                    _searchText = _foundBoucle;
                    _filter.text = _foundBoucle;
                    _searchPressed();
                  }

                });
              });
     } on Exception catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      debug.log(e.toString());
    }
  }

  void _readRFID() async {
    try {
      String response = await PLATFORM_CHANNEL.invokeMethod("startRead");
      await Future.delayed(Duration(seconds: 4));
      response = await PLATFORM_CHANNEL.invokeMethod("data");
      Map<String, dynamic> mpResponse = jsonDecode(response);
      if (mpResponse.length > 0) {
        _searchPressed();
        setState(() {
          // _searchText = mpResponse['boucle'];
          _filter.text = mpResponse['boucle'];
        });
      }
      else {
        _showMessage("Pas de boucle lue");
      }
    } on PlatformException catch (e) {
      _showMessage("Pas de boucle lue");
    } on Exception catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      //_bloc.reportError(e, stackTrace);
      debug.log(e.toString());
    }

}

  Future<String> _startService() async{
    String start= await PLATFORM_CHANNEL.invokeMethod("start");
    _rfidPresent =  (start == "start");
    return start;
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
    if (_searchText.isNotEmpty) {
      List<Bete> tempList = new List();
      for (int i = 0; i < _filteredBetes.length; i++) {
        if (_filteredBetes[i].numBoucle.toLowerCase().contains(_searchText.toLowerCase())) {
          tempList.add(_filteredBetes[i]);
        }
      }
      _filteredBetes = tempList;
    }
    return ListView.builder(
      itemCount: _betes == null ? 0 : _filteredBetes.length,
      itemBuilder: (BuildContext context, int index) {
        return new ListTile(
          title: Text( _filteredBetes[index].numBoucle),
          subtitle: Text(_filteredBetes[index].numMarquage),
          onTap: () => selectBete(_filteredBetes[index]),
        );
      },
    );
  }

  void selectBete(Bete bete) {
    var page;
    switch (this.widget.nextPage) {
      case GismoPage.lamb:
        page = LambingPage(this._bloc, bete);
        break;
      case GismoPage.sanitaire:
        page = SanitairePage(this._bloc, bete, null);
        break;
      case GismoPage.individu:
        //page = FicheBetePage(bete);
        page = TimeLinePage(_bloc, bete);
        break;
      case GismoPage.etat_corporel:
        page = NECPage(this._bloc, bete);
        break;
      case GismoPage.pesee:
        page = PeseePage(this._bloc, bete, null);
        break;
      case GismoPage.echo:
        page = EchoPage(this._bloc, bete);
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
          keyboardType: TextInputType.number,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search),
              hintText: 'Boucle...'
          ),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text( 'Recherche boucle' );
        _filteredBetes = _betes;
        _filter.clear();
      }
    });
  }

  void _getBetes() async {
    List<Bete> lstBetes = null;
    switch (this.widget.searchSex ) {
      case Sex.femelle:
        lstBetes = await this._bloc.getBrebis();
        break;
      case Sex.male :
        lstBetes = await this._bloc.getBeliers();
        break;
      default :
        lstBetes = await this._bloc.getBetes();
    }
    fillList(lstBetes);
   }

   void fillList(List<Bete> lstBetes) {
    setState(() {
      _betes = lstBetes;
      //names.shuffle();
      _filteredBetes = _betes;
    });

  }

}