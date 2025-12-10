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

enum AppUidEnum{
  CoreAgent,
  CoreUser,
  i4WeAgent,
  i4WeMember,
}
enum EnvTypeEnum{
  CORE_DEV,
  CORE_STAGE,
  CORE_PROD,
  I4WE_DEV,
  I4WE_STAGE,
  I4WE_PROD,
}
class BaseUrl {
  static String baseDevURL = "https://core-dev.cmedhealth.com/";
  static String baseStageURL = "https://core-stage.cmedhealth.com/";
  static String baseBetaURL = "https://dhc-beta.cmedhealth.com/";
  static String baseProdURL = "https://core-prod.cmedhealth.com/";
  static String baseSwastiDevURL = "https://core-dev.cmedhealth.com/";
  static String baseSwastiStageURL = "https://core-stage.cmedhealth.com/";
  static String baseSwastiProdURL = "https://i4we-prod.cmedhealth.com/";
}

class HttpProvider {
  final AppUidEnum appUid;
  final RapidEnvConfig appEnvConfig = Get.find();
  final RapidPreferenceStore preferenceStore = Get.find();
  final RapidGlobalStateLogic globalState = Get.find();
  final accesTokenKey = "access_token";
  late final dio.Dio dioClient;
  dio.CancelToken requestToken = dio.CancelToken();

  //cmed app
  static const CORE_USER_ANDROID_VERSION_KEY= 'x-supported-min-android-cmed-user-app-version';
  static const CORE_USER_ANDROID_STORE_URL= 'https://play.google.com/store/apps/details?id=com.cmedhealth.android';

  static const CORE_USER_IOS_VERSION_KEY = 'x-supported-min-ios-cmed-user-app-version';
  static const CORE_USER_IOS_STORE_URL = 'https://apps.apple.com/us/app/cmed-health/id1505328545';

  static const CORE_AGENT_ANDROID_VERSION_KEY= 'x-supported-min-android-cmed-agent-app-version:';
  static const CORE_AGENT_ANDROID_STORE_URL= 'https://play.google.com/store/apps/details?id=bd.com.cmed.agent';

  static const CORE_AGENT_IOS_VERSION_KEY = 'x-supported-min-ios-cmed-agent-app-version';
  static const CORE_AGENT_IOS_STORE_URL = '';


  //i4we app
  static const I4WE_USER_ANDROID_VERSION_KEY= 'x-supported-min-android-i4we-member-app-version';
  static const I4WE_USER_ANDROID_STORE_URL= 'https://play.google.com/store/apps/details?id=com.cmedhealth.app.i4wemember';

  static const I4WE_USER_IOS_VERSION_KEY = 'x-supported-min-ios-i4we-member-app-version';
  static const I4WE_USER_IOS_STORE_URL = '';

  static const I4WE_AGENT_ANDROID_VERSION_KEY= 'x-supported-min-android-i4we-agent-app-version';
  static const I4WE_AGENT_ANDROID_STORE_URL= 'https://play.google.com/store/apps/details?id=bd.com.cmed.i4weagent';

  static const I4WE_AGENT_IOS_VERSION_KEY = 'x-supported-min-ios-i4we-agent-app-version';
  static const I4WE_AGENT_IOS_STORE_URL = '';

