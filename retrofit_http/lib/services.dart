import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:retrofit/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/http.dart';

part 'services.g.dart';

@RestApi(baseUrl: "https://jsonplaceholder.typicode.com/")
abstract class ApiServices {
  static Dio dio = Dio();

  ApiServices() {
    dio.options.connectTimeout = Duration(minutes: 15); // 15 * 60 * 1000;
    dio.options.receiveTimeout = Duration(minutes: 15); // 15 * 60 * 1000;
    dio.options.sendTimeout = Duration(minutes: 15); // 15 * 60 * 1000;

    dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) =>
            requestInterceptor(options, handler, true),
        onResponse: (response, handler) => responseInterceptor(response, handler),
        onError: (dioError, handler) => errorInterceptor(dioError, handler)));
  }

  factory ApiServices(Dio dio, {String baseUrl}) = _ApiServices;

  @GET("posts")
  Future<List<PostModel>> getPosts();
}

void requestInterceptor(RequestOptions options,
    RequestInterceptorHandler handler, bool isAuth) async {
  if (options.headers != null) {
    printMessage(options.headers);
  }

  await Future.delayed(Duration(milliseconds: 100));
  if (options.data != null && options.data != '') {
    if (options.data is FormData) {
      handler.next(options);
      return;
    }
  }
  handler.next(options);
}

void printMessage(var msg) {
  print(msg);
}

void responseInterceptor(Response options, ResponseInterceptorHandler handler) {
  if (options.data != null && options.data != '') {
    if (options.data.toString().contains("UserDto")) {
      handler.next(options);
      return;
    }
    var data = json.encode(options.data);
    printMessage(data);
  }
  handler.next(options);
}

// ignore: deprecated_member_use
void errorInterceptor(DioError options, ErrorInterceptorHandler handler) {
  handler.next(options);
}

@JsonSerializable()
class PostModel {
  int? userId;
  int? id;
  String? title;
  String? body;

  PostModel({this.userId, this.id, this.title, this.body});

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
  Map<String, dynamic> toJson() => _$PostModelToJson(this);
}
