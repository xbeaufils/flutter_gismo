import 'dart:developer' as debug;
import 'dart:io';

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gismo/Gismo.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/individu/EchoPage.dart';
import 'package:flutter_gismo/individu/NECPage.dart';
import 'package:flutter_gismo/individu/PeseePage.dart';
import 'package:flutter_gismo/individu/SailliePage.dart';
import 'package:flutter_gismo/individu/TimeLine.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/lamb/lambing.dart';
import 'package:flutter_gismo/memo/MemoPage.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/traitement/Sanitaire.dart';
import 'package:flutter_gismo/traitement/selectionTraitement.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class SelectMultiplePage extends StatefulWidget {
  final GismoBloc _bloc;
  GismoPage _nextPage;
  Sex ? searchSex;
  get nextPage => _nextPage;
  SelectMultiplePage(this._bloc, this._nextPage, { Key? key }) : super(key: key);
  @override
  _SelectMultiplePageState createState() => new _SelectMultiplePageState(_bloc);
}


class _SelectMultiplePageState extends State<SelectMultiplePage> with TickerProviderStateMixin {
  // final formKey = new GlobalKey<FormState>();
  // final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _filter = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GismoBloc _bloc;
  BannerAd ? _adBanner;
  String _searchText = "";
  List<Bete> _betes = <Bete>[]; //new List();
  List<Bete> _filteredBetes = <Bete>[]; //new List();
  Map<int, Bete> _selectedBete = Map();
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text( S.current.earring_search);

  _SelectMultiplePageState(this._bloc) {
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
    if ( ! _bloc.isLogged()!) {
      this._adBanner = BannerAd(
        adUnitId: _getBannerAdUnitId(), //'<ad unit ID>',
        size: AdSize.banner,
        request: AdRequest(),
        listener: BannerAdListener(),
      )..load();
      // See in https://dev-yakuza.posstree.com/en/flutter/admob/#configure-app-id-on-android
      debug.log("Load Ad Banner");
      //this._adBanner!.load();
      FacebookAudienceNetwork.init(
        testingId: "a77955ee-3304-4635-be65-81029b0f5201",
        iOSAdvertiserTrackingEnabled: true,
      );
    }
  }

  String _getBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-9699928438497749/2969884909';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-9699928438497749/5554017347';
    }
    debug.log("Unable to find plateform");
    return "";
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      key: _scaffoldKey,
      body:
        Column(
          children: [
            Expanded(child:  _buildList(context) ),
            ButtonBar(alignment: MainAxisAlignment.start,
                children : [ ElevatedButton(key:null,
                    onPressed: ()=> _selectBete(_selectedBete.values.toList()),
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.lightGreen[700])),
                    //color: Colors.lightGreen[700],
                    child:
                    new Text(
                      S.of(context).validate_lambing,
                      style: new TextStyle(color: Colors.white, ), )
                )
                ]
            ),

            this._getAdmobAdvice(),
            this._getFacebookAdvice(),
          ],
        ),
      resizeToAvoidBottomInset: false,
    );
  }

  Widget _getAdmobAdvice() {
    if (this._bloc.isLogged() ! ) {
      return Container();
    }
    if ((defaultTargetPlatform == TargetPlatform.iOS) || (defaultTargetPlatform == TargetPlatform.android)) {
      return Card(
          child: Container(
              height:  this._adBanner!.size.height.toDouble(),
              width:  this._adBanner!.size.width.toDouble(),
              child: AdWidget(ad:  this._adBanner!)));
    }
    return Container();
  }

  Widget _getFacebookAdvice() {
    if ( this._bloc.isLogged()!  ) {
      return SizedBox(height: 0,width: 0,);
    }
    if ((defaultTargetPlatform == TargetPlatform.iOS) || (defaultTargetPlatform == TargetPlatform.android)) {
      return
        //Card(child:
        FacebookBannerAd(
            placementId: '212596486937356_212596826937322',
            bannerSize: BannerSize.STANDARD,
            keepAlive: true,
            listener: (result, value) {}
          //  ),
        );
    }
    return Container();
  }

  AppBar _buildBar(BuildContext context) {
    //this._appBarTitle = new Text( S.of(context).earring_search );
    return new AppBar(
      centerTitle: true,
      title: _appBarTitle,
      actions: <Widget>[
        IconButton(
            icon: const Icon(Icons.search),
            tooltip: S.of(context).search,
            onPressed: () => _searchPressed(context)
            ),
      ],
    );
  }

  Widget _buildList(BuildContext context) {
    if (_searchText.isNotEmpty) {
      List<Bete> tempList = <Bete>[]; // new List();
      for (int i = 0; i < _filteredBetes.length; i++) {
        if (_filteredBetes[i].numBoucle.toLowerCase().contains(_searchText.toLowerCase())) {
          tempList.add(_filteredBetes[i]);
        }
      }
      _filteredBetes = tempList;
    }
    if (_betes.isEmpty) {
      return Center( child:
        ListTile(
          leading: Icon(Icons.info_outline),
          title: Text(S.of(context).title_empty_list),
          subtitle: Text(S.of(context).text_empty_list),
      ),);
    }
    return
      ListView.builder(
        itemCount: _betes == null ? 0 : _betes.length,
        itemBuilder: (BuildContext context, int index) {
          return
            CheckboxListTile(
              onChanged: (bool? value) {
                setState(() {
                  if (value != null) {
                    if (value)
                      this._selectedBete[_betes[index].idBd!] =_betes[index];
                    else
                      this._selectedBete.remove(_betes[index].idBd!);
                  }
                  var test = _betes[index].numBoucle;
                  debug.log("Change $test $value");
                });
              },
              value: _selectedBete.containsKey(_betes[index].idBd),
              secondary: (_betes[index].sex == Sex.male) ? ImageIcon(
                  AssetImage("assets/male.png")) : ImageIcon(
                  AssetImage("assets/female.png")),
              title: Text(_betes[index].numBoucle),
              subtitle: Text(_betes[index].numMarquage),
            );
      });
  }

  void _selectBete(List<Bete> betes) {
    var page;
    switch (this.widget.nextPage) {
      case GismoPage.sanitaire:
        page = SelectionPage(this._bloc, betes);
        break;
      case GismoPage.sortie:
      case GismoPage.lot:
      case GismoPage.sailliePere:
        page = null;
        break;
    }

    if (page  == null) {
      Navigator.of(context).pop(betes);
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
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //_scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void _searchPressed(BuildContext context) {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          autofocus: true,
          controller: _filter,
          keyboardType: TextInputType.number,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search),
              hintText: S.of(context).earring
          ),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text( S.of(context).earring_search );
        _filteredBetes = _betes;
        _filter.clear();
      }
    });
  }

  void _getBetes() async {
    List<Bete> ? lstBetes ;
    if (this.widget.searchSex == null) {
      lstBetes = await this._bloc.getBetes();
    }
    else {
      switch (this.widget.searchSex) {
        case Sex.femelle:
          lstBetes = await this._bloc.getBrebis();
          break;
        case Sex.male :
          lstBetes = await this._bloc.getBeliers();
          break;
        default :
          lstBetes = await this._bloc.getBetes();
      }
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