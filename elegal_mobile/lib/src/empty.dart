import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_legal/auth/register.dart';
import 'package:e_legal/src/main_tutorial.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:e_legal/wid/size_config.dart';
import 'package:e_legal/wid/users.dart';

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
  final TextEditingController? _passwordController = TextEditingController();
  final TextEditingController? _usernameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    _passwordController?.dispose();
    _usernameController?.dispose();
    super.dispose();
  }

  void _login() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _loggingIn = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _usernameController!.text,
        password: _passwordController!.text,
      );
      Navigator.of(context)
          .pushNamedAndRemoveUntil(
          '/welcome', (
          Route<dynamic> route) => false);
    } catch (e) {
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
          content: const Text(
              'Revisa tu cuenta y tu contraseña'
            // e.toString(),
          ),
          title: const Text('Error de autentificación'),
        ),
      );
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
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                SizedBox(height: MediaQuery.of(context).size.height * 0.04,),

                                Center(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.75,
                                    child: TextField(
                                      autocorrect: false,
                                      controller: _usernameController,
                                      decoration: InputDecoration(
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white, width: 5.0),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white, width: 5.0),
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
                                        suffix: GestureDetector(
                                            onTap: (){
                                              _usernameController!.text = _usernameController!.text + '@hotmail.com';
                                            },
                                            child: const Icon(Icons.mail)),
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

                                _password(),

                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    // color: Colors.black,
                                    width: MediaQuery.of(context).size.width * 0.40,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [

                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage(_usernameController!.text.isEmpty ? '': _usernameController!.text))),
                                            child: const Text('Registrar', style: TextStyle(color: Colors.black, fontSize: 12.0),),
                                          ),
                                        ),

                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              if(_loggingIn) {
                                                FocusManager.instance.primaryFocus?.unfocus();
                                                _login();
                                              } else {
                                                setState(() {
                                                  _loggingIn = !(_loggingIn);
                                                });
                                              }
                                            },
                                            child: Text('Ingresar', style: TextStyle(color: Colors.black, fontSize: 12.0),),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),


                                SizedBox(height: MediaQuery.of(context).size.height * 0.08,),

                                Center(
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.60,
                                      height: MediaQuery.of(context).size.height * 0.20,
                                      child: Column(
                                        children: [

                                          GestureDetector(
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                    height: 50.0,
                                                    child: Image.network('https://firebasestorage.googleapis.com/v0/b/mingdevelopment-site.appspot.com/o/e_legal%2Fconf%2Foth%2Fgoogle.png?alt=media&token=a3b46898-6390-489d-a828-49a03957ac9f')),
                                                const Expanded(child: Text('     Iniciar sesión con Google')),
                                              ],
                                            ),
                                            onTap: () async {
                                              try {
                                                final GoogleSignInAccount? googleSignInAccount = await googleSignIn
                                                    .signIn();

                                                final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!
                                                    .authentication;

                                                final AuthCredential credential = GoogleAuthProvider
                                                    .credential(
                                                  accessToken: googleSignInAuthentication
                                                      .accessToken,
                                                  idToken: googleSignInAuthentication
                                                      .idToken,
                                                );

                                                await FirebaseAuth.instance.signInWithCredential(credential);

                                                FirebaseFirestore.instance
                                                    .collection('e_legal')
                                                    .doc('conf')
                                                    .collection('users')
                                                    .get()
                                                    .then((val) {
                                                  val.docs.forEach((element) {
                                                    if(element.id==FirebaseAuth.instance.currentUser?.uid){
                                                      Navigator.of(context)
                                                          .pushNamedAndRemoveUntil(
                                                          '/welcome', (
                                                          Route<dynamic> route) => false);
                                                    } else {
                                                      print('-------------------------------------------------------------------');
                                                      showDialog(
                                                          context: context,
                                                          builder: (_) => const AlertDialog(
                                                            content: Text("Usuario no registrado"),
                                                          ));
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage('@gmail')));
                                                    }

                                                  });
                                                });

                                                // Navigator.of(context)
                                                //     .pushNamedAndRemoveUntil(
                                                //     '/welcome', (
                                                //     Route<dynamic> route) => false);

                                                // Navigator.push(
                                                //     context, MaterialPageRoute(builder: (context) => const RegisterPage()));

                                              } catch(onError){
                                                print('err: ' + onError.toString());
                                              }
                                            },
                                          ),

                                          SizedBox(height: MediaQuery.of(context).size.height * 0.02,),

                                          GestureDetector(
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                    height: 50.0,
                                                    child: Image.asset('assets/img/tuto.png')),
                                                const Expanded(child: Text('     Tutorial')),
                                              ],
                                            ),
                                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MainTutorialPage())),
                                          ),

                                        ],
                                      )),
                                ),

                              ],),
                          )
                      ),
                    ),

                  ]
              )
          ),
        )
    );
  }

  _password(){
    print(_loggingIn);
    if(!(_loggingIn)) {
      return Container();
    } else {
      return Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.75,
          child: TextField(
            autocorrect: false,
            autofocus: true,
            controller: _passwordController,
            decoration: InputDecoration(
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 5.0),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 5.0),
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
      );
    }
  }

}



