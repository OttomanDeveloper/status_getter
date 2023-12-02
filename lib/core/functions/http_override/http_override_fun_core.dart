// This class, MyHttpOverrides, extends the HttpOverrides class to override
// the default behavior of creating an HttpClient for making HTTP requests.
// It specifically overrides the certificate validation process for HTTPS
// requests, allowing connections to hosts with invalid or self-signed
// certificates.

import 'dart:io';

import 'package:flutter/material.dart';

@immutable
class MyHttpOverrides extends HttpOverrides {
  @override
  // This method is overridden to create a customized HttpClient with a
  // badCertificateCallback. The badCertificateCallback is a function that
  // determines whether to allow a connection with a given certificate.
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
