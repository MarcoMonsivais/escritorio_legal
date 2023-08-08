import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegal/chat/chat_page.dart';
import 'package:elegal/login/admin_page.dart';
import 'package:elegal/welcome/welcome.dart';
import 'package:elegal/welcome/welcome_agent.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chat/success_page.dart';
import 'helpers/global.dart';
import 'helpers/global_functions.dart';
import 'login/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MyApp();
        }

        return const CircularProgressIndicator();
      },
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Escritorio Legal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (_) => MyHomePage(),
        '/register': (BuildContext context) => Register(),
        '/welcome': (BuildContext context) => Welcome(),
        '/welcomeagent': (BuildContext context) => WelcomeAgent(),
        '/success': (_) => SuccessPage(),
        '/history': (_) => HistoryPage(),
        '/adminMode': (_) => AdminPage(),

      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController pvcontroller = PageController();
  bool _obscure = true;

  final TextEditingController _passwordController = TextEditingController(
      // text: '123456'
      );
  final TextEditingController _usernameController = TextEditingController(
      // text: 'cliente@hotmail.com'
      );

  final TextEditingController _mailRestoreController = TextEditingController();

  String lastName = '', lastEmail = '';

  @override
  void initState() {
    try {
      print('initState');
      SharedPreferences.getInstance().then((value) {
        print('SharedPreferences');
        lastName = value.getString('lastUser')!;
        lastEmail = value.getString('lastEmail')!;
        print(lastName);
        print(lastEmail);
      }).whenComplete(() => setState(() {}));
    } catch (onerror) {
      print(onerror);
      lastName = '';
      lastEmail = '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.30,
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 250,
                      height: 300,
                      child: Image.asset(
                        'assets/logoblanco.png',
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.50,
                        width: MediaQuery.of(context).size.width * 0.50,
                        child: PageView(
                          controller: pvcontroller,
                          scrollDirection: Axis.horizontal,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  height: 15,
                                  child: const Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        'V01.01.21  ',
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.white),
                                      )),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 15, left: 15),
                                  child: GestureDetector(
                                    onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => Register())),
                                    child: Container(
                                        height: 35,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.white,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(2.5)),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Registrar',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white),
                                          ),
                                        )),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 15, left: 15),
                                  child: GestureDetector(
                                    onTap: () => pvcontroller.nextPage(
                                        duration:
                                            const Duration(milliseconds: 400),
                                        curve: Curves.easeIn),
                                    child: Container(
                                        height: 35,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.white,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(2.5)),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Ingresar a mi cuenta',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white),
                                          ),
                                        )),
                                  ),
                                ),
                                // SizedBox(
                                //   height:
                                //   MediaQuery.of(context).size.height *
                                //       0.02,
                                // ),
                                // Padding(
                                //   padding: const EdgeInsets.only(
                                //       right: 15, left: 15),
                                //   child: GestureDetector(
                                //     onTap: () => copy(),
                                //     child: Container(
                                //         height: 35,
                                //         decoration: BoxDecoration(
                                //           border: Border.all(
                                //             color: Colors.white,
                                //           ),
                                //           borderRadius:
                                //           const BorderRadius.all(
                                //               Radius.circular(2.5)),
                                //         ),
                                //         child: const Center(
                                //           child: Text(
                                //             'MOVER',
                                //             style: TextStyle(
                                //                 fontSize: 15,
                                //                 color: Colors.white),
                                //           ),
                                //         )),
                                //   ),
                                // ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () => pvcontroller.previousPage(
                                      duration:
                                          const Duration(milliseconds: 400),
                                      curve: Curves.easeIn),
                                  child: const Align(
                                      alignment: Alignment.topLeft,
                                      child: Icon(
                                        Icons.arrow_back,
                                        color: Colors.white,
                                      )),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.03,
                                ),
                                lastName.isEmpty
                                    ? Center(
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.75,
                                          child: TextField(
                                            autocorrect: false,
                                            autofocus: true,
                                            controller: _usernameController,
                                            style: const TextStyle(
                                                color: Colors.white),
                                            decoration: InputDecoration(
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1.0),
                                              ),
                                              enabledBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1.0),
                                              ),
                                              border: const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8),
                                                ),
                                              ),
                                              labelText: 'Correo',
                                              labelStyle: const TextStyle(
                                                  color: Colors.white),
                                              suffixIcon: IconButton(
                                                color: Colors.black,
                                                icon: const Icon(
                                                  Icons.cancel,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () =>
                                                    _usernameController.clear(),
                                              ),
                                            ),
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            textCapitalization:
                                                TextCapitalization.none,
                                            textInputAction:
                                                TextInputAction.next,
                                            // onEditingComplete: () {
                                            //   _focusNode?.requestFocus();
                                            // },
                                          ),
                                        ),
                                      )
                                    : Center(
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.75,
                                          child: Text(
                                            'Hola de nuevo, $lastName',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                Center(
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.75,
                                    child: TextField(
                                      autocorrect: false,
                                      autofocus: false,
                                      controller: _passwordController,
                                      style:
                                          const TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 1.0),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 1.0),
                                        ),
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                        ),
                                        labelText: 'Contraseña',
                                        labelStyle: const TextStyle(
                                            color: Colors.white),
                                        suffix: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _obscure = !_obscure;
                                              });
                                            },
                                            child: const Icon(
                                              Icons.remove_red_eye,
                                              color: Colors.white,
                                            )),
                                        suffixIcon: IconButton(
                                          color: Colors.black,
                                          icon: const Icon(
                                            Icons.cancel,
                                            color: Colors.white,
                                          ),
                                          onPressed: () =>
                                              _passwordController.clear(),
                                        ),
                                      ),
                                      keyboardType: TextInputType.text,
                                      obscureText: _obscure,
                                      textCapitalization:
                                          TextCapitalization.none,
                                      textInputAction: TextInputAction.next,
                                      onEditingComplete: () => _login(),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                lastName.isEmpty
                                    ? const SizedBox.shrink()
                                    : GestureDetector(
                                        onTap: () async {
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          prefs.remove('lastEmail');
                                          prefs.remove('lastUser');
                                          setState(() {
                                            lastName = '';
                                            lastEmail = '';
                                          });
                                        },
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.75,
                                          child: const Align(
                                              alignment: Alignment.topRight,
                                              child: Text(
                                                'Usar otra cuenta',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white),
                                              )),
                                        )),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.03,
                                ),
                                GestureDetector(
                                    onTap: () {
                                      if (_usernameController!.text
                                          .toString()
                                          .isEmpty) {
                                        Alert(
                                            context: context,
                                            content: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.75,
                                                    child: TextField(
                                                      controller:
                                                          _mailRestoreController,
                                                      autocorrect: false,
                                                      decoration:
                                                          const InputDecoration(
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 1.0),
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 1.0),
                                                        ),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(8),
                                                          ),
                                                        ),
                                                        labelText: 'Correo',
                                                        labelStyle: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      keyboardType:
                                                          TextInputType.text,
                                                      textCapitalization:
                                                          TextCapitalization
                                                              .sentences,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            buttons: [
                                              DialogButton(
                                                color: Colors.black,
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();

                                                  try {
                                                    if (_usernameController!
                                                        .text
                                                        .toString()
                                                        .isEmpty) {
                                                      await FirebaseAuth
                                                          .instance
                                                          .sendPasswordResetEmail(
                                                              email:
                                                                  _mailRestoreController
                                                                      .text);
                                                    } else {
                                                      await FirebaseAuth
                                                          .instance
                                                          .sendPasswordResetEmail(
                                                              email:
                                                                  _usernameController!
                                                                      .text);
                                                    }

                                                    const snackBar = SnackBar(
                                                      content: Text(
                                                          'Correo enviado correctamente. Revisa la bandeja de spam en caso de no identificar el correo'),
                                                      duration:
                                                          Duration(seconds: 4),
                                                      backgroundColor:
                                                          (Colors.black12),
                                                    );

                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(snackBar);
                                                  } catch (onerr) {
                                                    print('Snackerror: ' +
                                                        onerr.toString());
                                                    showMyDialog(
                                                        'No se logró enviar el correo. Revisa la cuenta: Code Details: ' +
                                                            onerr.toString(),
                                                        context);
                                                  }
                                                },
                                                child: const Text(
                                                  "RECUPERAR",
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                ),
                                              ),
                                            ]).show();
                                      } else {
                                        Alert(
                                            context: context,
                                            content: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.75,
                                                    child: TextField(
                                                      controller:
                                                          _usernameController,
                                                      autocorrect: false,
                                                      decoration:
                                                          const InputDecoration(
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 1.0),
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 1.0),
                                                        ),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(8),
                                                          ),
                                                        ),
                                                        labelText: 'Correo',
                                                        labelStyle: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      keyboardType:
                                                          TextInputType.text,
                                                      textCapitalization:
                                                          TextCapitalization
                                                              .sentences,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            buttons: [
                                              DialogButton(
                                                color: Colors.black,
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();

                                                  try {
                                                    if (_usernameController!
                                                        .text
                                                        .toString()
                                                        .isEmpty) {
                                                      await FirebaseAuth
                                                          .instance
                                                          .sendPasswordResetEmail(
                                                              email:
                                                                  _mailRestoreController
                                                                      .text);
                                                    } else {
                                                      await FirebaseAuth
                                                          .instance
                                                          .sendPasswordResetEmail(
                                                              email:
                                                                  _usernameController!
                                                                      .text);
                                                    }

                                                    const snackBar = SnackBar(
                                                      content: Text(
                                                          'Correo enviado correctamente. Revisa la bandeja de spam en caso de no identificar el correo'),
                                                      duration:
                                                          Duration(seconds: 4),
                                                      backgroundColor:
                                                          (Colors.black12),
                                                    );

                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(snackBar);
                                                  } catch (onerr) {
                                                    print('Snackerror: ' +
                                                        onerr.toString());
                                                    showMyDialog(
                                                        'No se logró enviar el correo. Revisa la cuenta: Code Details: ' +
                                                            onerr.toString(),
                                                        context);
                                                  }
                                                },
                                                child: const Text(
                                                  "RECUPERAR",
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                ),
                                              ),
                                            ]).show();
                                      }
                                    },
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.75,
                                      child: const Align(
                                          alignment: Alignment.topRight,
                                          child: Text(
                                            'Recuperar contraseña',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
                                          )),
                                    )),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.03,
                                ),
                                GestureDetector(
                                  onTap: () => _login(),
                                  child: Container(
                                      margin: const EdgeInsets.all(10.0),
                                      height: 45,
                                      width: MediaQuery.of(context).size.width *
                                          0.85,
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0))),
                                      child: const Center(
                                          child: Text(
                                        'Ingresar',
                                        style: TextStyle(color: Colors.black),
                                      ))),
                                ),
                              ],
                            )
                          ],
                        )),
                  ]),
            ),
          ),
        ));
  }

  void _login() async   {
    try {
      print(lastName);
      print(lastEmail);
      FocusScope.of(context).unfocus();

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: lastName.isEmpty ? _usernameController.text : lastEmail,
        password: _passwordController.text,
      )
          .whenComplete(() async {
        String utmp;

        try {
          print(1);
          utmp = FirebaseAuth.instance.currentUser!.uid;
        } catch (onError) {
          utmp = '';
        }

        if (utmp.isNotEmpty) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await FirebaseFirestore.instance
              .collection('e_legal')
              .doc('conf')
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get()
              .then((value) async {
            prefs.setString('lastUser', value['firstName']);
            prefs.setString('lastEmail', value['metadata']['mail']);
            role = value.data()!['role'];
            userName = value['firstName'];

            switch(value.data()!['role']){
              case 'agent':
                Navigator.of(context).pushNamedAndRemoveUntil('/welcomeagent', (Route<dynamic> route) => false);
                break;
              case 'user':
                Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (Route<dynamic> route) => false);
                break;
              case 'admin':
                Navigator.of(context).pushNamedAndRemoveUntil('/adminMode', (Route<dynamic> route) => false);
                break;
              default:
                Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (Route<dynamic> route) => false);
                break;
            }
            // if (value.data()!['role'] == 'agent') {
            //   Navigator.of(context).pushNamedAndRemoveUntil('/welcomeagent', (Route<dynamic> route) => false);
            // } else {
            //   Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (Route<dynamic> route) => false);
            // }
          });
        }
      });
    } catch (e) {
      print('Error: $e');
      switch (e.toString().substring(1, e.toString().indexOf(']'))) {
        case 'firebase_auth/wrong-password':
          showMyDialog(
              'Contraseña incorrecta.\nPorfavor revisa tu contraseña', context);
          break;
        case 'firebase_auth/user-not-found':
          showMyDialog(
                  'Tu usuario no fue encontrado. Porfavor registrate.', context)
              .then((value) => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Register())));
          break;
        case 'firebase_auth/invalid-email':
          showMyDialog(
              'Cuenta de correo inválida, porfavor revisa que se haya ingresado correctamente.',
              context); //.then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage(_usernameController!.text.isEmpty ? '': _usernameController!.text))));
          break;
        case 'firebase_auth/too-many-requests':
          showMyDialog(
              'Esta cuenta ha sido bloqueada temporalmente debido a que se ha intentado accesar a ella demasiadas veces. Porfavor intenta de nuevo dentro de 5 minutos.',
              context); //.then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage(_usernameController!.text.isEmpty ? '': _usernameController!.text))));
          break;
        default:
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
              content: Text(
                  'Revisa tu cuenta y tu contraseña.\nCódigo de error: ' +
                      e.toString()
                  // e.toString(),
                  ),
              title: const Text('Error de autentificación'),
            ),
          );
          break;
      }
    }
  }

  void copy() async {
    var _firestore = FirebaseFirestore.instance;

    String roomIdTest = 'r9hTRd3lwm7SdQ9fMnfU';
    String roomIdOrigin = 'r9hTRd3lwm7SdQ9fMnfU';

    await _firestore
        .collection('e_legal')
        .doc('conf')
        .collection('rooms')
        .doc(roomIdOrigin)
        .snapshots().first.then((value) async {
      print('obtenido');
      await _firestore
          .collection('e_legal')
          .doc('conf')
          .collection('history')
          .doc(roomIdTest).set({
        'createdAt': value.data()!['createdAt'],
        'imageUrl': value.data()!['imageUrl'],
        'metadata': null,
        'name': null,//value.data()!['name'],
        'paymentId': null,//value.data()!['paymentId'],
        'status': value.data()!['status'],
        'statusPayment': value.data()!['statusPayment'],
        'type': value.data()!['type'],
        'updatedAt': value.data()!['updatedAt'],
        'userIds': value.data()!['userIds'],
        'userRoles': null//value.data()!['userRoles'],
      });
    });

    print('obtiene infoUser');
    await _firestore
        .collection('e_legal')
        .doc('conf')
        .collection('rooms')
        .doc(roomIdOrigin)
        .collection('infoUser')
        .get().then((value) async {

      value.docs.forEach((element) async {

        print('obtenido');
        await _firestore
            .collection('e_legal')
            .doc('conf')
            .collection('history')
            .doc(roomIdTest)
            .collection('infoUser')
            .doc(element.id).set({
          'device': element.data()!['data'],
          'lawyer': element.data()!['lawyer'],
          'date': element.data()!['date'],
          'user': element.data()!['user'],
          'description': element.data()!['description'],
          'status': element.data()!['status'],
          'categoria': element.data()!['categoria'],
          'telefono': element.data()!['telefono'],
          'nombre': element.data()!['nombre'],
        });
      });

    });

    print('obtiene messgge');
    await _firestore
        .collection('e_legal')
        .doc('conf')
        .collection('rooms')
        .doc(roomIdOrigin)
        .collection('messages')
        .get().then((value) async {

      value.docs.forEach((mss) async {

        print('obtenido');
        await _firestore
            .collection('e_legal')
            .doc('conf')
            .collection('history')
            .doc(roomIdTest)
            .collection('messages')
            .doc(mss.id).set({
          'authorId': mss.data()['authorId'],
          'createdAt': mss.data()['createdAt'],
          'type': mss.data()['type'],
          'updatedAt': mss.data()['updatedAt'],
          'text': mss.data()['text'],
          'custom': mss.data()['custom'],
          'metadata': mss.data()['metadata'],

        });
      });

    });

    await FirebaseFirestore.instance.collection('e_legal').doc('conf').collection('rooms').doc(roomIdOrigin).delete();

    showMyDialog('TERMINADO', context);

  }
}
