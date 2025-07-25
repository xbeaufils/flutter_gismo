import 'dart:io';

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gismo/core/ui/SimpleGismoPage.dart';
import 'package:flutter_gismo/generated/l10n.dart';

import 'dart:developer' as debug;

import 'package:flutter_gismo/infra/ui/MenuPage.dart';
import 'package:flutter_gismo/infra/presenter/WelcomePresenter.dart';
import 'package:flutter_gismo/services/AuthService.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';



class WelcomePage extends StatefulWidget {
  String ? _message;

  WelcomePage(this._message, {Key ? key}) : super(key: key);

  @override
  _WelcomePageState createState() => new _WelcomePageState();
}

abstract class WelcomeContract extends GismoContract {
  void viewPage(String path);
  void viewPageMessage(String path);
}

class _WelcomePageState extends GismoStatePage<WelcomePage> implements WelcomeContract {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late WelcomePresenter _presenter;

  _WelcomePageState();
  BannerAd ? _adBanner;


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
//        backgroundColor: Colors.lightGreen,
        appBar: new AppBar(
            title: Text('Gismo ' + AuthService().cheptel!),
            // N'affiche pas la touche back (qui revient à la SplashScreen
            automaticallyImplyLeading: true,
             ),
//        bottomNavigationBar: this._navigationBar(),
        body:
        ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Card(
                  elevation: 10,
                  child:
                Column(
                  //scrollDirection: Axis.vertical,
                  children: <Widget>[
                    Text("Effectif"), Divider(),
                    ListTile(leading: SizedBox(child: Image.asset("assets/Lot.png"), width: 50), title: Text(S.of(context).batch),trailing:  Icon(Icons.chevron_right), onTap: _presenter.lotPressed, ),
                    ListTile(leading: SizedBox(child: Image.asset("assets/brebis.png"), width: 50), title: Text(S.of(context).sheep),trailing:  Icon(Icons.chevron_right), onTap: _presenter.individuPressed,),
                    ListTile(leading: SizedBox(child:Image.asset("assets/jumping_lambs.png"), width: 50), title: Text(S.of(context).lambs),trailing: Icon(Icons.chevron_right), onTap: _presenter.lambPressed, ),
                  ],)),
              Card(elevation: 10,
                  child:
                      ExpansionTile (title: Text("Reproduction", ), children: [
                        ListTile(leading: SizedBox(child:Image.asset("assets/saillie.png"), width: 50), title: Text(S.of(context).mating),trailing: IconButton(icon: Icon(Icons.chevron_right), onPressed: _presenter.sailliePressed,) ),
                        ListTile(leading: SizedBox(child:Image.asset("assets/ultrasound.png"), width: 50), title: Text(S.of(context).ultrasound),trailing: IconButton(icon: Icon(Icons.chevron_right), onPressed: () =>_presenter.echoPressed,) ),
                        ListTile(leading: SizedBox(child:Image.asset("assets/lamb.png"), width: 50), title: Text(S.of(context).lambing),trailing: IconButton(icon: Icon(Icons.chevron_right), onPressed: () =>_presenter.lambPressed,) ),
                      ],)
/*                  Column(//scrollDirection: Axis.vertical,
                  children: [
                    Text("Reproduction", ), Divider(),
                    ListTile(leading: SizedBox(child:Image.asset("assets/saillie.png"), width: 50), title: Text(S.of(context).mating),trailing: IconButton(icon: Icon(Icons.chevron_right), onPressed: _presenter.sailliePressed,) ),
                    ListTile(leading: SizedBox(child:Image.asset("assets/ultrasound.png"), width: 50), title: Text(S.of(context).ultrasound),trailing: IconButton(icon: Icon(Icons.chevron_right), onPressed: () =>_presenter.echoPressed,) ),
                    ListTile(leading: SizedBox(child:Image.asset("assets/lamb.png"), width: 50), title: Text(S.of(context).lambing),trailing: IconButton(icon: Icon(Icons.chevron_right), onPressed: () =>_presenter.lambPressed,) ),
              ])*/),
              Card(elevation: 10,
                  margin:  EdgeInsets.all(15) ,
                  child: Column(//scrollDirection: Axis.vertical,
                      children: [
                        Text("Sanitaire"), Divider(),
              ListTile(leading: SizedBox(child:Image.asset("assets/syringe.png"), width: 50), title: Text(S.of(context).treatment),trailing: IconButton(icon: Icon(Icons.chevron_right), onPressed: () =>_presenter.traitementPressed,) ),
              ListTile(leading: SizedBox(child: Image.asset("assets/peseur.png"), width: 50,), title: Text(S.of(context).weighing),trailing: IconButton(icon: Icon(Icons.chevron_right), onPressed: () =>_presenter.peseePressed,) ),
              ListTile(leading: SizedBox(child: Image.asset("assets/etat_corporel.png"), width: 50), title: Text(S.of(context).body_cond),trailing: IconButton(icon: Icon(Icons.chevron_right), onPressed: () =>_presenter.necPressed,) ),
              ])),
              Card(elevation: 10,
                  child: Column(//scrollDirection: Axis.vertical,
                      children: [
                        Text("Mouvement"), Divider(),
              ListTile(leading: SizedBox(child: Image.asset("assets/home.png"), width: 50), title: Text(S.of(context).input),trailing: IconButton(icon: Icon(Icons.chevron_right), onPressed: () =>_presenter.entreePressed,) ),
              ListTile(leading: SizedBox(child: Image.asset("assets/Truck.png"), width: 50), title: Text(S.of(context).output),trailing: IconButton(icon: Icon(Icons.chevron_right), onPressed: () =>_presenter.sortiePressed,) ),
              ListTile(leading: SizedBox(child: Image.asset("assets/parcelles.png"), width: 50), title: Text("Parcelles"),trailing: IconButton(icon: Icon(Icons.chevron_right), onPressed: () =>_presenter.lotPressed,) ),
              ])),
             /*
              Card(
                child: Center(
                  child : SingleChildScrollView (
                    scrollDirection: Axis.horizontal,
                    child : ButtonBar(
                      mainAxisSize: MainAxisSize.max,
                      //alignment: MainAxisAlignment.spaceBetween,
                        alignment: MainAxisAlignment.center,
                      buttonMinWidth: 90.0,
                      children: <Widget>[
                        _buildButton(S.of(context).batch, "assets/Lot.png", _presenter.lotPressed),
                        _buildButton(S.of(context).sheep, "assets/brebis.png", _presenter.individuPressed),
                        _buildButton(S.of(context).lambs, 'assets/jumping_lambs.png', _presenter.lambPressed),
                      ])))),
              Card(
                child: Center(
                child:  SingleChildScrollView (
                  scrollDirection: Axis.horizontal,
                  child: ButtonBar(
                    mainAxisSize: MainAxisSize.max,
                    alignment: MainAxisAlignment.spaceEvenly,
                    buttonMinWidth: 90.0,
                    children: <Widget>[
                      _buildButton(S.of(context).mating, "assets/saillie.png", _presenter.sailliePressed),
                      _buildButton(S.of(context).ultrasound, 'assets/ultrasound.png', _presenter.echoPressed),
                      _buildButton( S.of(context).lambing, 'assets/lamb.png', _presenter.lambingPressed),
                    ])))),
              Card(
                child: Center(
                child: SingleChildScrollView (
                  scrollDirection: Axis.horizontal,
                  child: ButtonBar(
                    mainAxisSize: MainAxisSize.max,
                    alignment: MainAxisAlignment.spaceEvenly,
                    buttonMinWidth: 90.0,
                    children: <Widget>[
                      _buildButton(S.of(context).treatment, "assets/syringe.png",_presenter.traitementPressed),
                      _buildButton(S.of(context).body_cond, "assets/etat_corporel.png", _presenter.necPressed), //Etat corporel
                      _buildButton(S.of(context).weighing, 'assets/peseur.png', _presenter.peseePressed), // Pesée
                  ])))),
              Card(
                child: Center(
                  child: SingleChildScrollView (
                  scrollDirection: Axis.horizontal,
                  child:
                    ButtonBar(
                    alignment: MainAxisAlignment.spaceEvenly,
                    buttonMinWidth: 90.0,
                    children: <Widget>[
                      _buildButton(S.of(context).input, "assets/home.png", _presenter.entreePressed), // Entrée
                      _buildButton(S.of(context).output, "assets/Truck.png", _presenter.sortiePressed),
                      _buildButton("Parcelles", "assets/parcelles.png", ()  {
                        (AuthService().subscribe ? _presenter.parcellePressed(): showMessage("Les parcelles ne sont pas visibles en mode autonome"));} ),
                    //  _buildButton("Lecteur BT", "assets/baton_allflex.png", _choixBt)
                    ])))),
              */
              this._getAdmobAdvice(),
              this._getFacebookAdvice(),
            ]),
        drawer: GismoDrawer(),);
  }

  Widget _getAdmobAdvice() {
    if (AuthService().subscribe ) {
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
    if ( AuthService().subscribe   ) {
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

  String _getBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-9699928438497749/2969884909';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-9699928438497749/5554017347';
    }
    debug.log("Unable to find plateform");
    return "";
  }

  Widget _buildButton(String title, String imageName, Function() press) {
    return new TextButton(
        key: Key(title),
        style: textButtonStyle,
        onPressed: press,
        child: new Column(
          children: <Widget>[
            new Image.asset(imageName),
            new Text(title)
          ],
      ));
  }

  final ButtonStyle textButtonStyle = TextButton.styleFrom(
    backgroundColor: Colors.white,
    minimumSize: Size(100, 88),
    padding: const EdgeInsets.all(4.0),
    //padding: EdgeInsets.symmetric(horizontal: 16),
    shadowColor:  Colors.grey.withOpacity(0.5),
    elevation: 5,
    shape: const RoundedRectangleBorder(
      //side: BorderSide(color: Colors.red),
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
  );

  @override
  void initState() {
    super.initState();
    _presenter = WelcomePresenter(this);
    if (! AuthService().subscribe ) {
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

  @override
  void dispose() {
    super.dispose();
    if (this._adBanner != null)
      this._adBanner!.dispose();
  }

  void viewPage(String path) {
    Navigator.pushNamed(context, path);
  }

  void viewPageMessage(String path) {
    Future<dynamic>  message = Navigator.pushNamed(context, path)  ;
    message.then((message) {
      if (message != null)
        showMessage(message);
    }).catchError((message) {
      showMessage(message);
    });

  }



}
