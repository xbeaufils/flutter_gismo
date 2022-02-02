
import 'dart:async';
import 'dart:convert';

import 'package:flutter_gismo/Exception/EventException.dart';
import 'package:flutter_gismo/bloc/GismoHttp.dart';
//import 'package:dio/dio.dart';
import 'package:flutter_gismo/Environnement.dart';
import 'package:flutter_gismo/bloc/AbstractDataProvider.dart';
import 'package:flutter_gismo/bloc/GismoBloc.dart';
import 'package:flutter_gismo/model/AffectationLot.dart';
import 'package:flutter_gismo/model/BeteModel.dart';
import 'package:flutter_gismo/model/EchographieModel.dart';
import 'package:flutter_gismo/model/LambModel.dart';
import 'package:flutter_gismo/model/LotModel.dart';
import 'package:flutter_gismo/model/NECModel.dart';
import 'package:flutter_gismo/model/ParcelleModel.dart';
import 'package:flutter_gismo/model/PeseeModel.dart';
import 'package:flutter_gismo/model/SaillieModel.dart';
import 'package:flutter_gismo/model/TraitementModel.dart';
import 'package:flutter_gismo/model/User.dart';

import 'dart:developer' as debug;

import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';


class WebDataProvider extends DataProvider {
  /*
  static BaseOptions options = new BaseOptions(
    baseUrl: Environnement.getUrlTarget(),
    connectTimeout: 5000,
    receiveTimeout: 3000,
  );
  final Dio _dio = new Dio(options);
*/
  late GismoHttp _gismoHttp; // = new GismoHttp(super.token);

  WebDataProvider(GismoBloc bloc) : super(bloc) {
    _gismoHttp = new GismoHttp(bloc);
    //_dio.interceptors.add(LogInterceptor(responseBody: false));
    /*
    _dio.interceptors.add(InterceptorsWrapper(

      onRequest: (RequestOptions options,RequestInterceptorHandler requestInterceptorHandler) => requestInterceptor(options, requestInterceptorHandler),
      onResponse: (Response<dynamic> options,ResponseInterceptorHandler requestInterceptorHandler) => responseInterceptor(options, requestInterceptorHandler),
      onError: (DioError dioError,ErrorInterceptorHandler requestInterceptorHandler) => onError(dioError,requestInterceptorHandler)
    ));
     */
  }
/*
  void responseInterceptor(Response<dynamic> response,ResponseInterceptorHandler handler) {
    return handler.next(response) ;// super.onResponse(response, handler);
  }

  void requestInterceptor(RequestOptions options, RequestInterceptorHandler handler)  {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    //String token = prefs.getString("token");
    if (super.token != null)
      //options.headers.addAll({"token": super.token});
      options.headers["token"] = super.token;
    return handler.next(options);
    //return options;
  }

  void onError(DioError dioError,ErrorInterceptorHandler handler) {
    debug.log("dioError " + dioError.toString(), name: "WebDataProvider::onError");
    return handler.next(dioError);
  }
*/
  Future<User> auth(User user) async {
    try {
      //final response = await _dio.post( Environnement.getUrlTarget() + '/user/auth', data: user.toMap());
      final response = await _gismoHttp.doPostResult( '/user/auth',  user.toMap());
      debug.log("Send authentication", name: "WebDataProvider::auth");
        user.setCheptel(response["cheptel"]);
    }  catch (e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
    debug.log("User is $user.cheptel", name: "WebDataProvider::auth");
    return user;
  }

  Future<String> saveLambing(LambingModel lambing ) async {
    try {
      final response = await _gismoHttp.doPostMessage('/lamb/add',lambing.toJson());
      return response;
    }
    catch ( e) {
      debug.log("Error " + e.toString());
      return "Error " + e.toString();
    }
  }

   Future<String> saveLamb(LambModel lamb ) async {
    try {
      final response = await _gismoHttp.doPostMessage('/lamb/save', lamb.toJson());
      return response;
    }
    catch ( e) {
      debug.log("Error " + e.toString());
      return "Error " + e.toString();
    }
  }

  Future<String> deleteLamb(int idBd ) async {
    try {
      final response = await _gismoHttp.doGet('/lamb/del/' + idBd.toString());
      if (response['error']) {
        throw (response['message']);
      }
      else {
        return response['message'];
      }
    }
    catch ( e) {
      debug.log("Error " + e.toString());
      return "Error " + e.toString();
    }
  }


  Future<List<Bete>> getBetes(String cheptel) async {
    final response = await _gismoHttp.doGetList(
        '/bete/searchAll?cheptel=' + cheptel);
    List<Bete> tempList = [];
    for (int i = 0; i < response.length; i++) {
      tempList.add(new Bete.fromResult(response[i]));
    }
    return tempList;
  }

  Future<String> saveBete(Bete bete) async {
    String action;
    if (bete.idBd == null)
      action = "new";
    else
      action = "update";
    try {
      final response = await _gismoHttp.doPostMessage(
          '/bete/' + action,
          bete.toJson());
        return response;
    } catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }


  @override
  Future<bool> checkBete(Bete bete) async {
    try {
      final response = await _gismoHttp.doPostResult(
          '/bete/check' ,
          bete.toJson());
      return response["value"];
    } catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }

  }

