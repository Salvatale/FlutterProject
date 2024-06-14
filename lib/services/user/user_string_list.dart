import 'dart:convert';
import 'package:chatbot/services/http/my_http.dart';


class UserStringList {

  static final Map<String, List<String>> _userLists = {};


  static Future<void> initializeUserList(String userId) async {
    
    MyHtpp myHtpp = MyHtpp();

    try{

      final response = await myHtpp.getUserDirectory(userId);

      final json = jsonDecode(response.body) as Map<String,dynamic>;

      List<String> directoryList = List<String>.from(json['directory_list']);

      _userLists[userId] = directoryList;

    }catch(e) {
      throw Exception(e.toString());

    }
  }

  static Future<void> createUserList(String userId) async {
    
    MyHtpp myHtpp = MyHtpp();

    try{

      await myHtpp.createUserDirectory(userId);

      //final json = jsonDecode(response.body) as Map<String,dynamic>;

      _userLists[userId] = [];

    }catch(e) {
      throw Exception(e.toString());

    }
  }




  List<String> getUserList(String userId){

    List<String> list = [];

    if(_userLists.containsKey(userId)){
      
      list = _userLists[userId]!;
    }

    return list;
    

  }

  void addUserElement(String userId, String directoryName){

    _userLists[userId]!.add(directoryName);

  }

  void removeUserElement(String userId, int index){
    _userLists[userId]!.removeAt(index);
  }

}