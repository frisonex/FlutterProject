import 'package:asegensa/environments/env.dart';
import 'package:dio/dio.dart';

//
final dio = Dio();

void configureApiRestService() {
  dio.options.baseUrl = flutter_app_base_url_web_api;
  Map<String, String> headerRequest = {'Content-Type': 'multipart/form-data', 'Content-type': 'application/json', 'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkJlYXJlciJ9.eyJhdXRobWV0aG9kIjoicGFzc3dvcmQiLCJpZF91c3VhcmlvIjoyMjksImlkX3VzdWFyaW9fYXV0b3JpemEiOjIyOSwibm9tYnJlX3VzdWFyaW8iOiJsaW5jYW5nby5kZW5uaXMiLCJlbWFpbF91c3VhcmlvIjoiZGxpbmNhbmdvQGZyaXNvbmV4LmNvbSIsImVtcHJlc2EiOiJFMDEiLCJzdWN1cnNhbCI6IlF1aXRvIiwiYXJlYSI6IklUIiwibmJmIjoxNzU1MTgxOTE1LCJleHAiOjE4MTgyNTM5MTUsImlhdCI6MTc1NTE4MTkxNX0.9f7qctWT-yG-cyPEymnDH2KReLtBOlZxy0ZdFT2L1aM'};
  dio.options.headers.addAll(headerRequest);
}

class Api {
  late Response response;
}

class ApiResponse {
  late int statusCode;
  late dynamic response;
  late dynamic error;
}

class Token {
  final String token;

  const Token({required this.token});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(token: json['token']);
  }
}

class APIError {
  final String timestamp;
  final int status;
  final String error;
  final String message;
  final String path;

  APIError({required this.timestamp, required this.status, required this.error, required this.message, required this.path});

  factory APIError.fromJson(Map<String, dynamic> json) {
    return APIError(timestamp: json['timestamp'], status: json['status'], error: json['error'], message: json['message'], path: json['path']);
  }
}

class KeyValuePair {
  final dynamic key;
  final dynamic value;

  KeyValuePair(this.key, this.value);

  factory KeyValuePair.fromJson(Map<String, dynamic> json) {
    return KeyValuePair(json['key'], json['value']);
  }
}
