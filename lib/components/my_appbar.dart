import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget{

  final void Function()? onTap;
  final String title;
  final Icon icon;

  const MyAppBar({
    super.key,
    required this.onTap,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context){
    return AppBar(

      title: Text(
        title,
        style: const TextStyle(fontSize: 30.0),
      ),

      actions: [

        IconButton(
          onPressed: onTap,
          icon: icon,
          iconSize: 50,
          
        )

      ],

    );

  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

}