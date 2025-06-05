import 'dart:async';
import 'dart:convert';
import 'dart:developer' as debug;
import 'dart:io';

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gismo/Gismo.dart';
import 'package:flutter_gismo/bloc/BluetoothBloc.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/individu/ui/EchoPage.dart';
import 'package:flutter_gismo/individu/ui/NECPage.dart';
import 'package:flutter_gismo/individu/ui/PeseePage.dart';
import 'package:flutter_gismo/individu/ui/SailliePage.dart';
import 'package:flutter_gismo/individu/ui/TimeLine.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/lamb/ui/lambing.dart';
import 'package:flutter_gismo/memo/MemoPage.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/BuetoothModel.dart';
import 'package:flutter_gismo/traitement/Sanitaire.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sentry/sentry.dart';

class SearchPage extends StatefulWidget {
  GismoPage _nextPage;
  Sex ? searchSex;
  get nextPage => _nextPage;
  SearchPage( this._nextPage, { Key? key }) : super(key: key);
  @override
  _SearchPageState createState() => new _SearchPageState();
}


class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  // final formKey = new GlobalKey<FormState>();
  // final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _filter = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GismoBloc  _bloc = GismoBloc();
  static const  PLATFORM_CHANNEL = const MethodChannel('nemesys.rfid.RT610');
  BannerAd ? _adBanner;
  String _searchText = "";
  List<Bete> _betes = <Bete>[]; //new List();
  List<Bete> _filteredBetes = <Bete>[]; //new List();

  Stream<BluetoothState> ? _bluetoothStream;
  StreamSubscription<BluetoothState> ? _bluetoothSubscription;
  String _bluetoothState ="NONE";
  final BluetoothBloc _btBloc= new BluetoothBloc();
  bool _rfidPresent = false;
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text( S.current.earring_search);

  _SearchPageState() {
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
    if (this._bloc.isLogged()! && defaultTargetPlatform == TargetPlatform.android)
      new Future.delayed(Duration.zero,() {
        this._startService(context);
      });
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
    if ((defaultTargetPlatform == TargetPlatform.iOS) || (defaultTargetPlatform == TargetPlatform.android)) {
      PLATFORM_CHANNEL.invokeMethod<String>('stop');
      this._bloc.stopReadBluetooth();
      if (this._bluetoothSubscription != null)
        this._bluetoothSubscription?.cancel();
    }
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      key: _scaffoldKey,
      body:
        Column(
          children: [
            _statusBluetoothBar(context),
            this._showCount(S.current.herd_size + ": " + _filteredBetes.length.toString()),
            Expanded(child: _buildList(context) ),
            this._getAdmobAdvice(),
            this._getFacebookAdvice(),
          ],
        ),
      floatingActionButton: _buildRfid(context),
      resizeToAvoidBottomInset: false,
    );
  }

  Widget _statusBluetoothBar(BuildContext context)  {
    if ( ! this._bloc.isLogged()!)
      return Container();
    List<Widget> status = <Widget>[]; //new List();
    switch (_bluetoothState) {
      case "NONE":
        status.add(Icon(Icons.bluetooth));
        status.add(Text(S.of(context).not_connected));
        break;
      case "WAITING":
        status.add(Icon(Icons.bluetooth));
        status.add(Expanded(child: LinearProgressIndicator(),));
        break;
      case "AVAILABLE":
        status.add(Icon(Icons.bluetooth));
        status.add(Text(S.of(context).data_available));
    }
    return Row(children: status,);
  }

  Widget _buildRfid(BuildContext context) {
    if (_bloc.isLogged()! && this._rfidPresent) {
      return FloatingActionButton(
          child: Icon(Icons.wifi),
          backgroundColor: Colors.green,
          onPressed: () => _readRFID(context));
    }
    else
      return Container();
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

  void _readRFID(BuildContext context) async {
    try {
      String response = await PLATFORM_CHANNEL.invokeMethod("startRead");
      await Future.delayed(Duration(seconds: 4));
      response = await PLATFORM_CHANNEL.invokeMethod("data");
      Map<String, dynamic> mpResponse = jsonDecode(response);
      if (mpResponse.length > 0) {
        _searchPressed(context);
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

  Future<String> _startService(BuildContext context) async{
    try {
      debug.log("Start service ", name: "_SearchPageState::_startService");
      BluetoothState _bluetoothState =  await this._bloc.startReadBluetooth();
      if (_bluetoothState.status != null)
        debug.log("Start status " + _bluetoothState.status!, name: "_SearchPageState::_startService");
      if (_bluetoothState.status == BluetoothBloc.CONNECTED
      || _bluetoothState.status == BluetoothBloc.STARTED) {
        this._bluetoothStream = this._btBloc.streamReadBluetooth();
        this._bluetoothSubscription = this._bluetoothStream!.listen(
            (BluetoothState event) {
              if ( event.status != null)
                debug.log("Status " + event.status!, name: "_SearchPageState::_startService");
              if (this._bluetoothState != event.status)
                setState(() {
                  this._bluetoothState = event.status!;
                  if (event.status == 'AVAILABLE') {
                    String _foundBoucle = event.data!;
                    if (_foundBoucle.length > 15)
                      _foundBoucle =
                          _foundBoucle.substring(_foundBoucle.length - 15);
                    _foundBoucle =
                        _foundBoucle.substring(_foundBoucle.length - 5);
                    _searchText = _foundBoucle;
                    _filter.text = _foundBoucle;
                    _searchPressed(context);
                  }
                });
            });
      }
    } on Exception catch (e, stackTrace) {
      Sentry.captureException(e, stackTrace : stackTrace);
      debug.log(e.toString());
    }
    String start= await PLATFORM_CHANNEL.invokeMethod("start");
    _rfidPresent =  (start == "start");
    return start;
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
    if (_filteredBetes.isEmpty) {
      return Center( child:
        ListTile(
          leading: Icon(Icons.info_outline),
          title: Text(S.of(context).title_empty_list),
          subtitle: Text(S.of(context).text_empty_list),
      ),);
    }
    return ListView.builder(
      itemCount: _betes == null ? 0 : _filteredBetes.length,
      itemBuilder: (BuildContext context, int index) {
        return new ListTile(
          leading: (_filteredBetes[index].sex == Sex.male) ? ImageIcon(  AssetImage("assets/male.png")): ImageIcon(  AssetImage("assets/female.png")),
          title: Text( _filteredBetes[index].numBoucle),
          subtitle: Text(_filteredBetes[index].numMarquage ),
          trailing: (_filteredBetes[index].nom != null) ? Text(_filteredBetes[index].nom! ) : SizedBox(width: 0,height: 0,),
          onTap: () => _selectBete(_filteredBetes[index]),
        );
      },
    );
  }

  Widget _showCount(String libelle) {
    return Row(children: <Widget>[
      Expanded(child:
        Card( color: Theme.of(context).primaryColor,  child:
          Center(child:
            Text( libelle, style: TextStyle(fontSize: 16.0, color: Colors.white),),),
        ),
      ),
    ],);
  }

  void _selectBete(Bete bete) {
    var page;
    switch (this.widget.nextPage) {
      case GismoPage.lamb:
        page = LambingPage(bete);
        break;
      case GismoPage.sanitaire:
        page = SanitairePage(this._bloc, bete, null);
        break;
      case GismoPage.individu:
        page = TimeLinePage(bete);
        break;
      case GismoPage.etat_corporel:
        page = NECPage(bete);
        break;
      case GismoPage.pesee:
        page = PeseePage(bete, null);
        break;
      case GismoPage.echo:
        page = EchoPage( bete);
        break;
      case GismoPage.saillie:
        page = SailliePage(bete);
        break;
      case GismoPage.note:
        page = MemoPage(bete);
        break;
      case GismoPage.sortie:
      case GismoPage.lot:
      case GismoPage.sailliePere:
        page = null;
        break;
    }

    if (page  == null) {
      Navigator.of(context).pop(bete);
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