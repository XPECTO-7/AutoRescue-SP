import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection("SERVICE-REQUEST").snapshots(),
      builder: (context, snapshot) {
if(snapshot.hasData){
  final user=FirebaseAuth.instance.currentUser!;
   List requestList = snapshot.data!.docs;
           List<dynamic> userRequest=[];
           requestList.forEach((element) {
            if(user.email==element["UserID"]){
              userRequest.add(element);
            }

            });
     return Scaffold(
          appBar: AppBar(
            title: const Text('Notifications'),
          ),
          body: ListView.builder(
            itemCount: userRequest.length,
            itemBuilder: (context, index) {
            return ListTile(
              title:Text(userRequest[index]["UserID"].toString()) ,
              subtitle: Text(userRequest[index]["Service-Request-Type"]),
            );
          },)
        );
}else{
  return Scaffold();
}
     
      },
    );
  }
}
