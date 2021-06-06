import 'package:cloud_firestore/cloud_firestore.dart';
class UserModel {
  final String uid;

  UserModel({this.uid});

}





CollectionReference users = FirebaseFirestore.instance.collection('Students');

Future<void> addUser(name1, rollno1, class1, email1, phone1, uid1) async{
  return users.doc(uid1).set({
    'Name': name1,
    'Roll Number': rollno1,
    'Class': class1,
    'Email': email1,
    'Phone Number': phone1
  })
      .then((value) => print("User Added"))
      .catchError((error) => print("Failed to add user: $error"));
}
