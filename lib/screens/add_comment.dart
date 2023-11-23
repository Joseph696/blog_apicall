import 'package:blog_apicall/Model_class/comments_model.dart';
import 'package:blog_apicall/controller/comment_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:get/get_instance/get_instance.dart';
import 'package:http/http.dart';

class AddComments extends StatefulWidget {
  AddComments({super.key});

  final controller = Get.put(UserController());

  @override
  State<AddComments> createState() => _AddCommentsState();
}

class _AddCommentsState extends State<AddComments> {
  TextEditingController nameController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  
  final url = ("https://jsonplaceholder.typicode.com/comments");
  void postData() async {
    try{
    final response = await post(Uri.parse(url),
        body: {"title": "aaaaa", "body": "Post anything", "userId": "1"});
    print(response.body);
  }catch(e){
    print(e){}
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Comments"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "Name"),
            ),
            SizedBox(
              height: 5,
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "Comment here"),
            ),
            ElevatedButton(onPressed: postData, child: Text("Submit"))
          ],
        ),
      ),
    );
  }
}