  @override
  Future<Bete> getMere(Bete bete) async {
    try {
      final response = await _gismoHttp.doGet(
          '/bete/mere/' + bete.idBd.toString());
      Bete mere = new Bete.fromResult(response);
      return mere;
    } catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }

  Future<User> login(User user) async {
    try {
      final response = await _gismoHttp.doPostResult(
          '/user/login', user.toMap());
      user.setCheptel (response["cheptel"]);
      user.setToken(response["token"]);
      user.subscribe = true;
    } catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
    return user;
  }

  @override
  Future<List<LambingModel>> getLambs(int idBete) async {
    final response = await _gismoHttp.doGetList(
        '/lamb/searchAll?idMere=' + idBete.toString());
    List<LambingModel> tempList = [];
    for (int i = 0; i < response.length; i++) {
      tempList.add(new LambingModel.fromResult(response[i]));
    }
    return tempList;
  }

  @override
  Future<List<CompleteLambModel>> getAllLambs(String cheptel) async {
    //final response = await _dio.get(
    final response = await _gismoHttp.doGetList(
        '/lamb/cheptel/' + cheptel);
    List<CompleteLambModel> tempList = [];
    for (int i = 0; i < response.length; i++) {
      tempList.add(new CompleteLambModel.fromResult(response[i]));
    }
    return tempList;
  }

  @override
  Future<String> saveSortie(String date, String motif, List<Bete> lstBete) async {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cause'] = motif;
    data['dateSortie'] = date;
    data['lstBete'] = lstBete.map((bete) => bete.toJson()).toList();
    try {
      final response = await _gismoHttp.doPostMessage(
        '/bete/sortie', data);
      return response;
    } catch ( e) {
        throw ("Erreur de connection à " +  Environnement.getUrlTarget());
      }
    }

  @override
  Future<String> saveEntree(String cheptel, String date, String motif, List<Bete> lstBete) async {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cheptel'] = cheptel;
    data['cause'] = motif;
    data['dateEntree'] = date;
    data['lstBete'] = lstBete.map((bete) => bete.toJson()).toList();
    try {
      final response = await _gismoHttp.doPostMessage(
          '/bete/entree', data);
        return response;
    } catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }

  @override
  Future<String> saveTraitement(TraitementModel traitement) async {
    final Map<String, dynamic> data = traitement.toJson();
    try {
      final response = await _gismoHttp.doPostMessage(
          '/traitement/add', data);
      return response;
    } catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }

  @override
  Future<String> saveTraitementCollectif (TraitementModel traitement, List<Bete> betes) async {
    TraitementCollectif col = new TraitementCollectif(traitement, betes);
    final Map<String, dynamic> data = col.toJson();
    try {
      final response = await _gismoHttp.doPostMessage(
          '/traitement/collectif', data);
      return response;
    } catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }
  @override
  Future<List<TraitementModel>> getTraitements(Bete bete) async {
    final response = await _gismoHttp.doGetList(
        '/traitement/get?idBete=' + bete.idBd.toString());
    List<TraitementModel> tempList = [];
    for (int i = 0; i < response.length; i++) {
      tempList.add(new TraitementModel.fromResult(response[i]));
    }
    return tempList;
  }

  @override
  Future<List<TraitementModel>> getTraitementsForLamb(LambModel lamb) async {
    final response = await _gismoHttp.doGetList(
        '/traitement/lamb/' + lamb.idBd.toString());
    List<TraitementModel> tempList = [];
    for (int i = 0; i < response.length; i++) {
      tempList.add(new TraitementModel.fromResult(response[i]));
    }
    return tempList;
  }


  @override
  Future<String> deleteTraitement(int idBd) async {
    try {
      final response = await _gismoHttp.doGet('/traitement/del/' + idBd.toString());
      return response['message'];
    }
    catch ( e) {
      debug.log("Error " + e.toString());
      return "Error " + e.toString();
    }
  }

  @override
  Future<TraitementModel> searchTraitement(int idBd) async {
    final response = await _gismoHttp.doGet(
        '/traitement/search?idBd=' + idBd.toString());
    return new TraitementModel.fromResult(response);
  }

