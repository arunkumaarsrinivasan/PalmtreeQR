import 'package:flutter/material.dart';
import'package:cloud_firestore/cloud_firestore.dart';
import'package:firebase_auth/firebase_auth.dart';
import 'screensize.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'qrScanner.dart';
import 'login.dart';
import 'qrGenerator.dart';


class SignupPage extends StatefulWidget {
  final bool us;
  SignupPage(this.us);
  @override
  _SignupPageState createState() => _SignupPageState(us: us);
}

class _SignupPageState extends State<SignupPage> {
  final bool us;
  _SignupPageState({required this.us});
  var a = '';
  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController plotController = TextEditingController();
  TextEditingController memberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController pnoController = TextEditingController();
  TextEditingController addresController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var alertStyle = AlertStyle(
      descTextAlign: TextAlign.center,
      descStyle: TextStyle(
        fontSize: 16,
      ),
      titleStyle: TextStyle(fontSize: 25),
      animationType: AnimationType.grow,
      animationDuration: Duration(milliseconds: 400),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(' Signup'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter your name',
                      labelText: 'name',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.name,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: pnoController,
                    decoration: InputDecoration(
                      hintText: 'Enter your phone number',
                      labelText: 'Phone number',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: addresController,
                    decoration: InputDecoration(
                      hintText: 'Enter your full address',
                      labelText: 'Address',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.streetAddress,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: repasswordController,
                    decoration: InputDecoration(
                      hintText: 'Re-enter your password ',
                      labelText: 're-enter password',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(a,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.indigoAccent.shade400,
                      )),
                ),
                ElevatedButton(
                  style: x,
                  onPressed: () async {
                    if (passwordController.text != repasswordController.text) {
                      Alert(
                        context: context,
                        title: "Warning!",
                        desc: "The password fields mismatch. Please try again",
                        style: alertStyle,
                      ).show();
                    } else {
                      try {
                        // ignore: unused_local_variable
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .createUserWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text);
                        if (us == true) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QRViewExample()));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GeneratePage()));
                        }

                        FirebaseFirestore.instance
                            .collection('USERS')
                            .doc('${FirebaseAuth.instance.currentUser!.uid}')
                            .set({
                          'name': nameController.text,
                          'email': emailController.text,
                          'pno': pnoController.text,
                          'addres': addresController.text,
                          'timestamp': DateTime.now().toString(),
                          'userId': FirebaseAuth.instance.currentUser!.uid,
                          'user_type': us,
                        });
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          Alert(
                            context: context,
                            title: "Weak password!",
                            buttons: [],
                            desc:
                                "The password you entered is weak. Enter a password with atleast one number and one special character",
                            closeFunction: () {
                              setState(() {
                                passwordController.text = "";
                                repasswordController.text = "";
                              });
                              Navigator.pop(context);
                            },
                            style: alertStyle,
                          ).show();
                        } else if (e.code == 'email-already-in-use') {
                          Alert(
                            context: context,
                            title: "Email already used",
                            desc:
                                "Email is already registered. Please try logging in or use a different email id",
                            buttons: [
                              DialogButton(
                                  color: Colors.deepPurple.shade400,
                                  child: Text("Log in"),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage()));
                                  })
                            ],
                            style: alertStyle,
                          ).show();
                        }
                      } catch (e) {
                        Alert(
                          context: context,
                          title: "Warning!",
                          desc: e.toString(),
                          style: alertStyle,
                        ).show();
                      }
                      
                    }
                  },
                  child: Text('Register'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}