import 'package:chatbot/services/chat/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';


class MySpeechMessages extends StatelessWidget{

  final List<Message> messages;
  final FlutterTts _flutterTts = FlutterTts();

  MySpeechMessages({
    super.key,
    required this.messages,
  });

  
  Future<void> speak(String text, BuildContext context) async {
    try{
      await _flutterTts.setLanguage('it-IT');
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setSpeechRate(1.0);
      await _flutterTts.speak(text);
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

  Future<void> pause() async {
    await _flutterTts.pause();

  }

  @override
  Widget build(BuildContext context){

    return Scaffold(

      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context,index){
          Message message = messages[index];
          return message.isVoice
            ? VoiceMessageItem(message: message, speak: speak, pause: pause)
            : TextMessageItem(message: message);
        }
      ),

    );

  }


}

class VoiceMessageItem extends StatelessWidget {

  final Message message;
  final Function(String,BuildContext) speak;
  final Function pause;

  const VoiceMessageItem({
    super.key,
    required this.message,
    required this.speak,
    required this.pause,
  });

  @override
  Widget build(BuildContext context){
    return ListTile(
      title: Row(
        children: [
          const Icon(Icons.keyboard_voice),
          const SizedBox(width: 8,),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  const Expanded(
                    child: Text("Messaggio vocale"),
                  ),
                  const SizedBox(width: 8,),

                  IconButton(
                    onPressed: () => speak(message.text,context), 
                    icon: Icon(Icons.play_arrow),
                  ),

                  IconButton(
                    onPressed: () => pause(), 
                    icon: const Icon(Icons.pause),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      //onTap: () => speak(message.text,context),
    );
  }
}

class TextMessageItem extends StatelessWidget{
  final Message message;

  const TextMessageItem({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context){
    return ListTile(
      title: Text(message.text),
    );
  }

}