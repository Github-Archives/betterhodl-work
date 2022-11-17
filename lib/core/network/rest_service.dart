import 'dart:io';
import 'package:betterhodl_flutter/core/network/api_status.dart';
import 'package:http/http.dart' as http;

class NetworkException implements Exception {
  String message;
  int code;

  NetworkException(this.message, this.code);

  @override
  String toString() {
    return '$message: response code: $code';
  }
}

class RestService<T> {
  final http.Client client;

  RestService(this.client);

  Future<Object> get(String url, Function decode) async {
    try {
      final response = await client.get(Uri.parse(url));
      if (200 == response.statusCode) {
        var result = decode(response.body);
        return Success(response: result);
      }
      return Failure(code: response.statusCode, error: 'Non-200 response');
    } on SocketException {
      return Failure(code: 101, error: 'No internet connection');
    }
  }
}
