import 'package:flutter/material.dart';
// import 'scanner.dart';
// import 'login.dart';
import 'signup.dart';
import 'screensize.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'qrGenerator.dart';
import 'qrScanner.dart';
// import 'signup.dart';

// import 'screensize.dart';
// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Palm Tree',
//       theme: ThemeData(
//         primarySwatch: Colors.green,
//       ),
//       home: MyHomePage(title: 'Palm tree'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: ElevatedButton(
//             child: Text('Scan'),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => Scanner()),
//               );
//             }),
//       ),
//     );
//   }
// }


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.green),
      home: LoginPage()));
}


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //EDIT HERE FOR ALERT STYLE CHANGES

  var alertStyle = AlertStyle(
    descTextAlign: TextAlign.center,
    descStyle: TextStyle(
      fontSize: 16,
    ),
    titleStyle: TextStyle(fontSize: 25),
    animationType: AnimationType.grow,
    animationDuration: Duration(milliseconds: 400),
  );
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var x = ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all<Color>(Colors.green),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Text(' LOGIN PAGE'),
      //   backgroundColor: Colors.green,
      // ),
      body: Center(
        child: SafeArea(
          bottom: true,
      left: true,
      top: true,
      right: true,
      maintainBottomViewPadding: true,
      minimum: EdgeInsets.fromLTRB(0, 40, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Palm Tree",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[900])),
              // Image(
              //   image: AssetImage('images/p2.png'),
              //   // width: SizeConfig.safeBlockHorizontal! * 50,
              //   // height: SizeConfig.safeBlockVertical! * 30,
              // ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'enter your email here',
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: 'enter your password here',
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              ElevatedButton(
                style: x,
                onPressed: () async {
                  try {
                    // ignore: unused_local_variable
                    UserCredential userCredential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text);
                    DocumentSnapshot user = await FirebaseFirestore.instance
                        .collection('USERS')
                        .doc('${FirebaseAuth.instance.currentUser!.uid}')
                        .get();
                    if (user['user_type'] == true) {
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
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      Alert(
                          style: alertStyle,
                          context: context,
                          title: "Error!",
                          desc: "User Not registered. Please Register",
                          buttons: [
                            DialogButton(
                                child: Text("Register"),
                                onPressed: () {
                                  Alert(
                                      style: alertStyle,
                                      context: context,
                                      title:
                                          "Register as Member or Admin ?",
                                      buttons: [
                                        DialogButton(
                                            child: Text(
                                              "Members",
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SignupPage(true)));
                                            }),
                                        DialogButton(
                                            child: Text("Receptionst"),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SignupPage(false)));
                                            })
                                      ]).show();
                                }),
                          ]).show();
                    } else if (e.code == 'wrong-password') {
                      Alert(
                              style: alertStyle,
                              context: context,
                              title: "Error!",
                              desc: "Wrong password! Try again...")
                          .show();
                    }
                  }
                },
                child: Text('LOGIN'),
              ),
              ElevatedButton(
              style:x,
              onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignupPage(true))); // SIGN UP SCREEN GOES HERE
              },
              child: Text(
                'Register as Receptionist',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
            ElevatedButton(
              style:x,
              onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignupPage(false))); // SIGN UP SCREEN GOES HERE
              },
              child: Text(
                'Register as Member',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            )
            ],
          ),
        ),
      ),
    );
  }
}


class ChoosingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var x = ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all<Color>(Colors.green),
    );
    
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: Text('Palm Tree'),
      // ),
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            Image(
              image: AssetImage('images/applogo.png'),
              width: SizeConfig.safeBlockHorizontal! * 70,
              height: SizeConfig.safeBlockVertical! * 50,
            ),
            Container(
              // width: SizeConfig.screenWidth! * 0.5,
              // height: SizeConfig.screenHeight! * 0.09,
              child: Container(
                // padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  style: x,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Text('Login',style: TextStyle(fontSize: 15),),
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}