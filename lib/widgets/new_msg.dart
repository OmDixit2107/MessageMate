import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMsg extends StatefulWidget {
  const NewMsg({super.key});
  State<NewMsg> createState() {
    return _NewMsgState();
  }
}

class _NewMsgState extends State<NewMsg> {
  final _msgcontroller = TextEditingController();
  @override
  void dispose() {
    _msgcontroller.dispose();
    super.dispose();
  }

  void _submitmsg() async {
    final enteredMsg = _msgcontroller.text;
    if (enteredMsg.trim().isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    _msgcontroller.clear();
    final user = FirebaseAuth.instance.currentUser!;
    final userdata = await FirebaseFirestore.instance.collection("users")
    .doc(user.uid)
    .get();
    //send to firebase
    FirebaseFirestore.instance.collection("chat").add(
      {
        'text':enteredMsg,
        'created':Timestamp.now(),
        'userid':user.uid,
        'username':userdata.data()!['username'],
        'userimg':userdata.data()!['image_url']
      },
    );
    
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 4),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _msgcontroller,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(labelText: "Type A msg"),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _submitmsg,
          )
        ],
      ),
    );
  }
}
