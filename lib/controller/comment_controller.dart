import 'dart:convert';
import 'package:blog_apicall/Model_class/comments_model.dart';
import 'package:blog_apicall/screens/add_comment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class UserController extends GetxController {
  var users = <CommentModel>[].obs;
 
  TextEditingController Id = TextEditingController();
  TextEditingController PostId = TextEditingController();
  TextEditingController Nametext = TextEditingController();
  TextEditingController Email = TextEditingController();
  TextEditingController Addbody = TextEditingController();

  addUser() async {
    Uri url =
        Uri.parse("https://jsonplaceholder.typicode.com/comments" + addUser());
    final userdata = CommentModel(
        postId: int.parse(PostId.text),
        id: int.parse(Id.text),
        name: Nametext.text,
        email: Email.text,
        body: Addbody.text);
    try {
      var resp = await http.post(url,
          body: jsonEncode(userdata.toJson()),
          headers: {"content- type": "application/json"});
      if (resp.statusCode == 201) {
        Get.snackbar("post", "successfull");
      }
    } catch (e) {
      throw Exception("error");
    }
  }

  getUserComments() async {
    Uri Url = Uri.parse("https://jsonplaceholder.typicode.com/comments");

    try {
      var resp = await http.get(Url);
      if (resp.statusCode == 200) {
        var data = List<CommentModel>.from(
                jsonDecode(resp.body).map((e) => CommentModel.fromJson(e)))
            .toList();
        if (data != null) {
          users.value = data;
        }
      }
    } catch (e) {
      throw Exception("Error" "$e");
    }
  }
}


