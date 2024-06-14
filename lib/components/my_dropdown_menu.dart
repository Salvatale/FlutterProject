import 'package:chatbot/services/auth/auth_service.dart';
import 'package:chatbot/services/user/user_string_list.dart';
import 'package:flutter/material.dart';

class MyDropdownMenu extends StatefulWidget{

  final void Function(String)? selectItem;

  const MyDropdownMenu({
    super.key,
    required this.selectItem,
  });

  @override
  State<MyDropdownMenu> createState() => _MyDropdownMenuState();
}

class _MyDropdownMenuState extends State<MyDropdownMenu>{

  String selectedItem = '';
  late void Function(String)? selectItem;
  List<String> menu = UserStringList().getUserList(AuthService().getCurrentUserID());

  @override
  void initState(){
    super.initState();
    selectItem = widget.selectItem;
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
      
      body: ListView.builder(

        itemCount: menu.length ,
        itemBuilder: (context, index){
          return GestureDetector(

            onTap: () {
              setState(() {
                selectedItem = menu[index];
              });
              selectItem?.call(menu[index]);
            },

            child: Container(
              color: selectedItem == menu[index]
                ? Colors.grey.withOpacity(0.3)
                : Colors.transparent
              ,

              child: ListTile(

                title: Text(
                  menu[index],
                  style : TextStyle(
                    color: selectedItem == menu[index]
                      ? Colors.blue
                      : Colors.black,

                  ),
                ),

                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    UserStringList userList = UserStringList();
                    userList.removeUserElement(AuthService().getCurrentUserID(), index);
                    if(selectedItem == menu[index]){
                      setState(() {
                        selectedItem = '';
                      });
                      selectItem?.call('');

                    }
                  },
                ),

              ),


            ),
          );

        },

      ),



    );

  }
}