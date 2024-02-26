import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:retrofit_http/services.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ApiServices apiServices =
      ApiServices(Dio(BaseOptions(contentType: 'application/json')));
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("RetroFit Flutter")),
        body: FutureBuilder<List<PostModel>>(
          future: apiServices.getPosts(),
          builder: (context, snapshot) {
            print(snapshot.connectionState);
            if (snapshot.connectionState == ConnectionState.done) {
              final List<PostModel> posts = snapshot.data!;
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                        title: Text(posts[index].title.toString()),
                        subtitle: Text(posts[index].body.toString()),
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              print(snapshot.toString());
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
