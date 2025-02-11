import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupChatsPage extends StatefulWidget {
  const GroupChatsPage({super.key});

  @override
  State<GroupChatsPage> createState() => _GroupChatsPageState();
}

class _GroupChatsPageState extends State<GroupChatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Group Chats Page',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
