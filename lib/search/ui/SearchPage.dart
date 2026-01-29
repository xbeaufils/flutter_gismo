import 'dart:async';
import 'dart:developer' as debug;
import 'dart:io';

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gismo/Gismo.dart';
import 'package:flutter_gismo/generated/l10n.dart';
import 'package:flutter_gismo/core/ui/SimpleGismoPage.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/StatusBluetooth.dart';
import 'package:flutter_gismo/search/presenter/SearchPresenter.dart';
import 'package:flutter_gismo/services/AuthService.dart';
import 'package:flutter_gismo/sheepyGreenScheme.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class SearchPage extends StatefulWidget {

  GismoPage _nextPage;
  Sex ? searchSex;
  get nextPage => _nextPage;
  SearchPage(this._nextPage, { Key? key }) : super(key: key);
  @override
  _SearchPageState createState() => new _SearchPageState();
}

abstract class SearchContract extends GismoContract {
  void goPreviousPage(Bete bete);
  void setBoucle(String numBoucle);
  StatusBlueTooth get bluetoothState;
  set bluetoothState(StatusBlueTooth value);
  set filteredBetes(List<Bete> value);
  GismoPage get nextPage;
}

class _SearchPageState extends GismoStatePage<SearchPage>  with TickerProviderStateMixin implements SearchContract {
  final TextEditingController _filter = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late SearchPresenter _presenter ;
  BannerAd ? _adBanner;

  List<Bete> _filteredBetes = <Bete>[]; //new List();

  StatusBlueTooth _bluetoothState = StatusBlueTooth.none();

  set bluetoothState(StatusBlueTooth value) {
    setState(() {
      _bluetoothState = value;
    });
  }
  StatusBlueTooth get bluetoothState => _bluetoothState;

  @override
  void initState() {
    debug.log("Démarrage", name: "_SearchPageState::initState");
    this._presenter = SearchPresenter(this);
    this._presenter.getBetes(null);
    if (AuthService().subscribe && defaultTargetPlatform == TargetPlatform.android)
      new Future.delayed(Duration.zero,() {
        this._presenter.startService();
      });
    super.initState();
  }

  String _getBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-9699928438497749/2969884909';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-9699928438497749/3752490208';
    }
    debug.log("Unable to find plateform");
    return "";
  }

  @override
  void dispose() {
    this._presenter.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
     if ( ! AuthService().subscribe ) {
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
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        //backgroundColor: sheepyGreenSheme.primaryColor,
        title: _buildSearchBar(), // Text(S.current.earring_search),
        actions: [_statusBluetooth()],
      ),
      key: _scaffoldKey,
      body:
        Column(
          children: [
            Expanded(child: _buildList(context) ),
            this._getAdmobAdvice(),
            this._getFacebookAdvice(),
          ],
        ),
      resizeToAvoidBottomInset: false,
    );
  }

  Widget _buildSearchBar() {
    return SearchBar(
      key: Key("searchBar"),
      leading: Badge(label: Text(_filteredBetes.length.toString()), child: Icon(Icons.search)),
      hintText: S.of(context).search,
      onChanged: (text) {this._presenter.filtre(text);},
      controller: _filter,
    );
  }

  Widget _statusBluetooth() {
    if ( ! AuthService().subscribe )
      return Container();
    List<Widget> status = <Widget>[]; //new List();
    if (_bluetoothState.connectionStatus == "CONNECTED")
      switch (_bluetoothState.dataStatus) {
        case "WAITING":
          return Padding(padding: EdgeInsets.only (left: 16, right: 16), child:Chip(label: Icon(Icons.bluetooth_searching) , backgroundColor: Colors.lightGreen,));
        case "AVAILABLE":
          return Padding(padding: EdgeInsets.only (left: 16, right: 16), child:Chip(label: Icon(Icons.bluetooth_connected), backgroundColor: Colors.lightBlueAccent,));
      }
    else {
      return Padding(padding: EdgeInsets.only (left: 16, right: 16), child:  Chip(label: Icon(Icons.bluetooth_disabled_sharp)));
    }
    return Card(child: Row(children: status,));
  }

  Widget _getAdmobAdvice() {
    if (AuthService().subscribe  ) {
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
    if ( AuthService().subscribe ) {
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


  void setBoucle(String numBoucle) {
    setState(() {
      _filter.text = numBoucle;
      this._presenter.filtre(numBoucle);
    });
  }

  Widget _buildList(BuildContext context) {
    if (_filteredBetes.isEmpty) {
      return Center( child:
        ListTile(
          leading: Icon(Icons.info_outline),
          title: Text(S.of(context).title_empty_list),
          subtitle: Text(S.of(context).text_empty_list),
      ),);
    }
    return ListView.builder(
      itemCount: _filteredBetes.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: (_filteredBetes[index].sex == Sex.male) ? ImageIcon(  AssetImage("assets/male.png")): ImageIcon(  AssetImage("assets/female.png")),
          title: Text( _filteredBetes[index].numBoucle),
          subtitle: Text(_filteredBetes[index].numMarquage ),
          trailing: (_filteredBetes[index].nom != null) ? Text(_filteredBetes[index].nom! ) : SizedBox(width: 0,height: 0,),
          onTap: () => this._presenter.selectBete(_filteredBetes[index]),
        );
      },
    );
  }

  void goPreviousPage(Bete bete) {
    Navigator.of(context).pop(bete);
  }

  Future<String?> goNextPage(StatefulWidget page) async {
    String ? message = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
    return message;
  }

  get nextPage => this.widget._nextPage;

  set filteredBetes(List<Bete> value) {
    setState(() {
      _filteredBetes = value;
    });
  }
}