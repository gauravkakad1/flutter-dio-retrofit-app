import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

part 'services.g.dart';

@RestApi(baseUrl: 'https://jsonplaceholder.typicode.com')
abstract class PostApi {
  factory PostApi(Dio dio, {String baseUrl}) = _PostApi;

  @GET('/posts')
  Future<List<Post>> getPosts();

  // @GET('/post/{id}')
  // Future<Post> getPostByID({
  //   @Path('id') required int id,
  // });
}

Future<List<Post>> getPosts() async {
  try {
    final response = await getPosts(); // Use the actual method name
    return response
        .map((json) => Post.fromJson(json as Map<String, dynamic>))
        .toList();
  } catch (e) {
    print("Dio Error: $e");
    throw e;
  }
}

@JsonSerializable()
class Post {
  Post({
    this.userId,
    this.id,
    this.title,
    this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  int? userId;
  int? id;
  String? title;
  String? body;

  Map<String, dynamic> toJson() => _$PostToJson(this);
}
