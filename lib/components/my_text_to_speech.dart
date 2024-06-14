import 'dart:convert';
import 'package:chatbot/components/my_dropdown_menu.dart';
import 'package:chatbot/components/my_speech_messages.dart';
import 'package:chatbot/services/auth/auth_service.dart';
import 'package:chatbot/services/chat/message.dart';
import 'package:chatbot/services/http/my_http.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class MyTextToSpeech extends StatefulWidget{

  const MyTextToSpeech({super.key});

  @override
  State<MyTextToSpeech> createState() => _MyTextToSpeechState();

}

class _MyTextToSpeechState extends State<MyTextToSpeech>{

  final SpeechToText _speechToText = SpeechToText();
  String _speech = '';
  bool isListening = false;
  final List<Message> _messages = [];
  String _context = '';

  @override
  void initState(){
    super.initState();
    _initSpeech();
    String text = "Sono il tuo Speechbot, registra un'audio per cominciare a chattare";
    Message message = Message(text: text, isVoice: true);
    _messages.add(message);
  }

  void _initSpeech() async{
    await _speechToText.initialize();
    setState(() {});
  }

  void selectContext(String selectedContext){
    setState(() {
      _context = selectedContext;
    });
  }
  

  void _startListening() async {
    try{
      if(!isListening){
        await _speechToText.listen(onResult: _onSpeechResult);
        setState(() {
          isListening = true;
        });
      }
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

  void _stopListening() async {
    try{
      if(isListening){
        await _speechToText.stop();
        setState(() {
          isListening = false;
        });
      }
    }
    catch(e){
      showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        )
      
      );
    }

    Message message = Message(text: _speech, isVoice: false);

    setState(() {
      _messages.add(message);
    });

    await _post();
    
  }

  void _onSpeechResult(SpeechRecognitionResult result){
    try{
      setState(() {
      _speech = result.recognizedWords;
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

  Future<void> _post() async {

    MyHtpp myHtpp = MyHtpp();

    try{

      final response = await myHtpp.post(_speech, AuthService().getCurrentUserID(), _context);
      final json = jsonDecode(response.body) as Map<String,dynamic>;

      String text = json['message'];
      Message message = Message(text: text, isVoice: true);
      setState(() {
        _speech = "";
        _messages.add(message);
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
    

  @override
  Widget build(BuildContext contex){

    return Scaffold(

      appBar: AppBar(
        title: const Text("SpeechBot"),
      ),

      body: Center(
        child: Row(
          children: [
            Expanded(
              flex: 8,
              child :Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Flexible(child: MySpeechMessages(messages: _messages)),
              
                        const Divider(height: 1.0,),
              
                        FloatingActionButton(
                          onPressed: 
                            !isListening ? _startListening : _stopListening,
                          tooltip: 'Rec',
                          child: Icon(isListening ? Icons.mic_off : Icons.mic),
                            
                        ),
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