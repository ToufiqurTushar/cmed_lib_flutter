import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_rapid/flutter_rapid.dart';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter_rapid/logic/rapid_global_state_logic.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cmed_lib_flutter/common/helper/app_info.dart';

class BaseUrl {
  static String baseDevURL = "https://core-dev.cmedhealth.com/";
  static String baseStageURL = "https://core-stage.cmedhealth.com/";
  static String baseBetaURL = "https://dhc-beta.cmedhealth.com/";
  static String baseProdURL = "https://core-prod.cmedhealth.com/";
  static String baseSwastiDevURL = "https://core-dev.cmedhealth.com/";
  static String baseSwastiStageURL = "https://core-stage.cmedhealth.com/";
  static String baseSwastiProdURL = "https://i4we-prod.cmedhealth.com/";
}

class Http {
  final RapidEnvConfig appEnvConfig = Get.find();
  final RapidPreferenceStore preferenceStore = Get.find();
  final RapidGlobalStateLogic globalState = Get.find();
  late final dio.Dio dioClient;
  dio.CancelToken requestToken = dio.CancelToken();

  Http() {
    preferenceStore.save('accessToken', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX25hbWUiOiJjaGVfdGVzdGk0d2UxIiwibGFzdF9uYW1lIjpudWxsLCJhdXRob3JpdGllcyI6WyJBQ0NFU1NfVVNFUl9SRVNPVVJDRVMiLCJBQ0NFU1NfQUdFTlRfQVBQIiwiQUNDRVNTX0NIRSIsIk1FQVNVUkVfVVNFUl9WSVRBTFMiXSwiY2xpZW50X2lkIjoiY2xpZW50X2lkIiwiYXVkIjpbIm9hdXRoMi1yZXNvdXJjZSJdLCJwaG9uZSI6IjkxMjM0NTY3ODgiLCJzY29wZSI6WyJyZWFkIiwid3JpdGUiLCJ0cnVzdCJdLCJpZCI6NDMwMTAwMCwiZXhwIjoxNzY2NzgxNTUxLCJmaXJzdF9uYW1lIjoiVGVzdCBpNFdlIENIRSIsImp0aSI6IjFkYWRlYmY0LWIxYzEtNDgxZi05NTE3LTZiZjk4M2Y3NDdjYyIsImVtYWlsIjoicmFzZWxAY21lZGhlYWx0aC5jb20iLCJ1c2VybmFtZSI6ImNoZV90ZXN0aTR3ZTEifQ.ynqSGSZxw_gj4hbZEnohL9ap244aRBIadFGA7Cz1t_Y');
    print('${appEnvConfig.baseUrl} is set as baseurl');
    RLog.info(
      '╔══════════════════════════ Server ══════════════════════════\n'
      'BASE_URL ║ ${appEnvConfig.baseUrl}\n'
      'TOKEN ║ ${preferenceStore.read('accessToken')}'
      '\n╚══════════════════════════ Server ══════════════════════════',
    );
    dioClient = dio.Dio(
      dio.BaseOptions(
        baseUrl: appEnvConfig.baseUrl,
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Headers': '*',
        },
        connectTimeout: const Duration(seconds: 100),
        receiveTimeout: const Duration(seconds: 100),
      ),
    )..interceptors.addAll([NetworkAndLoggingInterceptor(requestToken), ChuckerDioInterceptor()]);
  }

  Future<Response> GET(
    String path, {
    dynamic data,
    bool requiredBearerToken = true,
    String? token,
    bool checkForceUpdate = false,
  }) async {
    // Add token only if `requiredBearerToken` is true
    if (requiredBearerToken) {
      dioClient.options.headers["Authorization"] = "Bearer ${token ?? preferenceStore.read('accessToken')}";
    } else {
      dioClient.options.headers.remove("Authorization");
    }

    try {
      final response = await dioClient.get(path, queryParameters: data);
      if (checkForceUpdate) {

      }
      return Response(body: response.data, statusCode: response.statusCode);
    } on dio.DioException catch (e) {
      final errorMsg = handleDioError(e);
      return Response(body: errorMsg, statusCode: e.response?.statusCode);
    }
  }

