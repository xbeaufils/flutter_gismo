import 'dart:io';

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gismo/core/ui/SimpleGismoPage.dart';
import 'package:flutter_gismo/generated/l10n.dart';

import 'dart:developer' as debug;

import 'package:flutter_gismo/infra/ui/MenuPage.dart';
import 'package:flutter_gismo/infra/presenter/WelcomePresenter.dart';
import 'package:flutter_gismo/model/MemoModel.dart';
import 'package:flutter_gismo/services/AuthService.dart';
import 'package:flutter_gismo/theme.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';



class WelcomePage extends StatefulWidget {

  WelcomePage();

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
    debug.log("Build", name: "Welcome:::build");
    return new Scaffold(
        key: _scaffoldKey,
//        backgroundColor: Colors.lightGreen,
        appBar: new AppBar(
            title: Text('Gismo ' + AuthService().cheptel!),
            actions: [
              FutureBuilder(
                future: _presenter.getNbNotes(),
                builder : (BuildContext context, AsyncSnapshot<List<MemoModel>> snapshot) {
                  int nbNotes = 0;
                  if (snapshot.hasData) {
                    nbNotes = snapshot.data!.length;
                  }
                  return IconButton(
                      onPressed: _presenter.notePressed,
                      icon: Badge(
                          child: Icon(Icons.sticky_note_2),
                          label: Text(nbNotes.toString()),
                      ));
                })],
            // N'affiche pas la touche back (qui revient à la SplashScreen
            automaticallyImplyLeading: true,
             ),
//        bottomNavigationBar: this._navigationBar(),
        body:
        Column(children: [
          Expanded(child:
            GridView.count(
              scrollDirection: Axis.vertical,padding: EdgeInsets.all(10),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 3,
              children: <Widget>[
                _buildGriTile("assets/Lot.png", S.of(context).batch, _presenter.lotPressed) ,
                _buildGriTile("assets/brebis.png", S.of(context).sheep, _presenter.individuPressed),
                _buildGriTile("assets/jumping_lambs.png", S.of(context).lambs, _presenter.lambPressed ),
                _buildGriTile("assets/saillie.png", S.of(context).mating, _presenter.sailliePressed, ),
                _buildGriTile("assets/ultrasound.png", S.of(context).ultrasound, _presenter.echoPressed,) ,
                _buildGriTile("assets/lamb.png", S.of(context).lambing, _presenter.lambingPressed,) ,
                _buildGriTile("assets/syringe.png", S.of(context).treatment, _presenter.traitementPressed,) ,
                _buildGriTile("assets/peseur.png", S.of(context).weighing, _presenter.peseePressed,) ,
                _buildGriTile("assets/etat_corporel.png", S.of(context).body_cond, _presenter.necPressed,),
                _buildGriTile("assets/home.png", S.of(context).input,  _presenter.entreePressed,) ,
                _buildGriTile("assets/Truck.png", S.of(context).output, _presenter.sortiePressed, ),
                _buildGriTile("assets/parcelles.png", "Parcelles", _presenter.parcellePressed ),
              ]),),
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

  Widget _buildGriTile(String imageName, String title, Function() press ) {
    //return GridTile(child: _buildButton(title, imageName, press));
    return GridTile(child:
      Column(children: [
        FilledButton(
          style: ElevatedButton.styleFrom(
            // The width will be 100% of the parent widget
            // The height will be 60
              minimumSize: const Size.fromHeight(60)),
          child: Image.asset(imageName),
          onPressed : press,),
        Text(title) ]),
      );
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
