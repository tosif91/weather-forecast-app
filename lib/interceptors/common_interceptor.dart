import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:weather_app/mixins/filter_type.dart';
import 'package:weather_app/models/base_data.dart';
import 'package:weather_app/utils/data_type.dart';

class CommonInterceptor extends Interceptor with FilterType {
  FetchDataType type;
  CommonInterceptor({@required this.type});
  @override
  Future onResponse(Response response) {
    // TODO: implement onResponse
    return super.onResponse(checkResponse(response: response, dataType: type));
  }

  @override
  Future onError(DioError err) {
    // TODO: implement onError

    return super.onError(err);
  }

  @override
  Future onRequest(RequestOptions options) {
    // TODO: implement onRequest
    print(" header => ${options.headers}");
    print("baseURL => ${options.baseUrl}");
    print("path => ${options.path}");
    print("body => ${options.data}");
    print("parameters => ${options.queryParameters}");
    return super.onRequest(options);
  }

  Response<BaseData> checkResponse(
      {@required Response response, FetchDataType dataType}) {
    BaseData returnData = BaseData();
    Response<BaseData> returnResponse = Response<BaseData>();
    print('reponse conversion in formatted data');
    if (response is Exception) {
      //this condition will not run in any condition
      returnData.message = response.data['message'];
      returnData.success = false;
    } else {
      if (response != null && response.statusCode == 200) {
        returnData.statusCode = 200;
        //we got response from server
        returnData.success = true;
        print('insied code 200 interceptor : $response');
        if (response.data == null) {
          //success[true] from server and their will be  a message regarding issues

          returnData.success = response.data['success'];
          returnData.message = response.data['message'];
        } else
          returnData.data = filterFromMap(response: response, type: dataType);
      } else {
        //this condition will not run in any condition
        response.data = null;
      }
    }
    returnResponse.data = returnData;
    return returnResponse;
  }
}
