import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_legal/auth/register.dart';
import 'package:e_legal/src/main_tutorial.dart';
import 'package:e_legal/wid/global_functions.dart';
import 'package:e_legal/wid/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:e_legal/wid/size_config.dart';
import 'package:e_legal/wid/users.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginState();
  }
}

class _LoginState extends State<Login> {

  final GoogleSignIn googleSignIn = GoogleSignIn();
  late String cellNumber;
  late String number;
  var countryCode = '52';
  bool _obscure = true;
  bool isButtonPressed = false;
  SocialUser socialUser = SocialUser();
  bool _loggingIn = false;
  FocusNode? _focusNode;
  String? device;

  int op = 0;

  final TextEditingController? _passwordController = TextEditingController();
  final TextEditingController? _usernameController = TextEditingController();

  final TextEditingController _mailRestoreController = TextEditingController();

  Map<String, dynamic>? _userData;

  late GoogleSignIn _googleSignIn;

  @override
  void initState() {
    // TODO: implement initState
    _googleSignIn = GoogleSignIn(
      // Optional clientId
      // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
      scopes: <String>[
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    super.initState();
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    _passwordController?.dispose();
    _usernameController?.dispose();
    super.dispose();
  }

  _loginfb() async {
    try {

      FocusScope.of(context).unfocus();
      final userData;
      print('0');
      // final LoginResult result = await FacebookAuth.instance.login().onError((error, stackTrace) {
      //   throw UnimplementedError();
      // });
      // final LoginResult result = await FacebookAuth.instance.expressLogin();
      // final facebookSignIn = FacebookLogin();
      // facebookSignIn.loginBehavior = FacebookLoginBehavior.webOnly;
      final LoginResult result = await FacebookAuth.instance.login();
      print('Token: ' + result.accessToken!.token);
      print('1');
      final AuthCredential facebookCredential = FacebookAuthProvider.credential(result.accessToken!.token);
      print('2');
      final usercredential = await FirebaseAuth.instance.signInWithCredential(facebookCredential);
      loggedWith = 3;
      print('3: ' + loggedWith.toString());
      userData = await FacebookAuth.instance.getUserData();
      print('4');
      _userData = userData;
      userFacebook = _userData;
      print(_userData);

      print('5');

      bool uidd = FirebaseAuth.instance.currentUser!.uid.isNotEmpty;
      String uidString = FirebaseAuth.instance.currentUser!.uid;

      print(uidd);
      print(uidString);
      //UPDATE DEVICE
      if(uidd){
        var getdevice = await OneSignal.shared.getDeviceState();
        device = getdevice?.userId;
        // errDevice = device!;

        print('update device: ' + device!);
        await FirebaseFirestore.instance
            .collection('e_legal')
            .doc('conf')
            .collection('users')
            .doc(uidString)
            .update({'metadata.device': device}).catchError((onError) async {
          print(onError);
          switch (onError.toString().substring(1, onError.toString().indexOf(']'))) {
            case 'firebase_auth/wrong-password':
              showMyDialog(
                  'Contraseña incorrecta.\nPorfavor revisa tu contraseña',
                  context);
              break;
            case 'cloud_firestore/not-found':
              print('Usuario no existe');
              await FirebaseChatCore.instance.createUserInFirestore(
                types.User(
                  firstName: userFacebook!['name'].toString().substring(0,userFacebook!['name'].toString().indexOf(' ')),
                  id: FirebaseAuth.instance.currentUser!.uid,
                  role: types.Role.user,
                  metadata: {
                    'phone': '',
                    'device': device
                  },
                  imageUrl: userFacebook!['picture']['data']['url'],
                  lastName: userFacebook!['name'].toString().substring(userFacebook!['name'].toString().indexOf(' '), userFacebook!['name'].toString().length),
                ),
              ).whenComplete(() async {

                loggedWith = 3;
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('logged', 'yes');
                print('final');
                Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (Route<dynamic> route) => false);

              });
              break;
            default:

              break;
          }
        });
      }

      loggedWith = 3;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('logged', 'yes');
      print('final');
      Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (Route<dynamic> route) => false);

    } catch (e) {

      print('Error: $e'); // Prints 401.

      FirebaseFirestore.instance.collection('bugs').add({
        'date': DateTime.now().toString(),
        'bug': e.toString(),
        'page': 'login with facebook',
        'device': device!
      });

      if(e.toString()!='Null check operator used on a null value') {
        print('err1');
        switch (e.toString().substring(1, e.toString().indexOf(']'))) {
          case 'firebase_auth/wrong-password':
            showMyDialog(
                'Contraseña incorrecta.\nPorfavor revisa tu contraseña',
                context);
            break;
        // case 'cloud_firestore/not-found':
        //   showMyDialog(
        //       'Usuario no identificado\nSi es la primera vez que ingresas, accede a la sección registrar',
        //       context);
        //   break;
          default:
            setState(() {
              _loggingIn = false;
            });

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
      } else {
        print('err2');
        showMyDialog('Versión de android incompatible\n Intenta ingresar con tu correo', context);
      }
    }
  }

  void _login() async {
    try {

      FocusScope.of(context).unfocus();

      setState(() {
        _loggingIn = true;
      });

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _usernameController!.text,
        password: _passwordController!.text,
      ).then((value) => userId = value.user!.uid);

      //UPDATE DEVICE
      var getdevice = await OneSignal.shared.getDeviceState();
      String? device = getdevice?.userId;

      try {
        print('update device: try');
        await FirebaseFirestore.instance.collection('e_legal').doc('conf')
            .collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'metadata.device': device
        });
      } catch(onE){
        showMyDialog('Tu dispositivo no pudo actualizarse', context);
      }

