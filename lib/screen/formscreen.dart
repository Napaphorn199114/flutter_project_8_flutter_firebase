import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/model/student.dart';
import 'package:form_field_validator/form_field_validator.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {

  final formKey = GlobalKey<FormState>();                    //สถานะในแบบฟอร์ม FormState
  Student myStudent = Student();                             //ประกาศ Object student
  // การเตรียม firebase
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  CollectionReference _studentCollection = FirebaseFirestore.instance.collection("students"); // สร้างตารางเก็บข้อมูลแบบฟอร์มของนักเรียน 


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase,         //เชื่อมต่อกับ firebase
      builder: (context,snapshot){
        if(snapshot.hasError){
          return Scaffold(
            appBar: AppBar(title: Text("Error"),),
            body: Center(child: Text("${snapshot.error}"),),
          );
        }
        if(snapshot.connectionState == ConnectionState.done){
          return Scaffold(
      appBar: AppBar(
        title: Text("แบบฟอร์มบันทึกคะแนนสอบ"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: formKey,  // เช็ค สถานะแบบฟอร์ม
          child: SingleChildScrollView(   //แก้ไขปัญหา button overflow error ตรงคีย์บอร์ด
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "ชื่อ",
                style: TextStyle(fontSize: 20),
              ),
              TextFormField(
                validator: RequiredValidator(errorText: "กรุณาป้อนชื่อ"),  //RequiredValidator เช็คว่าช่องเป็นค่าว่างหรือป่าว
                onSaved: (var fname){
                  myStudent.fname = fname!;
                },
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "นามสกุล",
                style: TextStyle(fontSize: 20),
              ),
              TextFormField(
                validator: RequiredValidator(errorText: "กรุณาป้อนนามสกุล"),
                onSaved: (var lname){
                  myStudent.lname = lname!;
                },
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "อีเมล",
                style: TextStyle(fontSize: 20),
              ),
              TextFormField(
                validator: MultiValidator([     // เช็คมากว่า 1 เงื่อนไข
                  EmailValidator(errorText: "รูปแบบอีเมลไม่ถูกต้อง"),
                  RequiredValidator(errorText: "กรุณาป้อนอีเมล")
                ]),
                onSaved: (var email){
                  myStudent.email = email!;
                },
                keyboardType: TextInputType.emailAddress,    // keyboard Email มี @
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "คะแนน",
                style: TextStyle(fontSize: 20),
              ),
              TextFormField(
                validator: RequiredValidator(errorText: "กรุณาป้อนคะแนน"),
                onSaved: (var score){
                  myStudent.score = score!;
                },
                keyboardType: TextInputType.number,    // keypoard Number
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text(
                    "บันทึกข้อมูล",
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () async{
                    if(formKey.currentState!.validate()){
                      formKey.currentState?.save();
                      print("ข้อมูล = ${myStudent.fname}${myStudent.lname}${myStudent.email}${myStudent.score}");
                      await _studentCollection.add({   //ข้อมูลจะถูกจัดเก็บที่ cloud firestore
                        "fname":myStudent.fname,
                        "lname":myStudent.lname,
                        "email":myStudent.email,
                        "score":myStudent.score
                      });
                      formKey.currentState?.reset();  //รับค่าเสร็จ ก็ reset form เพื่อเตรียมรับค่าใหม่  ส่งข้อมูลไปเก็บที่ fire store เรียบร้อยแบบฟอร์มจะถูก reset
                    }
                  },
                ),
              ),
            ]),
          ),
        ),
      ),
    );
        }
        return Scaffold(
          body: Center(child: CircularProgressIndicator(),),
        );
      }
      );
  
  }
}
