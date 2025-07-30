// @dart=2.12.0
import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';

import 'package:gismo/main.dart';
import 'package:http/io_client.dart';
import 'package:http/http.dart' as http;

class CertificatLetsEncrypt {
  /*
    Debut Certificat
   */

  /// From dart:io, create a HttpClient with a trusted certificate [cert]
  /// added to SecurityContext.
  /// Wrapped in try catch in case the certificate is already trusted by
  /// device/os, which will cause an exception to be thrown.
  HttpClient customHttpClient({String? cert}) {
    SecurityContext context = SecurityContext.defaultContext;

    try {
      if (cert != null) {
        List<int> bytes = utf8.encode(cert);
        context.setTrustedCertificatesBytes(bytes);
      }
      print('createHttpClient() - cert added!');
    } on TlsException catch (e) {
      if (e?.osError?.message != null &&
          e.osError!.message.contains('CERT_ALREADY_IN_HASH_TABLE')) {
        print('createHttpClient() - cert already trusted! Skipping.');
      }
      else {
        print('createHttpClient().setTrustedCertificateBytes EXCEPTION: $e');
        rethrow;
      }
    } finally {}

    HttpClient httpClient = new HttpClient(context: context);

    return httpClient;
  }

  /// Use package:http Client with our custom dart:io HttpClient with added
  /// LetsEncrypt trusted certificate
  http.Client createLEClient() {
    IOClient ioClient;
    ioClient = IOClient(customHttpClient(cert: ISRG_X1));
    return ioClient;
  }

  /// Example using a custom package:http Client
  /// that will work with devices missing LetsEncrypt
  /// ISRG Root X1 certificates, like old Android 7 devices.
  //test('HTTP client to LetsEncrypt SSL website', () async {
  void getCertificat() async {
    const sslUrl = 'https://valid-isrgrootx1.letsencrypt.org/';
    http.Client _client = createLEClient();
    http.Response _response = await _client.get(Uri.parse(sslUrl));
    print(_response.body);
  }
/*
  Fin certificat
   */
}