import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:salesapp/utils/app_string.dart';
import 'package:salesapp/widget/common_snack_bar.dart';

class RestServices {
  String prefix = "app/rest/";
  String token = AppString.token;

  dynamic post(String endpoints, dynamic data, BuildContext context) async {
    String host = AppString.url;
    String url = host + prefix + endpoints;

    print("Post Url ==> $url");
    print("Token ==> $token");

    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token,
      'session': 'portal'
    };
    Options options = Options(headers: header);
    try {
      Response response = await Dio().post(url, data: data, options: options);
      if (response.statusCode == HttpStatus.ok) {
        return response;
      } else {
        return null;
      }
    } on DioError catch (e) {
      if (e.response!.statusCode == HttpStatus.notFound) {
        print("${HttpStatus.notFound} ==> ${e.message}");
        displayMessage(context, e.message);
      } else {
        print('Error ==> ${e.message}');
        displayMessage(context, "Something went wrong ${e.message}");
      }
    }
  }

  dynamic get(String endpoints, BuildContext context) async {
    String host = AppString.url;
    String url = host + prefix + endpoints;

    print("Get Url ==> $url");
    print("Token ==> $token");

    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token,
      'session': 'portal'
    };
    Options options = Options(headers: header);
    try {
      Response response = await Dio().get(url, options: options);
      if (response.statusCode == HttpStatus.ok) {
        return response;
      } else {
        return null;
      }
    } on DioError catch (e) {
      if (e.response!.statusCode == HttpStatus.notFound) {
        print("${HttpStatus.notFound} ==> ${e.message}");
        displayMessage(context, e.message);
      } else {
        print('Error ==> ${e.message}');
        displayMessage(context, "Something went wrong ${e.message}");
      }
    }
  }

  dynamic delete(String endpoints, BuildContext context) async {
    String host = AppString.url;
    String url = host + prefix + endpoints;

    print("delete Url ==> $url");

    var header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token,
      'session': 'portal'
    };

    Options options = Options(headers: header);

    try {
      Response response = await Dio().delete(url, options: options);
      if (response.statusCode == HttpStatus.ok) {
        return response;
      } else {
        return null;
      }
    } on DioError catch (e) {
      if (e.response!.statusCode == HttpStatus.notFound) {
        print("${HttpStatus.notFound} ==> ${e.message}");
        displayMessage(context, e.message);
      } else {
        print('Error ==> ${e.message}');
        displayMessage(context, "Something went wrong ${e.message}");
      }
    }
  }
}
