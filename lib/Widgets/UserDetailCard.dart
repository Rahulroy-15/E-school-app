import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:school_management/services/UserModel.dart';

class UserDetailCard extends StatefulWidget {

  final String documentId;
  UserDetailCard(this.documentId);

  @override
  _UserDetailCardState createState() => _UserDetailCardState();
}

class _UserDetailCardState extends State<UserDetailCard>
    with SingleTickerProviderStateMixin {
  Animation animation, delayedAnimation, muchDelayedAnimation, LeftCurve;
  AnimationController animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    animationController =
        AnimationController(duration: Duration(seconds: 3), vsync: this);
    animation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));

    delayedAnimation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.2, 0.5, curve: Curves.fastOutSlowIn)));

    muchDelayedAnimation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.3, 0.5, curve: Curves.fastOutSlowIn)));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.documentId).get(),
      builder: (BuildContext context,
          AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          return AnimatedBuilder(
            animation: animationController,
            builder: (BuildContext context, Widget child) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 5, 10, 3),
                child: Container(
                  alignment: Alignment(0, 0),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, right: 0.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      height: height * 0.17,
                      width: double.infinity,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15.0, 10, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Transform(
                                  transform: Matrix4.translationValues(
                                      muchDelayedAnimation.value * width, 0, 0),
                                  child: Center(
                                    child: CircleAvatar(
                                      radius: 28,
                                      backgroundImage: AssetImage("assets/home.png"),
                                    ),
                                  ),
                                ),
                                Transform(
                                  transform: Matrix4.translationValues(
                                      delayedAnimation.value * width, 0, 0),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Container(
                                            padding: EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                              color: Colors.orange[50],
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              "Roll No: ${data['Roll Number']}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                                color: Colors.deepOrange,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10.0),
                                          child: Text(
                                            "${data['Name']}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 21,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Class: ${data['Class']}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }

        return Scaffold(body: Center(child: CircularProgressIndicator(),));
      },
    );
  }
}