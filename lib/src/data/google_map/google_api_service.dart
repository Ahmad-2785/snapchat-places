import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class GoogleApiService {
  Dio? _dio;
  String tag = "Google API :";
  static final Dio mDio = Dio();


  Dio initApiServiceDio() {
    final baseOption = BaseOptions(
      connectTimeout: const Duration(seconds: 45 * 1000),
      receiveTimeout: const Duration(seconds: 45 * 1000),
      baseUrl: 'https://maps.googleapis.com/maps/api/place/',
      contentType: 'application/json',
    );
    mDio.options = baseOption;

    final mInterceptorsWrapper =
        InterceptorsWrapper(onRequest: (options, handler) {
      debugPrint(
          "$tag ${options.method} "
          "${options.baseUrl.toString() + options.path}",
          wrapWidth: 1024);

      debugPrint("$tag ${options.headers.toString()}", wrapWidth: 1024);
      debugPrint("$tag ${options.queryParameters.toString()}", wrapWidth: 1024);
      debugPrint("$tag ${options.data.toString()}", wrapWidth: 1024);
      return handler.next(options); //continue
    }, onResponse: (response, handler) {
      debugPrint("Code  ${response.statusCode.toString()}", wrapWidth: 1024);
      debugPrint("Response ${response.toString()}", wrapWidth: 1024);
      return handler.next(response); // continue
    }, onError: (DioError e, handler) {
      debugPrint("$tag ${e.error.toString()}", wrapWidth: 1024);
      debugPrint("$tag ${e.response.toString()}", wrapWidth: 1024);
      return handler.next(e); //continue
    });

    mDio.interceptors.add(mInterceptorsWrapper);
    return mDio;
  }

  Future<Response> get(
    String endUrl,
    BuildContext context, {
    Map<String, dynamic>? params,
    Options? options,
  }) async {
    try {
      var isConnected = await checkInternet();
      if (!isConnected) {
        return Future.error("Internet not connected");
      }
      return await (_dio!.get(
        endUrl,
        queryParameters: params,
        options: options,
      ));
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectionTimeout) {
        return Future.error("Poor internet connection");
      }
      rethrow;
    }
  }

  Future<bool> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  Future getf() async {
    const String url = 'https://places.googleapis.com/v1/places:searchNearby';
    const String apiKey = 'AIzaSyAuiY-se4dvIZJNPHFGlkR42DqfxC-BLUg';
    final Map<String, dynamic> data = {
      'includedTypes': ['restaurant'],
      'maxResultCount': 10,
      'locationRestriction': {
        'circle': {
          'center': {'latitude': 37.7937, 'longitude': -122.3965},
          'radius': 500.0,
        },
      },
    };
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': apiKey,
      'X-Goog-FieldMask': 'places.displayName',
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return response;
    } catch (e) {
      print('Error: $e');
    }
  }
}