  HttpProvider({required this.appUid}) {
    print('${appEnvConfig.baseUrl} is set as baseurl');
    RLog.info(
      '╔══════════════════════════ Server ══════════════════════════\n'
      'BASE_URL ║ ${appEnvConfig.baseUrl}\n'
      'TOKEN ║ ${preferenceStore.read(accesTokenKey)}'
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
      dioClient.options.headers["Authorization"] = "Bearer ${token ?? preferenceStore.read(accesTokenKey)}";
    } else {
      dioClient.options.headers.remove("Authorization");
    }

    try {
      final response = await dioClient.get(path, queryParameters: data);
      if (checkForceUpdate) {
        checkForceUpdateFromResponse(response);
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
        ? "Bearer ${token ?? preferenceStore.read(accesTokenKey)}"
        : null;
    try {
      print("Sending POST request to $path with data: $data");
      var response = await dioClient.post(path, data: data);
      print("Response received: ${response.statusCode}");

      if (checkForceUpdate) {
        checkForceUpdateFromResponse(response);
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
        ? "Bearer ${token ?? preferenceStore.read(accesTokenKey)}"
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
        checkForceUpdateFromResponse(response);
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
        ? "Bearer ${token ?? preferenceStore.read(accesTokenKey)}"
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
        checkForceUpdateFromResponse(response);
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
        ? "Bearer ${token ?? preferenceStore.read(accesTokenKey)}"
        : null;
    try {
      var response = await dioClient.patch(path, data: data);
      if (checkForceUpdate) {
        checkForceUpdateFromResponse(response);
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
        ? "Bearer ${token ?? preferenceStore.read(accesTokenKey)}"
        : null;
    try {
      var response = await dioClient.delete(path, data: data);
      if (checkForceUpdate) {
        checkForceUpdateFromResponse(response);
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

  void checkForceUpdateFromResponse(dio.Response response) {
    String versionKey = AppVersionKey();
    if ((response.headers.map.containsKey(versionKey))) {
      int serverAppVersionCode = int.parse(response.headers.map[versionKey]![0]);
      AppInfo.getVersionNumber().then((value) {
        int deviceAppVersionCode = int.parse(value.replaceAll(".", ""));
        RLog.info('deviceVersion:$deviceAppVersionCode-serverVersion:$serverAppVersionCode');
        if (deviceAppVersionCode < serverAppVersionCode) {
          showVersionUpdateDialog(serverAppVersionCode, deviceAppVersionCode);
        }
      });
    }
  }

  Future<Response<ContentResponseDto?>> receiveLabReportFile(
    String path, {
    bool requiredBearerToken = true,
    String? token,
  }) async {
    try {
      dioClient.options.headers["Authorization"] = requiredBearerToken
          ? "Bearer ${token ?? preferenceStore.read(accesTokenKey)}"
          : null;
      final response = await dioClient.get(path);
      if (response.statusCode == 200) {
        final decodedData = ContentResponseDto.fromJson(response.data);
        return Response<ContentResponseDto?>(body: decodedData, statusCode: response.statusCode);
      } else {
        return Response<ContentResponseDto?>(
          body: null,
          statusCode: response.statusCode,
          //errorMessage: response.data.toString(),
        );
      }
    } on dio.DioException catch (e) {
      final errorMsg = handleDioError(e);
      return Response<ContentResponseDto?>(
        body: null,
        statusCode: e.response?.statusCode ?? 500,
        // errorMessage: errorMsg,
      );
    } catch (e, stackTrace) {
      RLog.error('Error: $e\nStack Trace: $stackTrace\nPath: $path');
      return const Response<ContentResponseDto?>(
        body: null,
        statusCode: 500,
        // errorMessage: 'An unexpected error occurred.',
      );
    }
  }

  String AppVersionKey() {
    if(appUid == AppUidEnum.CoreUser) {
      if (Platform.isIOS) {
        return CORE_USER_IOS_VERSION_KEY;
      }
      return CORE_USER_ANDROID_VERSION_KEY;
    }
    else if(appUid == AppUidEnum.CoreAgent) {
      if (Platform.isIOS) {
        return CORE_AGENT_IOS_VERSION_KEY;
      }
      return CORE_AGENT_ANDROID_VERSION_KEY;
    }
    else if(appUid == AppUidEnum.i4WeMember) {
      if (Platform.isIOS) {
        return I4WE_USER_IOS_VERSION_KEY;
      }
      return I4WE_USER_ANDROID_VERSION_KEY;
    }
    else if(appUid == AppUidEnum.i4WeAgent) {
      if (Platform.isIOS) {
        return I4WE_AGENT_IOS_VERSION_KEY;
      }
      return I4WE_AGENT_ANDROID_VERSION_KEY;
    }
    return "";
  }

  String AppStoreUrl() {
    if(appUid == AppUidEnum.CoreUser) {
      if (Platform.isIOS) {
        return CORE_USER_IOS_STORE_URL;
      }
      return CORE_USER_ANDROID_STORE_URL;
    }
    else if(appUid == AppUidEnum.CoreAgent) {
      if (Platform.isIOS) {
        return CORE_AGENT_IOS_STORE_URL;
      }
      return CORE_AGENT_ANDROID_STORE_URL;
    }
    else if(appUid == AppUidEnum.i4WeMember) {
      if (Platform.isIOS) {
        return I4WE_USER_IOS_STORE_URL;
      }
      return I4WE_USER_ANDROID_STORE_URL;
    }
    else if(appUid == AppUidEnum.i4WeAgent) {
      if (Platform.isIOS) {
        return I4WE_AGENT_IOS_STORE_URL;
      }
      return I4WE_AGENT_ANDROID_STORE_URL;
    }
    return "";
  }

  void showVersionUpdateDialog(int updatedAppVersionCode, int currentAppVersionCode) {
    RLog.error("currentAppVersionCode:$currentAppVersionCode, updatedAppVersionCode:$updatedAppVersionCode");
    if (currentAppVersionCode < updatedAppVersionCode && Platform.isAndroid) {
      Get.defaultDialog(
        title: Platform.isIOS ? 'message_new_apple_app'.tr : 'message_new_android_app'.tr,
        barrierDismissible: false,
        radius: 0,
        titlePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        //titleStyle: CMEDTextUtils.alertTitleTextStyle,
        content: WillPopScope(
          onWillPop: () async => false, // Disables back button
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 10),
                  Container(
                    width: double.infinity,
                    child: FrElevatedButton(
                      name:'label_update'.tr,
                      onPressed: () async{
                        await launchUrl(Uri.parse(AppStoreUrl()));
                      },
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(Get.context!).primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 10,
                        padding: EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Rounded corners
                        ),
                        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    )
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ],
          ),
        ),
      );
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


class ContentResponseDto {
  String? content;

  ContentResponseDto({this.content});

  ContentResponseDto.fromJson(Map<String, dynamic> json) {
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['content'] = content;
    return data;
  }
}

