import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:testing/Model/PostsModel.dart';
import 'package:http/http.dart ' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<PostsModel> postList = [];

  Future<List<PostsModel>> getPostApi() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));
    var data = jsonDecode(
      response.body.toString(),
    );
    if (response.statusCode == 200) {
      for (Map i in data) {
        postList.add(PostsModel.fromJson(i));
      }
      return postList;
    } else {
      return postList;
    }
  }

  Future<void> refreshData() async {
    // You can perform any asynchronous operation here, like fetching new data from the API
    await Future.delayed(const Duration(
        seconds: 1)); // Simulating a delay for demonstration purposes

    // After fetching new data, you can update the UI if necessary
    setState(() {
      // Clear the existing data list
      postList.clear();
      // Fetch new data
      getPostApi();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Basic Api Calls",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.deepOrange,
        ),
        body: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () =>
                    refreshData(), // Define the function to be called when refreshing
                child: FutureBuilder(
                  future: getPostApi(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // While the future is still resolving
                      return const Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.red,
                          color: Colors.white,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      // If an error occurred during the future execution
                      return Text('Error: ${snapshot.error}');
                    } else {
                      // If the future completed successfully
                      return ListView.builder(
                          itemCount: postList.length,
                          itemBuilder: (context, index) {
                            return Column(mainAxisAlignment:MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  child: ClipOval(
                                    child: Image.network(
                                      snapshot.data![index].url.toString(),
                                      fit: BoxFit.cover, // Ensures the image covers the entire circle
                                      width: 100, // Adjust the width and height as needed
                                      height: 100,
                                    ),
                                  ),
                                ),
                              ],);
                          });
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
