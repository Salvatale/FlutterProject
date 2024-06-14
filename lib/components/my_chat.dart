import 'dart:convert';
import 'package:chatbot/components/my_dropdown_menu.dart';
import 'package:chatbot/components/my_messages.dart';
import 'package:chatbot/components/my_textfield.dart';
import 'package:chatbot/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:chatbot/services/http/my_http.dart';


class MyChatBot extends StatefulWidget{

  const MyChatBot({
    super.key,
  });

  @override
  State<MyChatBot> createState() => _MyChatBotState();

}


class _MyChatBotState extends State<MyChatBot> {

  final TextEditingController _textController = TextEditingController();
  final List<String> _messages = ['Ciao, sono il tuo Chatbot, come posso esserti utile?'];
  String selectedContext = '';

  void selectContext(String context){
    setState(() {
      selectedContext = context;
    });
  }

  void _handleSubmitted(BuildContext context) async{

    String text = _textController.text;

    _textController.clear();

    setState(() {
      _messages.add(text);
    });

    if(selectedContext.isEmpty){
      _messages.add("Scegli almeno un contesto!!");
      return;
    }

    MyHtpp myHtpp = MyHtpp();
    AuthService authService = AuthService();

    try{



      final response = await myHtpp.post(text,authService.getCurrentUserID(),selectedContext);

      final json = jsonDecode(response.body) as Map<String,dynamic>;

      text = json['message'];

      setState(() {
        _messages.add(text);
      });

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


    
    


  Widget _buildTextComposer() {
    return Container(

      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [

          Expanded(
            child: MyTextField(
              controller: _textController,
              obscureText: false,
              hintText: 'Type something to ask..',

            ),
          ),
          IconButton(
            onPressed: () => _handleSubmitted(context),
            icon: const Icon(Icons.send))

        ],
      ),



    );
  }


  @override
  Widget build(BuildContext context){

    return Scaffold(

      
      
      body: Center(
        child: Row(
          children: [
            Expanded(
              flex: 8,
              child: Column(
                children: [
                  Expanded(
                    child :Column(
                      children: [
                        Flexible(
                          child: MyMessages(messages: _messages),
                          
                        ),
                    
                        const Divider(height: 1.0),
                    
                        _buildTextComposer(),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Container(
              width: 1.0,
              color: Colors.black,
            ),

            Expanded(
              flex: 2,
              child: MyDropdownMenu(selectItem: selectContext,),
            ),
          ],
        ),
      ),


    );

  }


} 