  @override
  Future<String> boucler(LambModel lamb, Bete bete) async {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["lamb"] = lamb.toJson();
    data["bete"] = bete.toJson();
    try {
      final response = await _gismoHttp.doPostMessage(
          '/lamb/boucle',  data);
      return response;
    } catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }


  @override
  Future<LambingModel> searchLambing(int idBd) async {
    final response = await _gismoHttp.doGet(
        '/lamb/search?idBd=' + idBd.toString());
    return new LambingModel.fromResult(response);
  }

  @override
  Future<String> mort(LambModel lamb, String motif, String date) async {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["idBb"] = lamb.idBd;
    data["dateDeces"] = date;
    data["motifDeces"] = motif;
    try {
      final response = await _gismoHttp.doPostMessage(
          '/lamb/mort',  data);
      return response;
    } catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }

  @override
  Future<String> saveNec(NoteModel note) async {
    try {
      final response = await _gismoHttp.doPostMessage(
          '/nec/new', note.toJson());
      return response;
    }catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }

  @override
  Future<List<NoteModel>> getNec(Bete bete) async {
    final response = await _gismoHttp.doGetList(
        '/nec/get?idBete=' + bete.idBd.toString());
    List<NoteModel> tempList = List.empty(growable: true);
    for (int i = 0; i < response.length; i++) {
      tempList.add(new NoteModel.fromResult(response[i]));
    }
    return tempList;
  }

  @override
  Future<String> savePesee(Pesee pesee) async {
    try {
      final response = await _gismoHttp.doPostMessage(
          '/poids/new',  pesee.toJson());
      return response;
    } catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }

  @override
  Future<List<Pesee>> getPesee(Bete bete) async {
    final response = await _gismoHttp.doGetList(
        '/poids/get/' + bete.idBd.toString());
    List<Pesee> tempList = List.empty(growable: true);
    for (int i = 0; i < response.length; i++) {
      tempList.add(new Pesee.fromResult(response[i]));
    }
    return tempList;
  }

  @override
  Future<List<Pesee>> getPeseeForLamb(LambModel lamb) async {
    final response = await _gismoHttp.doGetList(
        '/poids/lamb/' + lamb.idBd.toString());
    List<Pesee> tempList = List.empty(growable: true);
    for (int i = 0; i < response.length; i++) {
      tempList.add(new Pesee.fromResult(response[i]));
    }
    return tempList;
  }

  @override
  Future<String> deletePesee(int idBd) async {
    try {
      final response = await _gismoHttp.doGet('/poids/del/' + idBd.toString());
      return response['message'];
    }
    catch ( e) {
      debug.log("Error " + e.toString());
      return "Error " + e.toString();
    }
  }

  @override
  Future<String> saveSaillie(SaillieModel saillie) async{
    try {
      final response = await _gismoHttp.doPostMessage(
          '/saillie/new',  saillie.toJson());
      return response;
    } catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }
  @override
  Future<List<SaillieModel>> getSaillies(Bete bete) async {
    String ? sex;
    if (bete.sex == Sex.male)
      sex = "male";
    else
      sex = "femelle";
    final response = await _gismoHttp.doGetList(
        '/saillie/'+ sex + '/' + bete.idBd.toString());
    List<SaillieModel> tempList = List.empty(growable: true);
    for (int i = 0; i < response.length; i++) {
      tempList.add(new SaillieModel.fromResult(response[i]));
    }
    return tempList;
    //throw RepositoryTypeException("Not implemented");
  }

  @override
  Future<String> saveEcho(EchographieModel echo) async {
    try {
      final response = await _gismoHttp.doPostMessage(
          '/echo/new', echo.toJson());
      return response;
    }  catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }

  @override
  Future<List<EchographieModel>> getEcho(Bete bete) async {
    final response = await _gismoHttp.doGetList(
        '/echo/get/' + bete.idBd.toString());
    List<EchographieModel> tempList = [];
    for (int i = 0; i < response.length; i++) {
      tempList.add(new EchographieModel.fromResult(response[i]));
    }
    return tempList;
  }

  @override
  Future<EchographieModel> searchEcho(int idBd) async {
    final response = await _gismoHttp.doGet(
        '/echo/search/' + idBd.toString());
    return new EchographieModel.fromResult(response);
  }

  @override
  Future<List<LotModel>> getLots(String cheptel) async {
    final response = await _gismoHttp.doGetList(
        '/lot/getAll/' + cheptel);
    List<LotModel> tempList =[];
    for (int i = 0; i < response.length; i++) {
      tempList.add(new LotModel.fromResult(response[i]));
    }
    return tempList;
  }

