import 'dart:async';
import 'dart:convert';
import 'dart:io' as IO;
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {
  late Dio dio;

  static DioClient? _instance;

  DioClient._({Dio? client}){
    if(client != null) {
      dio = client;
    }else {
      dio = getDio();
    }
  }

  factory DioClient({Dio? client}) => _instance ??= DioClient._(client: client);

  Future<dynamic> get(String url, {dynamic parameters, String? token}) async {
    try {
      Response response = await dio.get(url, queryParameters: parameters);
      return responseDecode(response);
    } on DioException catch (e) {
      throwError(e);
    }
  }

  Future<dynamic> post(String url, {dynamic parameters, dynamic body, String? token}) async {
    try {
      Response response = await dio.post(url, queryParameters: parameters, data: body);
      return responseDecode(response);
    } on DioException catch (e) {
      throwError(e);
    }
  }

  Future<dynamic> patch(String url, {dynamic parameters, dynamic body, String? token}) async {
    try {
      Response response = await dio.patch(url, queryParameters: parameters, data: body);
      return responseDecode(response);
    } on DioException catch (e) {
      throwError(e);
    }
  }

  Future<dynamic> upload(String url, {dynamic body, String? token}) async {
    try {
      Response response = await dio.post(url, data: FormData.fromMap(body));
      return responseDecode(response);
    } on DioException catch (e) {
      throwError(e);
    }
  }

  static Dio getDio({String? token, String? baseUrl}) {
    Dio _dio = Dio(BaseOptions(
      baseUrl: baseUrl ?? '',
      headers: {'Authorization': 'Bearer $token'},
      contentType: "application/json",
      connectTimeout: const Duration(milliseconds: 150000),
      receiveTimeout: const Duration(milliseconds: 150000),
      followRedirects: false,
      validateStatus: (status) {
        return status! < 500;
      },
    ));
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
    (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (IO.HttpClient client) {
      client.badCertificateCallback =
          (IO.X509Certificate cert, String host, int port) => true;
    };
    return _dio;
  }

  static dynamic responseDecode(Response response) {
    try {
      var responseJson = json.decode(response.toString());
      switch (response.statusCode) {
        case 200:
        case 201:
        case 412:
          return responseJson;
        case 401:
          throw throwResponseError(response);
        case 403:
        case 404:
        case 417:
        case 422:
        case 500:
        case 503:
          throw throwResponseError(response);
        default:
          throw throwResponseError(response);
      }
    } catch (e) {
      debugPrint(e.toString());
      throw e.toString();
    }
  }

  static void throwError(DioException e) {
    if (e.error is SocketException) {
      throw "Check your internet connection";
    } else {
      if(e.response != null) {
        throw e.response?.statusMessage ?? 'Something went wrong';
      } else {
        throw e.error.toString();
      }
    }
  }

  static dynamic throwResponseError(Response<dynamic> response) {
    try {
      var responseJson = json.decode(response.toString());
      return responseJson;
    }  on DioException catch (e) {
      throwError(e);
    } catch (e) {
      throw e.toString();
    }
  }
}
