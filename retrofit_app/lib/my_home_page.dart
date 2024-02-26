import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:retrofit_app/services.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PostApi client = PostApi(
    Dio(
      BaseOptions(
        contentType: "application/json",
      ),
    ),
  );

  FutureBuilder<List<Post>> _buildBody(BuildContext context) {
    return FutureBuilder<List<Post>>(
      future: client.getPosts(),
      builder: (context, snapshot) {
        print("Connection State: ${snapshot.connectionState}");

        if (snapshot.hasData) {
          final List<Post> posts = snapshot.data!;
          print("Number of Posts: ${posts.length}");
          return _buildPosts(context, posts);
        } else if (snapshot.hasError) {
          print("Error: ${snapshot.error}");
          return Center(child: Text("Error: ${snapshot.error}"));
        } else {
          print("No data available");
          return Center(child: Text("No data available"));
        }
      },
    );
  }

  Widget _buildPosts(BuildContext context, List<Post> posts) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final Post item = posts[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
              child: ListTile(
            title: Text(
              item.title ?? '',
            ),
            subtitle: Text(
              item.body?.trim() ?? '',
            ),
          )),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.refresh),
              onPressed: () {
                setState(() {});
              },
            ),
            appBar: AppBar(
              title: const Text("Retrofit Example 1"),
            ),
            body: _buildBody(context)));
  }
}
