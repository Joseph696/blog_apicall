import 'dart:convert';
import 'package:blog_apicall/Model_class/blog_model.dart';
import 'package:blog_apicall/Model_class/user_model.dart';
import 'package:blog_apicall/controller/comment_controller.dart';
import 'package:blog_apicall/screens/add_comment.dart';
import 'package:blog_apicall/screens/details_page.dart';
import 'package:blog_apicall/screens/user_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  HomePage({super.key});
  final controller = Get.put(UserController());
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<PostModel> postList = [];

  Future<List<PostModel>> getPostApi() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      for (Map<String, dynamic> i in data) {
        postList.add(PostModel.fromJson(i));
      }
      return postList;
    } else {
      return postList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: AppBar(
        centerTitle: true,
        title: Text('Blog Online'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getPostApi(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Loading');
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ListView.builder(
                      itemCount: postList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailsPage(),
                                ));
                          },
                          child: Card(
                            margin: EdgeInsets.all(4),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  //Text('Id \n' + postList[index].id.toString()),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Blog  ${postList[index].id}\n',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text(
                                    postList[index].title.toString(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(postList[index].body.toString()),
                                  IconButton(
                                    alignment: Alignment.center,
                                    onPressed: () {
                                      _showDeleteBlog(AutofillHints.name);
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    style: ButtonStyle(
                                        iconColor: MaterialStatePropertyAll(
                                            Colors.red)),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          )
        ],
      ),
      drawer: Drawer(
          elevation: 5,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          backgroundColor: Colors.blue,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: UserDropDown(),
          )),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.keyboard),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddComments(),
                ));
          }),
    );
  }
}

void _showDeleteBlog(String userid) async {
  try {
    http.Response response = await http.delete(
        Uri.parse("https://jsonplaceholder.typicode.com/posts/$userid"),
        headers: {
          'content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer'
        });
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      print('Deleted user $userid');
    } else {
      print('response not found!');
    }
    throw jsonDecode(response.body)['meta']['message'] ??
        "Unknown Error Occured";
  } catch (e) {
    print(e);
  }
}
