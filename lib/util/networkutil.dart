import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class HttpUtil {

  static final String bing_geturl = 'http://guolin.tech/api/bing_pic';
  static final String default_url = 'https://cdn.pixabay.com/photo/2018/11/23/18/07/autumn-leaves-3834298_960_720.jpg';

  //get bing picture url everyday
  static Future<String> getBingImageUrl() async{
    try {
      Dio dio = new Dio();
      Response response_data = await dio.get(bing_geturl);
      return response_data.data.toString();
    }catch(exception){
      return default_url;
    }
  }
}