import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class DisplayScreen extends StatefulWidget {
  const DisplayScreen({ Key? key }) : super(key: key);

  @override
  State<DisplayScreen> createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: Text("รายงานคะแนนสอบ")
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("students").snapshots(),
        builder:(context,AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData){  //ถ้าไม่มีข้อมูลจะให้แสดงอะไร
            return Center(child: CircularProgressIndicator(),);
          }
          return ListView( //ดึงข้อมูลคะแนนสอบ ของนักเรียนมาแสดงผล
            children: snapshot.data!.docs.map((document){  //แถวแต่ละแถว
              return Container(
                child: ListTile(
                  leading: CircleAvatar(  //รูปวงกลม
                    radius: 30,
                    child: FittedBox(child: Text(document["score"]),
                  ),
                ),
                title: Text(document["fname"]+document["lname"]),
                subtitle: Text(document["email"]),
              ),
              );
            }).toList(),
          );
        } ,
        ),
    );
  }
}