  Future<Response> POST(
    String path,
    data, {
    bool requiredBearerToken = true,
    String? token,
    bool checkForceUpdate = false,
  }) async {
    dioClient.options.headers["Authorization"] = requiredBearerToken
        ? "Bearer ${token ?? preferenceStore.read('accessToken')}"
        : null;
    try {
      print("Sending POST request to $path with data: $data");
      var response = await dioClient.post(path, data: data);
      print("Response received: ${response.statusCode}");

      if (checkForceUpdate) {

      }
      if (response.statusCode == 200) {
        return Response(body: response.data, statusCode: 200);
      } else {
        return Response(body: response.data, statusCode: response.statusCode);
      }
    } on dio.DioException catch (e) {
      final errorMsg = handleDioError(e);
      return Response(body: errorMsg, statusCode: e.response?.statusCode);
    }
  }

  Future<Response> POST_FILE(
    String path,
    String filePath, {
    bool requiredBearerToken = true,
    String? token,
    bool checkForceUpdate = false,
  }) async {
    dioClient.options.headers["Authorization"] = requiredBearerToken
        ? "Bearer ${token ?? preferenceStore.read('accessToken')}"
        : null;

    try {
      File file = File(filePath);
      if (!await file.exists()) {
        print("File does not exist at path: $filePath");
        return const Response(body: "File does not exist", statusCode: 400);
      }

      print("Sending POST request to $path with file: $filePath");
      String fileName = file.uri.pathSegments.last;

      final formData = dio.FormData.fromMap({
        'name': 'dio',
        'date': DateTime.now().toIso8601String(),
        'file': await dio.MultipartFile.fromFile(filePath, filename: fileName),
      });

      var response = await dioClient.post(path, data: formData);

      print("Response received: ${response.statusCode}");
      if (checkForceUpdate) {

      }
      if (response.statusCode == 200) {
        return Response(body: response.data, statusCode: 200);
      } else {
        return Response(body: response.data, statusCode: response.statusCode);
      }
    } on dio.DioException catch (e) {
      final errorMsg = handleDioError(e);
      return Response(body: errorMsg, statusCode: e.response?.statusCode ?? 500);
    }
  }

  Future<Response> POST_IMAGE(
    String path,
    String filePath, {
    bool requiredBearerToken = true,
    String? token,
    bool checkForceUpdate = false,
    // required String namespace,
  }) async {
    dioClient.options.headers["Authorization"] = requiredBearerToken
        ? "Bearer ${token ?? preferenceStore.read('accessToken')}"
        : null;

    try {
      File file = File(filePath);
      if (!await file.exists()) {
        print("File does not exist at path: $filePath");
        return const Response(body: "File does not exist", statusCode: 400);
      }

      // Extract file name from the local path
      final fileName = DateTime.now().toIso8601String() + file.uri.pathSegments.last;
      final pureName = fileName.split('.').first;

      // Only file goes inside formData
      final formData = dio.FormData.fromMap({'file': await dio.MultipartFile.fromFile(filePath, filename: fileName)});

      // Attach query params (using extracted fileName)
      final url = "$path?filename=$pureName&namespace=$fileName";

      var response = await dioClient.post(url, data: formData);

      if (checkForceUpdate) {

      }

      return Response(body: response.data, statusCode: response.statusCode);
    } on dio.DioException catch (e) {
      final errorMsg = handleDioError(e);
      return Response(body: errorMsg, statusCode: e.response?.statusCode ?? 500);
    }
  }

  Future<Response> PATCH(
    String path,
    data, {
    bool requiredBearerToken = true,
    String? token,
    bool checkForceUpdate = false,
  }) async {
    dioClient.options.headers["Authorization"] = requiredBearerToken
        ? "Bearer ${token ?? preferenceStore.read('accessToken')}"
        : null;
    try {
      var response = await dioClient.patch(path, data: data);
      if (checkForceUpdate) {

      }
      if (response.statusCode == 200) {
        return Response(body: response.data, statusCode: 200);
      } else {
        return Response(body: response.data, statusCode: response.statusCode);
      }
    } on dio.DioException catch (e) {
      final errorMsg = handleDioError(e);
      return Response(body: errorMsg, statusCode: e.response?.statusCode);
    }
  }

