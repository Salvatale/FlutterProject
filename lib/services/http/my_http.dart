import 'dart:convert';
import 'package:chatbot/services/auth/auth_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class MyHtpp {

  String url = "localhost:8000";

  Future<http.Response> post(String message,String userId, String context) async {

    final response = await http.post(
      Uri.http(url,'/'),
      headers: <String,String> {
        'Content-type' : 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String,String>{
        'function' : "message",
        'message': message,
        'userId' : userId,
        'context' : context,
      }),
    );

    if(response.statusCode == 200){
      return response;
    } 
    else{
      throw Exception('Failed to get response');
    }
  }

  Future<http.Response> sendUrl(String message,String userId, String context) async {

    final response = await http.post(
      Uri.http(url,'/url'),
      headers: <String,String> {
        'Content-type' : 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String,String>{
        'message': message,
        'userId' : userId,
        'context' : context,
      }),
    );

    if(response.statusCode == 200){
      return response;
    } 
    else{
      throw Exception('Failed to get response');
    }
  }

  Future<http.Response> getUserDirectory(String userId) async {

    final response = await http.post(
      Uri.http(url,'/directory'),
      headers: <String,String> {
        'Content-type' : 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String,String>{
        'userId' : userId,
      }),
    );

    if(response.statusCode == 200){
      return response;
    } 
    else{
      throw Exception('Failed to get response');
    }
  }

  Future<http.Response> createUserDirectory(String userId) async {

    final response = await http.post(
      Uri.http(url,'/create_directory'),
      headers: <String,String> {
        'Content-type' : 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String,String>{
        'userId' : userId,
      }),
    );

    if(response.statusCode == 200){
      return response;
    } 
    else{
      throw Exception('Failed to get response');
    }
  }

  Future<http.Response> mailPost(String message,String mailReceiver) async{

    final response = await http.post(
      Uri.http(url,'/'),
      headers: <String,String> {
        'Content-type' : 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String,String>{
        'function' : "mail",
        'message': message,
        'mail' : mailReceiver,
      }),
    );

    if(response.statusCode == 200){
      return response;
    } 
    else{
      throw Exception('Failed to get response');
    }
  }

  Future<http.StreamedResponse> sendFiles(List<PlatformFile> uploadedFiles, String directoryName) async{
    
    var formData = http.MultipartRequest('POST',Uri.http(url,'/upload'));

    for(int i = 0; i < uploadedFiles.length;i++){
      PlatformFile file = uploadedFiles[i];
      formData.files.add(http.MultipartFile.fromBytes(
        "files",
        file.bytes!,
        filename: file.name,
      ));
    }

    AuthService authService = AuthService();
    String userId = authService.getCurrentUserID();

    Map<String,dynamic> jsonData = {
      'directory_name' : directoryName,
      'userID' : userId,
    };

    formData.files.add(http.MultipartFile.fromString(
      "jsonFile",
      jsonEncode(jsonData),
      filename: "data.json"
    ));
  

    final response = await http.Client().send(formData);

    if(response.statusCode == 200){
      return response;
    }
    else{
      throw Exception("Faield to get response");
    }


    

  }

}