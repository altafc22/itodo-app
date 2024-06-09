import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:itodo/common/errors/exceptions.dart';
import 'package:itodo/common/extensions/app_extension.dart';
import 'package:itodo/common/network/api_config.dart';
import 'package:itodo/common/utils/log_utils.dart';

enum HttpMethod {
  get,
  post,
  put,
  patch,
  delete,
}

class ApiClient {
  final String baseUrl;

  final jsonEncoder = const JsonEncoder.withIndent('  ');
  ApiClient({required this.baseUrl});

  Future<http.Response> get({
    required String endpoint,
    String? newBaseUrl,
  }) async {
    final url = Uri.parse(newBaseUrl ?? baseUrl + endpoint);
    final header = await _getHeader();
    return await _request(HttpMethod.get, url, headers: header);
  }

  Future<http.Response> post({
    required String endpoint,
    String? newBaseUrl,
    Object? body,
  }) async {
    try {
      final url = Uri.parse(newBaseUrl ?? baseUrl + endpoint);
      final header = await _getHeader();
      var response = await _request(
        HttpMethod.post,
        url,
        headers: header,
        body: body,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> put({
    required String endpoint,
    String? newBaseUrl,
    Object? body,
  }) async {
    final url = Uri.parse(newBaseUrl ?? baseUrl + endpoint);
    final header = await _getHeader();
    return await _request(
      HttpMethod.put,
      url,
      body: jsonEncode(body),
      headers: header,
    );
  }

  Future<http.Response> patch({
    required String endpoint,
    String? newBaseUrl,
    Object? body,
  }) async {
    final url = Uri.parse(newBaseUrl ?? baseUrl + endpoint);
    final header = await _getHeader();
    return await _request(
      HttpMethod.patch,
      url,
      headers: header,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> delete({
    required String endpoint,
    String? newBaseUrl,
  }) async {
    final url = Uri.parse(newBaseUrl ?? baseUrl + endpoint);
    final header = await _getHeader();
    return await _request(
      HttpMethod.delete,
      url,
      headers: header,
    );
  }

  _getHeader() async {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${ApiConfig.token}',
      'Accept': "*/*"
    };
  }

  Future<http.Response> _request(HttpMethod method, Uri url,
      {Object? body, Map<String, String>? headers}) async {
    try {
      printInfo('----------------------START----------------------');
      printInfo('method => ${method.name}');
      printInfo('request => $url');

      if (headers != null) {
        final authorization = headers['Authorization'];
        final contentType = headers['Content-Type'];
        printInfo('authorization  =>  $authorization');
        printInfo('Content-Type  =>  $contentType');
      }

      http.Response response;
      switch (method) {
        case HttpMethod.get:
          response = await http.get(url, headers: headers);
          break;
        case HttpMethod.post:
          response = await http.post(url, headers: headers, body: body);
          break;
        case HttpMethod.put:
          response = await http.put(url, headers: headers, body: body);
          break;
        case HttpMethod.patch:
          response = await http.patch(url, headers: headers, body: body);
          break;
        case HttpMethod.delete:
          response = await http.delete(url, headers: headers);
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }

      printInfo('payload => $body');
      if (response.statusCode.success) {
        printInfo('---------------------RECEIVED--------------------');
        printInfo('method => ${method.name}');
        printInfo('status code => ${response.statusCode}');
        printInfo('contentLength => ${response.contentLength}');

        printInfo('payload => ${response.body}');
      } else {
        printError('---------------------ERROR----------------------');
        printError('method => ${method.name}');
        printError('status code => ${response.statusCode}');
        printError('contentLength => ${response.contentLength}');
        printError('payload => ${response.body}');
      }
      //printInfo('----------------------END-----------------------');

      return response;
    } on SocketException catch (e) {
      printError('---------------------ERROR----------------------');
      printError('error => ${e.message}');
      throw ServerException(e.message);
    } catch (e) {
      printError('---------------------ERROR----------------------');
      printError('Exception => ${e.toString()}');
      //printError('----------------------END-----------------------');
      rethrow;
    }
  }
}