  Future<Response> DELETE(
    String path, {
    data,
    bool requiredBearerToken = true,
    String? token,
    bool checkForceUpdate = false,
  }) async {
    dioClient.options.headers["Authorization"] = requiredBearerToken
        ? "Bearer ${token ?? preferenceStore.read('accessToken')}"
        : null;
    try {
      var response = await dioClient.delete(path, data: data);
      if (checkForceUpdate) {

      }
      if (response.statusCode == 200) {
        return Response(body: response.data, statusCode: 200);
      } else {
        return Response(body: response.data, statusCode: response.statusCode);
      }
    } on dio.DioException catch (e) {
      final errorMsg = handleDioError(e);
      return Response(body: errorMsg, statusCode: e.response?.statusCode);
    }
  }
}

class NetworkAndLoggingInterceptor extends dio.Interceptor {
  final dio.CancelToken requestToken;
  NetworkAndLoggingInterceptor(this.requestToken);

  final RapidGlobalStateLogic globalState = Get.find();

  Future checkNetworkAndLogging(dio.RequestOptions requestOptions, dio.RequestInterceptorHandler handler) async {
    log('╔══════════════════════════ Request ${requestOptions.method.toUpperCase()} ══════════════════════════');
    log('REQUEST API  ║ ${requestOptions.path}');
    try {
      log('REQUEST DATA ║ ${jsonEncode(requestOptions.data)}');
    } catch (e) {
      log('REQUEST DATA ║ ${e}\n');
    }
    log('╚═════════════════════════════════════════════════════════════════');

    return super.onRequest(requestOptions, handler);

    // var connectivityResult = await (Connectivity().checkConnectivity());
    // if (
    //     connectivityResult.contains(ConnectivityResult.mobile) ||
    //     connectivityResult.contains(ConnectivityResult.wifi) ||
    //     connectivityResult.contains(ConnectivityResult.ethernet)
    // ){
    //   log('REQUEST API  ║ ${requestOptions.path}');
    //   return super.onRequest(requestOptions, handler);
    // } else {
    //   requestToken.cancel('message_no_internet'.tr);
    //   globalState.hideBusy();
    //   handler.next(requestOptions);
    // }
  }

  @override
  void onRequest(dio.RequestOptions requestOptions, dio.RequestInterceptorHandler handler) {
    checkNetworkAndLogging(requestOptions, handler);
  }

  @override
  void onResponse(dio.Response response, dio.ResponseInterceptorHandler handler) {
    RLog.warning(
      '══════════════════════════ Response ${response.requestOptions.method} (${response.statusCode}) ══════════════════════════\n'
      'REQUEST URL   ║ ${response.requestOptions.uri}\n'
      'REQUEST DATA  ║ ${response.requestOptions.data}\n'
      'RESPONSE BODY ║ ${response.data?.toString() ?? ''}',
    );
    try {
      log('RESPONSE BODY ║ ${response.data ?? ''}\n');
    } catch (e) {
      log('RESPONSE BODY ║ ${e}\n');
    }

    return super.onResponse(response, handler);
  }

  @override
  void onError(dio.DioException error, dio.ErrorInterceptorHandler handler) {
    return super.onError(error, handler);
  }
}

String handleDioError(dio.DioException error) {
  RLog.error(
    '╔══════════════════════════ Response ══════════════════════════\n'
    'REQUEST URL ║ ${error.response?.requestOptions.uri}\n'
    'STATUS_CODE ║ ${error.response?.statusCode}\n'
    'DATA ║ ${error.response?.toString() ?? ''}'
    '\n╚══════════════════════════ Response ══════════════════════════',
  );
  switch (error.type) {
    case dio.DioExceptionType.connectionTimeout:
    case dio.DioExceptionType.sendTimeout:
    case dio.DioExceptionType.receiveTimeout:
      return "Timeout occurred!";
    case dio.DioExceptionType.badResponse:
      final statusCode = error.response?.statusCode;
      if (statusCode != null) {
        switch (statusCode) {}
      }
      break;
    case dio.DioExceptionType.cancel:
      break;
    case dio.DioExceptionType.unknown:
      return "No Internet Connection";
    case dio.DioExceptionType.badCertificate:
      return "Internal Server Error";
    case dio.DioExceptionType.connectionError:
      return "message_no_internet".tr;
  }
  return error.response?.toString() ?? '';
}
