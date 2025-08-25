import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../data/local/shared_prefs.dart';
import '../utils/app_constants/app_constants.dart';
import 'app_url.dart';
import 'error_response.dart';

class ApiClient extends GetxService {
  static var client = http.Client();

  static const String noInternetMessage = "Can't connect to the internet!";
  static const int timeoutInSeconds = 30;

  static String bearerToken = "";

  ///================================================================Get Method============================///

  static Future<Response> getData(String uri,
      {Map<String, dynamic>? query, Map<String, String>? headers}) async {
    bearerToken = await SharePrefsHelper.getString(AppConstants.bearerToken);

    var mainHeaders = {
      // 'Content-Type': 'application/x-www-form-urlencoded',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    };
    try {
      debugPrint('====> API Call: $uri\nHeader: ${headers ?? mainHeaders}');

      http.Response response = await client
          .get(
            Uri.parse(uri),
            headers: headers ?? mainHeaders,
          )
          .timeout(const Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      debugPrint('------------>>>${e.toString()}');
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  ///================================================================patch Method============================///
  static Future<Response> patchData(
    String uri,
    dynamic body, {
    Map<String, String>? headers,
    bool isBody = true,
  }) async {
    bearerToken = await SharePrefsHelper.getString(AppConstants.bearerToken);

    var mainHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    };
    try {
      debugPrint(
          '====> API Call: ${ApiUrl.baseUrl}$uri\nHeader: ${headers ?? mainHeaders}');
      debugPrint('====> API Body: $body');

      http.Response response = await client
          .patch(
            // Uri.parse(ApiUrl.baseUrl + uri),
            Uri.parse(uri),
            body: isBody ? body : null,
            headers: headers ?? mainHeaders,
          )
          .timeout(const Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      debugPrint('Error------------${e.toString()}');

      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  ///================================================================PostMethod============================///
  static Future<Response> postData(String uri, dynamic body,
      {Map<String, String>? headers}) async {
    bearerToken = await SharePrefsHelper.getString(AppConstants.bearerToken);

    var mainHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    };
    try {
      debugPrint(
          '====> API Call: ${ApiUrl.baseUrl}$uri\nHeader: ${headers ?? mainHeaders}');
      debugPrint('====> API Body: $body');

      http.Response response = await client
          .post(
            Uri.parse(ApiUrl.baseUrl + uri),
            body: body,
            headers: headers ?? mainHeaders,
          )
          .timeout(const Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      debugPrint('Error------------${e.toString()}');

      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  //>>>>>>>>>>>>>>>>>>✅✅Post Multipart✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  static Future<Response> postMultipartData(
      String uri, Map<String, dynamic> body,
      {List<MultipartBody>? multipartBody,
      String requestType = "POST",
      Map<String, String>? headers}) async {
    try {
      bearerToken = await SharePrefsHelper.getString(AppConstants.bearerToken);

      var mainHeaders = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $bearerToken'
      };

      debugPrint('====> API Call: $uri\nHeader: ${headers ?? mainHeaders}');
      debugPrint('====> API Body: $body with ${multipartBody?.length} picture');

      var request =
          http.MultipartRequest(requestType, Uri.parse(ApiUrl.baseUrl + uri));

      // ✅ Convert `body` to `Map<String, String>`
      Map<String, String> stringBody = body.map((key, value) => MapEntry(
          key,
          value is List || value is Map
              ? jsonEncode(value)
              : value.toString()));

      request.fields.addAll(stringBody); // ✅ Now it will work

      if (multipartBody != null && multipartBody.isNotEmpty) {
        for (var element in multipartBody) {
          debugPrint("path : ${element.file.path}");

          var mimeType =
              lookupMimeType(element.file.path) ?? 'application/octet-stream';
          debugPrint("MimeType================$mimeType");

          var multipartImg = await http.MultipartFile.fromPath(
            element.key,
            element.file.path,
            contentType: MediaType.parse(mimeType),
          );
          request.files.add(multipartImg);
        }
      }

      request.headers.addAll(mainHeaders);
      http.StreamedResponse response = await request.send();
      final content = await response.stream.bytesToString();
      debugPrint('====> API Response: [${response.statusCode}] $uri\n$content');

      return Response(
          statusCode: response.statusCode,
          statusText: noInternetMessage,
          body: content);
    } catch (e) {
      debugPrint('------------${e.toString()}');

      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  //>>>>>>>>>>>>>>>>>>✅✅Patch Multipart✅✅<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  static Future<Response> patchMultipart(String uri, Map<String, dynamic> body,
      {List<MultipartBody>? multipartBody,
      String requestType = "PATCH",
      Map<String, String>? headers}) async {
    try {
      bearerToken = await SharePrefsHelper.getString(AppConstants.bearerToken);

      var mainHeaders = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $bearerToken'
      };

      debugPrint('====> API Call: $uri\nHeader: ${headers ?? mainHeaders}');
      debugPrint('====> API Body: $body with ${multipartBody?.length} picture');

      var request =
          http.MultipartRequest(requestType, Uri.parse(ApiUrl.baseUrl + uri));

      // ✅ Convert `body` to `Map<String, String>`
      Map<String, String> stringBody = body.map((key, value) => MapEntry(
          key,
          value is List || value is Map
              ? jsonEncode(value)
              : value.toString()));

      request.fields.addAll(stringBody); // ✅ Now it will work

      if (multipartBody != null && multipartBody.isNotEmpty) {
        for (var element in multipartBody) {
          debugPrint("path : ${element.file.path}");

          var mimeType =
              lookupMimeType(element.file.path) ?? 'application/octet-stream';
          debugPrint("MimeType================$mimeType");

          var multipartImg = await http.MultipartFile.fromPath(
            element.key,
            element.file.path,
            contentType: MediaType.parse(mimeType),
          );
          request.files.add(multipartImg);
        }
      }

      request.headers.addAll(mainHeaders);
      http.StreamedResponse response = await request.send();
      final content = await response.stream.bytesToString();
      debugPrint('====> API Response: [${response.statusCode}] $uri\n$content');

      return Response(
          statusCode: response.statusCode,
          statusText: noInternetMessage,
          body: content);
    } catch (e) {
      debugPrint('------------${e.toString()}');

      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  ///=============================Put data===================

  Future<Response> putData(String uri, dynamic body,
      {Map<String, String>? headers}) async {
    bearerToken = await SharePrefsHelper.getString(AppConstants.bearerToken);

    var mainHeaders = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $bearerToken'
    };
    try {
      debugPrint('====> API Call: $uri\nHeader: ${headers ?? mainHeaders}');
      debugPrint('====> API Body: $body');

      http.Response response = await http
          .put(
            Uri.parse(ApiUrl.baseUrl + uri),
            body: jsonEncode(body),
            headers: headers ?? mainHeaders,
          )
          .timeout(const Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  static Future<Response> deleteData(
    String uri, {
    Map<String, String>? headers,
  }) async {
    bearerToken = await SharePrefsHelper.getString(AppConstants.bearerToken);

    var mainHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken', // FIX: add Bearer
    };
    try {
      debugPrint('====> API Call: $uri\nHeader: ${headers ?? mainHeaders}');
      // debugPrint('====> API Call: $uri\n Body: $body');

      http.Response response = await http
          .delete(
            Uri.parse(uri),
            // Uri.parse(ApiUrl.baseUrl + uri),
            headers: headers ?? mainHeaders,
          )
          .timeout(const Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  static Response handleResponse(http.Response response, String uri) {
    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (e) {
      debugPrint(e.toString());
    }
    Response response0 = Response(
      body: body ?? response.body,
      bodyString: response.body.toString(),
      request: Request(
          headers: response.request!.headers,
          method: response.request!.method,
          url: response.request!.url),
      headers: response.headers,
      statusCode: response.statusCode,
      statusText: response.reasonPhrase,
    );

    if (response0.statusCode != 200 &&
        response0.body != null &&
        response0.body is! String) {
      ErrorResponse errorResponse = ErrorResponse.fromJson(response0.body);
      response0 = Response(
          statusCode: response0.statusCode,
          body: response0.body,
          statusText: errorResponse.message);
    } else if (response0.statusCode != 200 && response0.body == null) {
      response0 = const Response(statusCode: 0, statusText: noInternetMessage);
    }

    debugPrint(
        '====> API Response: [${response0.statusCode}] $uri\n${response0.body}');
    // log.e("Handle Response error} ");
    return response0;
  }
}

class MultipartBody {
  String key;
  File file;

  MultipartBody(this.key, this.file);
}

class MultipartListBody {
  String key;
  String value;
  MultipartListBody(this.key, this.value);
}
