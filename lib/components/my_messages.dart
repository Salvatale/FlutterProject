import 'package:flutter/material.dart';


class MyMessages extends StatelessWidget{

  final List<String> messages;

  const MyMessages({
    super.key,
    required this.messages,
  });

  @override
  Widget build(BuildContext context){
    
    return ListView.separated(
      padding: const EdgeInsets.all(8.0),
      //reverse: true,
      itemCount: messages.length,
      separatorBuilder: (BuildContext context, int index){
        return const SizedBox(height: 10,);
      },
      itemBuilder: (BuildContext context,int index) {
        
        
        Color bubbleColor = index % 2 == 0 ? Colors.blue[100]! : Colors.green[100]!;
        Alignment alignment = index % 2 == 0 ? Alignment.centerLeft : Alignment.centerRight;


        return Align(
          alignment: alignment,
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              messages[index],
              style: const TextStyle(fontSize: 16),
            )

          ),
        );
        
        
      },




    );

  }

}