  @override
  Future<List<Affectation>> getBeliersForLot(int idLot) async {
    final response = await _gismoHttp.doGetList(
        '/lot/getBeliers/' + idLot.toString());
    List<Affectation> tempList = [];
    for (int i = 0; i < response.length; i++) {
      tempList.add(new Affectation.fromResult(response[i]));
    }
    return tempList;
  }

  @override
  Future<List<Affectation>> getBrebisForLot(int idLot) async {
    final response = await _gismoHttp.doGetList(
        '/lot/getBrebis/' + idLot.toString());
    List<Affectation> tempList = [];
    for (int i = 0; i < response.length; i++) {
      tempList.add(new Affectation.fromResult(response[i]));
    }
    return tempList;
  }

  @override
  Future<String> remove(Affectation affect) async {
      try {
        final response = await _gismoHttp.doPostMessage(
            '/lot/del', affect.toJson());
        return response;
      } catch ( e) {
        throw ("Erreur de connection à " +  Environnement.getUrlTarget());
      }
  }

  @override
  Future<String> deleteAffectation(Affectation affect) async {
    try {
      final response = await _gismoHttp.doGet(
          '/lot/delete/'+ affect.idAffectation!.toString());
      if (response['error']) {
        throw (response['message']);
      }
      else {
        return response['message'];
      }
    }
    catch ( e) {
      debug.log("Error " + e.toString());
      return "Error " + e.toString();
    }
  }

  @override
  Future<String> addBete(LotModel lot, Bete bete, String dateEntree) async {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["lotId"] = lot.idb;
    data["brebisId"] = bete.idBd;
    data["dateEntree"] = dateEntree;
    try {
      final response = await _gismoHttp.doPostMessage(
          '/lot/add', data);
         return response;
    } catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }

  }

  @override
  Future<LotModel> saveLot(LotModel lot) async{
    try {
      final response = await _gismoHttp.doPostResult(
          '/lot/create', lot.toJson());
        return LotModel.fromResult(response);
    } catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }

  @override
  Future<List<Affectation>> getAffectationForBete(int idBete) async {
    try {
      final response = await _gismoHttp.doGetList(
          '/lot/bete/' + idBete.toString());
      List<Affectation> tempList = [];
      for (int i = 0; i < response.length; i++) {
        tempList.add(new Affectation.fromResult(response[i]));
      }
      return tempList;
    }
    catch (e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }

  }

  @override
  Future<List<Bete>> getBeliers() async {
    try {
      final response = await _gismoHttp.doGetList(
          '/bete/getBeliers/');
      List<Bete> tempList = [];
      for (int i = 0; i < response.length; i++) {
        tempList.add(new Bete.fromResult(response[i]));
      }
      return tempList;
    }
    catch (e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }

  }

  @override
  Future<List<Bete>> getBrebis() async {
    final response = await _gismoHttp.doGetList(
        '/bete/getBrebis/');
    List<Bete> tempList = [];
    for (int i = 0; i < response.length; i++) {
      tempList.add(new Bete.fromResult(response[i]));
    }
    return tempList;
  }

  Future<String> getCadastre(LocationData myPosition) async {
    try {
      final response = await _gismoHttp.doPostParcelle(
          '/map/cadastre', jsonEncode({
            'lattitude': myPosition.latitude,
            'longitude': myPosition.longitude
      }));
        String cadastre =  response;
        return cadastre;
    }  catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }

  Future<String> getParcelle(LatLng touchPosition) async {
    try {
      final response = await _gismoHttp.doPostParcelle(
          '/map/parcelle', jsonEncode({
        'lattitude': touchPosition.latitude,
        'longitude': touchPosition.longitude
      }));
      String cadastre =  response;
      return cadastre;
    } catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }

  Future<List<Parcelle>> getParcelles() async {
    try {
      final response = await _gismoHttp.doGetList(
          '/map/parcelles/');
      List<Parcelle> parcelles = [];
      for (int i = 0; i < response.length; i++) {
        parcelles.add(Parcelle.fromResult(response[i]));
      }
      return parcelles;
    } catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }
  Future<Pature> getPature(String idu) async {
    try {
      final response = await _gismoHttp.doGet(
          '/paturage/' + idu);
      if( response.length>0) {
        Pature pature = Pature.fromResult(response);
        return pature;
      }
      throw ("Pature non trouvée");
    }  catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }
  }
  Future<String> savePature(Pature pature) async {
    try {
      final response = await _gismoHttp.doPostMessage(
          '/paturage/save', pature.toJson());
        return response;
    } catch ( e) {
      throw ("Erreur de connection à " +  Environnement.getUrlTarget());
    }

  }
}