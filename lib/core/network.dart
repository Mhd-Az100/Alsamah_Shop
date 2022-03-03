import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;

class NetworkUtils {
  ///
  static final JsonDecoder _decoder = new JsonDecoder();

  ///
  static const baseUrl = 'https://int.waslcom.com/api/';
  static const devUrl = "https://dev-int.waslcom.com/api/";
  static const localUrl = "https://local.waslcom.com/api/";
  static const fixed_url = "https://app.alsamahco.com/api/";
  // static const fixed_url = devUrl;

  static Future<http.Response> get(
      {@required String url, Map<String, String> headers = const {}}) async {
    http.Response response;
    response = await http.get(fixed_url + url, headers: headers);
    return response;
  }

  static Future<http.Response> delete(
      {@required String url, Map<String, String> headers = const {}}) async {
    http.Response response;
    response = await http.delete(fixed_url + url, headers: headers);
    return response;
  }

  static Future<http.Response> post(
      {@required String url,
      Map<String, String> headers = const {},
      dynamic body}) async {
    http.Response response;
    response = await http.post(fixed_url + url, headers: headers, body: body);
    return response;
  }

  static Future<http.Response> put(
      {@required String url,
      Map<String, String> headers = const {},
      @required dynamic body}) async {
    http.Response response;
    response = await http.put(fixed_url + url, headers: headers, body: body);
    return response;
  }

  static Future<http.StreamedResponse> postMultipart({
    @required String url,
    Map<String, String> headers,
    Map<String, String> fields,
    Map<String, String> files,
  }) async {
    var request = http.MultipartRequest('POST', Uri.parse(fixed_url + url));
    var _filesKeyList = files.keys.toList();
    var _filesNameList = files.values.toList();
    for (int i = 0; i < _filesKeyList.length; i++) {
      if (_filesNameList[i] != "") {
        var multipartFile = http.MultipartFile.fromPath(
          _filesKeyList[i],
          _filesNameList[i],
          filename: path.basename(_filesNameList[i]),
          contentType: getContentType(_filesNameList[i]),
        );

        request.files.add(await multipartFile);
      }
    }
    request.headers.addAll(headers);
    request.fields.addAll(fields);
    http.StreamedResponse response = await request.send();
    return response;
  }

  static MediaType getContentType(String name) {
    var fileName = name.split('/').last;
    var ext = fileName.split('.').last;
    if (ext == "png" || ext == "jpeg") {
      return MediaType.parse("image/jpg");
    } else if (ext == 'pdf') {
      return MediaType.parse("application/pdf");
    } else {
      return MediaType.parse("image/jpg");
    }
  }

  ///Media link
  static const MEDIA_API = "${NetworkUtils.fixed_url}Media/File/";
}