      loggedWith = 1;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('logged', 'yes');
      Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (Route<dynamic> route) => false);

    } catch (e) {

      print('Error: $e'); // Prints 401.
      switch (e.toString().substring(1,e.toString().indexOf(']'))){
        case 'firebase_auth/wrong-password':
          print('op');
          showMyDialog('Contraseña incorrecta.\nPorfavor revisa tu contraseña', context);
          break;
        case 'firebase_auth/user-not-found':
          print('op');
          showMyDialog('Tu usuario no fue encontrado. Porfavor registrate.', context).then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage(_usernameController!.text.isEmpty ? '': _usernameController!.text))));
          break;
        default:
          setState(() {
            _loggingIn = false;
          });

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
                  'Revisa tu cuenta y tu contraseña.\nCódigo de error: ' + e.toString()
                // e.toString(),
              ),
              title: const Text('Error de autentificación'),
            ),
          );
          break;
      }
    }
  }

  _loginGoogle() async {
    // int counterror = 0;

    try {

      // String currentTest = '';
      // await FirebaseFirestore.instance.collection('test').add({
      //   'date': DateTime.now(),
      //   'a': 'Google Sign In'
      // }).then((value) => currentTest = value.id);
      // counterror++;
      // print('Google sign');
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      // counterror++;
      // DocumentReference refTest = FirebaseFirestore.instance.collection('test').doc(currentTest);
      // counterror++;
      // print('nombre');
      // await refTest.update({
      //   'b' : 'B - Inicio para obtener datos'
      // });
      // counterror++;
      // print(googleSignInAccount!.displayName);
      // print(googleSignInAccount.email);
      // counterror++;
      // await refTest.update({
      //   'c' : 'C - ' + googleSignInAccount.displayName! + ' / ' + googleSignInAccount.email
      // }).onError((error, stackTrace) => refTest.update({
      //   'response': 'BUG',
      //   'optionresponse': 'C',
      //   'error': error.toString()
      // }));
      // counterror++;
      final GoogleSignInAuthentication? authentication = await googleSignInAccount?.authentication;
      // counterror++;
      // print(authentication!.idToken);
      // counterror++;
      // await refTest.update({
      //   'd' : 'D - ' + authentication.idToken!
      // }).onError((error, stackTrace) => refTest.update({
      //   'response': 'BUG',
      //   'optionresponse': 'D',
      //   'error': error.toString()
      // }));
      // counterror++;
      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: authentication?.accessToken,
          idToken: authentication?.idToken);
      // counterror++;
      // await refTest.update({
      //   'e' : 'E - ' + credential.toString()
      // }).onError((error, stackTrace) => refTest.update({
      //   'response': 'BUG',
      //   'optionresponse': 'E',
      //   'error': error.toString()
      // }));
      // counterror++;
      // print('Token:');
      // print(credential.toString());
      // counterror++;
      FocusScope.of(context).unfocus();
      // counterror++;
      setState(() {
        _loggingIn = true;
      });
      // counterror++;
      await FirebaseAuth.instance.signInWithCredential(credential).then((value) => userId = value.user!.uid);
      // counterror++;
      //UPDATE DEVICE
      var getdevice = await OneSignal.shared.getDeviceState();
      String? device = getdevice?.userId;
      // counterror++;
      try {
        // print('update device: try');
        // counterror++;
        await FirebaseFirestore.instance.collection('e_legal').doc('conf')
            .collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'metadata.device': device
        }).catchError((onError) async {
          // counterror++;
          await FirebaseChatCore.instance.createUserInFirestore(
            types.User(
              firstName: FirebaseAuth.instance.currentUser!.displayName?.substring(0,FirebaseAuth.instance.currentUser!.displayName?.indexOf(' ')),
              id: FirebaseAuth.instance.currentUser!.uid,
              role: types.Role.user,
              metadata: {
                'phone': '',
                'device': device
              },
              imageUrl: FirebaseAuth.instance.currentUser!.photoURL,
              lastName: FirebaseAuth.instance.currentUser!.displayName?.substring(FirebaseAuth.instance.currentUser?.displayName?.indexOf(' ') as int, FirebaseAuth.instance.currentUser!.displayName?.length),
            ),
          ).whenComplete(() async {
            // counterror = counterror + 500;
            loggedWith = 2;
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('logged', 'yes');
            print('final');
            Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (Route<dynamic> route) => false);

          });
        });
      } catch(onE){
        showMyDialog('Tu dispositivo no pudo actualizarse', context);
      }
      // counterror++;
      loggedWith = 2;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // counterror++;
      prefs.setString('logged', 'yes');
      Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (Route<dynamic> route) => false);
      // counterror++;
    } catch (e) {

      print('Error: $e'); // Prints 401.
      switch (e.toString().substring(1,e.toString().indexOf(']'))){
        case 'firebase_auth/wrong-password':
          print('op');
          showMyDialog('Contraseña incorrecta.\nPorfavor revisa tu contraseña', context);
          break;
        case 'cloud_firestore/unknown':
          showMyDialog('Error al actualizar información de perfil\nCódigo de error: ' + e.toString() , context);
          break;
        case 'firebase_auth/user-not-found':
          print('op');
          await FirebaseChatCore.instance.createUserInFirestore(
            types.User(
              firstName: FirebaseAuth.instance.currentUser!.displayName,
              id: FirebaseAuth.instance.currentUser!.uid,
              role: types.Role.user,
              metadata: {
                'phone': '',
                'device': device
              },
              imageUrl: FirebaseAuth.instance.currentUser!.photoURL,
              lastName: FirebaseAuth.instance.currentUser!.displayName,
            ),
          ).whenComplete(() async {

            loggedWith = 3;
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('logged', 'yes');
            print('final');
            Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (Route<dynamic> route) => false);

          });
          break;
        default:
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _loggingIn = false;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
              content: Text(
                  'Revisa tu cuenta y tu contraseña.\nCódigo de error: ' + e.toString()
                // e.toString(),
              ),
              title: const Text('Error de autentificación'),
            ),
          );
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Container(
              height: SizeConfig.blockSizeVertical! * 100,
              width: SizeConfig.blockSizeHorizontal! * 100,
              decoration: const BoxDecoration(
                color: Color(0xff000000),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[

                    Center(
                      child: Container(
                        // color: Colors.white,
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.05
                        ),
                        child:  Image(
                          width: SizeConfig.blockSizeHorizontal! * 80,
                          height: SizeConfig.blockSizeVertical! * 30,
                          image: const AssetImage('assets/img/logoblanco.png'),
                        )
                      ),
                    ),

                    Center(
                      child: Container(
                        margin: const EdgeInsets.all(10.0),
                        height: MediaQuery.of(context).size.height * 0.55,
                        width: MediaQuery.of(context).size.width * 0.85,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(40.0))
                        ),
                        child: _mainBody()
                      ),
                    ),

                  ]
              )
          ),
        )
    );
  }

  _mainBody (){

    switch (op) {
      case 0:
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              SizedBox(height: MediaQuery.of(context).size.height * 0.05,),

              Padding(
                padding: const EdgeInsets.only(right: 15, left: 15),
                child: GestureDetector(
                  onTap: () {
                    op = 1;
                    setState(() {
                      op;
                    });
                  },
                  child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(2.5)),
                      ),
                      child: const Center(child: Text('Iniciar sesión', style: TextStyle(fontSize: 15, color: Colors.black),),)
                  ),
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.02,),

              Padding(
                padding: const EdgeInsets.only(right: 15, left: 15),
                child: GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage(_usernameController!.text.isEmpty ? '': _usernameController!.text))),
                  child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(2.5)),
                      ),
                      child: const Center(child: Text('Registrar', style: TextStyle(fontSize: 15, color: Colors.black),),)
                  ),
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.02,),

              const Padding(
                padding: EdgeInsets.only(right: 15, left: 15),
                child: Divider(height: 2, thickness: 2,),
              ),

              // SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
              //
              // Padding(
              //   padding: const EdgeInsets.only(right: 15, left: 15),
              //   child: GestureDetector(
              //     onTap: () => _loginfb(),
              //     child: Container(
              //         height: 45,
              //         decoration: BoxDecoration(
              //           border: Border.all(
              //             color: Colors.blueAccent,
              //           ),
              //           borderRadius: const BorderRadius.all(Radius.circular(2.5)),
              //         ),
              //         child: Center(child: Row(
              //           children: [
              //             const SizedBox(width: 15,),
              //             // Icon(Icons.face, color: Colors.blue,),
              //             SizedBox(child: Image.asset('assets/facebook_logo.png'), height: 30,),
              //             const SizedBox(width: 15,),
              //             const Expanded(child: Text('Iniciar sesión con Facebook', style: TextStyle(fontSize: 15, color: Colors.blueAccent),)),
              //           ],
              //         ),)
              //     ),
              //   ),
              // ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.02,),

              Padding(
                padding: const EdgeInsets.only(right: 15, left: 15),
                child: GestureDetector(
                  onTap: () => _loginGoogle(),
                  child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(2.5)),
                      ),
                      child: Center(child: Row(
                        children: [
                          const SizedBox(width: 15,),
                          SizedBox(child: Image.asset('assets/logo_google.png'), height: 30,),
                          const SizedBox(width: 15,),
                          const Expanded(child: Text('Iniciar sesión con Google', style: TextStyle(fontSize: 15, color: Colors.black),)),
                        ],
                      ),)
                  ),
                ),
              ),

            ],),
        );
      case 1:
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(height: MediaQuery.of(context).size.height * 0.07,),

              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: TextField(
                    autocorrect: false,
                    autofocus: true,
                    controller: _usernameController,
                    decoration: InputDecoration(
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      labelText: 'Correo',
                      labelStyle: const TextStyle(
                          color: Colors.black
                      ),
                      // suffix: GestureDetector(
                      //     onTap: (){
                      //       _usernameController!.text = _usernameController!.text + '@hotmail.com';
                      //     },
                      //     child: const Icon(Icons.mail)),
                      suffixIcon: IconButton(
                        color: Colors.black,
                        icon: const Icon(Icons.cancel),
                        onPressed: () => _usernameController!.clear(),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.none,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () {
                      _focusNode?.requestFocus();
                    },
                  ),
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.02,),

              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: TextField(
                    autocorrect: false,
                    autofocus: false,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      labelText: 'Contraseña',
                      labelStyle: const TextStyle(
                          color: Colors.black
                      ),
                      suffix: GestureDetector(
                          onTap: (){
                            setState(() {
                              _obscure = !_obscure;
                            });
                          },
                          child: Icon(Icons.remove_red_eye)),
                      suffixIcon: IconButton(
                        color: Colors.black,
                        icon: const Icon(Icons.cancel),
                        onPressed: () => _passwordController!.clear(),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    obscureText: _obscure,
                    textCapitalization: TextCapitalization.none,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => _login(),
                  ),
                ),
              ),

              // Align(
              //   alignment: Alignment.centerRight,
              //   child: SizedBox(
              //     width: MediaQuery.of(context).size.width * 0.60,
              //     child: Row(
              //       mainAxisSize: MainAxisSize.max,
              //       children: [
              //
              //         Expanded(
              //           child: GestureDetector(
              //             onTap: () => setState(() {
              //               op = 0;
              //             }),
              //             child: const Text('Regresar', style: TextStyle(color: Colors.black, fontSize: 12.0),),
              //           ),
              //         ),
              //
              //         Expanded(
              //           child: GestureDetector(
              //             onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage(_usernameController!.text.isEmpty ? '': _usernameController!.text))),
              //             child: const Text('Registrar', style: TextStyle(color: Colors.black, fontSize: 12.0),),
              //           ),
              //         ),
              //
              //         Expanded(
              //           child: GestureDetector(
              //             onTap: () {
              //               if(_loggingIn) {
              //                 FocusManager.instance.primaryFocus?.unfocus();
              //                 _login();
              //               } else {
              //                 setState(() {
              //                   _loggingIn = !(_loggingIn);
              //                 });
              //               }
              //             },
              //             child: const Text('Ingresar', style: TextStyle(color: Colors.black, fontSize: 12.0),),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.03,),

              GestureDetector(
                onTap: (){

                  if(_usernameController!.text.toString().isEmpty){
                    Alert(
                        context: context,
                        content: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.75,
                                child: TextField(
                                  controller: _mailRestoreController,
                                  autocorrect: false,
                                  decoration: const InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                    labelText: 'Correo',
                                    labelStyle: TextStyle(
                                        color: Colors.black
                                    ),
                                  ),
                                  keyboardType: TextInputType.text,
                                  textCapitalization: TextCapitalization.sentences,
                                  textInputAction: TextInputAction.next,
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
                              FocusManager.instance.primaryFocus?.unfocus();

                              try {
                                if (_usernameController!.text.toString().isEmpty) {
                                  await FirebaseAuth.instance.sendPasswordResetEmail(email: _mailRestoreController.text);
                                } else {
                                  await FirebaseAuth.instance.sendPasswordResetEmail(email: _usernameController!.text);

                                }

                                const snackBar = SnackBar(
                                  content: Text('Correo enviado correctamente. Revisa la bandeja de spam en caso de no identificar el correo'),
                                  duration: Duration(seconds: 4),
                                  backgroundColor: (Colors.black12),
                                );

                                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                              } catch (onerr){
                                print('Snackerror: ' + onerr.toString());
                                showMyDialog('No se logró enviar el correo. Revisa la cuenta: Code Details: ' + onerr.toString(), context);
                              }
                            },
                            child: const Text(
                              "RECUPERAR",
                              style: const TextStyle(color: Colors.white, fontSize: 20),
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
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: TextField(
                                controller: _usernameController,
                                autocorrect: false,
                                decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                  labelText: 'Correo',
                                  labelStyle: TextStyle(
                                      color: Colors.black
                                  ),
                                ),
                                keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.sentences,
                                textInputAction: TextInputAction.next,
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
                            FocusManager.instance.primaryFocus?.unfocus();

                            try {
                              if (_usernameController!.text.toString().isEmpty) {
                                await FirebaseAuth.instance.sendPasswordResetEmail(email: _mailRestoreController.text);
                              } else {
                                await FirebaseAuth.instance.sendPasswordResetEmail(email: _usernameController!.text);
                              }

                              const snackBar = SnackBar(
                                content: Text('Correo enviado correctamente. Revisa la bandeja de spam en caso de no identificar el correo'),
                                duration: Duration(seconds: 4),
                                backgroundColor: (Colors.black12),
                              );

                              ScaffoldMessenger.of(context).showSnackBar(snackBar);

                            } catch (onerr){
                              print('Snackerror: ' + onerr.toString());
                              showMyDialog('No se logró enviar el correo. Revisa la cuenta: Code Details: ' + onerr.toString(), context);
                            }

                          },
                          child: const Text(
                            "RECUPERAR",
                            style: const TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),

                      ]).show();
                  }

                },
                child: SizedBox(width: MediaQuery.of(context).size.width * 0.75, child: const Align(alignment: Alignment.topRight, child: Text('Recuperar contraseña', style: TextStyle(fontSize: 14),)),)
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.03,),

              GestureDetector(
                onTap: (){
                  if(_loggingIn) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    _login();
                  } else {
                    setState(() {
                      _loggingIn = !(_loggingIn);
                    });
                  }
                },
                child: Container(
                  margin: const EdgeInsets.all(10.0),
                  height: 45,
                  width: MediaQuery.of(context).size.width * 0.85,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(5.0))
                  ),
                  child: const Center(child: Text('Ingresar', style: TextStyle(color: Colors.white),))
                ),
              ),

            ]
          ),
        );
      case 2:
        return GestureDetector(
            onTap: (){
              print('opcion previa $op');
              setState(() {
                op = 1;
              });
            },
            child: Center(child: Text('opcion 2', style: TextStyle(fontSize: 30, color: Colors.red),)));
      default:
        return GestureDetector(
            onTap: (){
              print('opcion previa $op');
              op = 3;
              setState(() {
              });
            },
            child: Center(child: Text('opcion default', style: TextStyle(fontSize: 30, color: Colors.red),)));

    }
  }

}



