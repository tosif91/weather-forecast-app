import 'dart:io';
import 'package:dio/dio.dart';
import 'package:weather_app/interceptors/common_interceptor.dart';
import 'package:weather_app/models/base_data.dart';
import 'package:weather_app/utils/constants.dart';
import 'package:weather_app/utils/data_type.dart';

class ApiService {
  static BaseOptions options = new BaseOptions(
    baseUrl: baseURL,
    connectTimeout: 10000,
    receiveTimeout: 10000,
  );

  Dio _dio = new Dio(
    options,
  );

  Future<Response<BaseData>> handleGet({
    Map<String, dynamic> parameters,
    FetchDataType type,
  }) async {
    //this function returns false if exception found or response

    Response<BaseData> response = Response();
    try {
      parameters['appid'] = weatherApiKey;
      Map<String, dynamic> requiredData = await fetchCredentials(type);
      _dio.interceptors?.clear();
      _dio.interceptors.add(CommonInterceptor(type: type));
      response = await _dio.get(
        requiredData['path'],
        queryParameters: parameters,
      );
      return response;
    } catch (e) {
      print(e);
      response.data =
          BaseData(success: false, data: null, message: _setErrorMessage(e));
      return response;
    }
  }

  Map<String, dynamic> _dioHeader({String token, String sessionID}) => {
        'Authorization': token,
        'session_id': sessionID,
      };

  Future<Map<String, dynamic>> fetchCredentials(FetchDataType type) async {
    Map<String, dynamic> option = _generateUrlPath(type);

    return {
      'path': (option['path'] != null) ? option['path'] : '',
    };
  }

  Map<String, dynamic> _generateUrlPath(FetchDataType type) {
    switch (type) {
      case FetchDataType.CURRENT_WEATHER_INFO:
        return {'path': '/weather'};
      case FetchDataType.FORECAST_DATA:
        return {'path': '/forecast'};
      default:
        return {};
    }
  }

  String _setErrorMessage(DioError err) {
    switch (err.type) {
      case DioErrorType.CANCEL:
        return "please try again";
        break;
      case DioErrorType.CONNECT_TIMEOUT:
        return "oop's connection timeout";
        break;

      case DioErrorType.RECEIVE_TIMEOUT:
        return "please try again";
        break;

      case DioErrorType.DEFAULT:
        return (err.error is SocketException)
            ? "check you network connection"
            : "something went wrong";

        break;

      case DioErrorType.SEND_TIMEOUT:
        return "oop's connection timeout";
        break;

      case DioErrorType.RESPONSE:
        return "${err.response.statusMessage}";
    }
  }

  int serverError(DioError err) {
    return err.response.statusCode;
  }
}
