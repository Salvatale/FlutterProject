import 'package:chatbot/components/my_textfield.dart';
import 'package:chatbot/services/auth/auth_service.dart';
import 'package:chatbot/services/http/my_http.dart';
import 'package:flutter/material.dart';

class MyHtmlUploader extends StatelessWidget{

  final TextEditingController _urlsController = TextEditingController();
  final TextEditingController _contextNameController = TextEditingController();

  MyHtmlUploader({super.key});

  void sendUrls(BuildContext context) async{

    MyHtpp myHtpp = MyHtpp();
    String urls = _urlsController.text;
    String contextName = _contextNameController.text;
    String userId = AuthService().getCurrentUserID();

    if(urls.isEmpty || contextName.isEmpty){
      showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: const Text("One of the fields is empty"),
        )
      
      );
      return;
    }

    try{
      await myHtpp.sendUrl(urls,userId,contextName);
    }
    catch(e){
      showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        )
      
      );
    }

  }

  @override
  Widget build(BuildContext context){

    return Scaffold(

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Container(
            height: 1.0,
            color: Colors.black,
          ),
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child : const Text("Insert urls following by a space"),
          ),
          const SizedBox(height: 10,),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _urlsController,
                maxLines: null,
                decoration: const InputDecoration(
                hintText: 'Enter URLs(one per line)',
                ),
              ),

            ),
          ),
            
          const SizedBox(height: 20,),
          
          Container(
            height: 2.0,
            color: Colors.black,
          ),

          const SizedBox(height: 40.0,),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: MyTextField(
              hintText: "Type context name",
              obscureText: false,
              controller: _contextNameController,
            ),
          ),

          Container(
            height: 1.0,
            color: Colors.black,
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => sendUrls(context),
              child: const Text('Send'),
            
            ),
          ),


        ],

      ),

    );

  }




}
