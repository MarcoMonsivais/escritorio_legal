import 'package:e_legal/wid/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../wid/global_functions.dart';

class RegisterPage extends StatefulWidget {
  final String mail;

  const RegisterPage(this.mail);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  FocusNode? _focusNode;
  bool _registering = false;
  bool _obscure = true;
  bool isChecked = false;

  final TextEditingController? _passwordController = TextEditingController();
  final TextEditingController? _usernameController = TextEditingController();
  final TextEditingController? _firstNameController = TextEditingController();
  final TextEditingController? _lastNameController = TextEditingController();
  final TextEditingController? _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _usernameController!.text = widget.mail;
    if (loggedWith == 3) {
      _usernameController!.text = userFacebook!['email'];
    }
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    _passwordController?.dispose();
    _usernameController?.dispose();
    super.dispose();
  }

  void _register() async {

    FirebaseChatCore.instance.config = const FirebaseChatCoreConfig('escritorio-legal', '/e_legal/conf/rooms/', '/e_legal/conf/users/');

    try {
      var getdevice = await OneSignal.shared.getDeviceState();
      String? device = getdevice?.userId;

      if (loggedWith == 3) {
        await FirebaseChatCore.instance.createUserInFirestore(
          types.User(
            firstName: userFacebook!['name']
                .toString()
                .substring(0, userFacebook!['name'].toString().indexOf(' ')),
            id: FirebaseAuth.instance.currentUser!.uid,
            role: types.Role.user,
            metadata: {
              'phone': _phoneNumberController!.text,
              'device': device,
              'mail': _usernameController!.text
            },
            imageUrl: userFacebook!['picture']['data']['url'],
            lastName: userFacebook!['name'].toString().substring(
                userFacebook!['name'].toString().indexOf(' '),
                userFacebook!['name'].toString().length),
          ),
        );
      } else {
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: _usernameController!.text,
              password: _passwordController!.text,
            )
            .then((value) => userId = value.user!.uid);
        await FirebaseChatCore.instance.createUserInFirestore(
          types.User(
            firstName: _firstNameController!.text,
            id: userId,
            role: types.Role.user,
            metadata: {
              'phone': _phoneNumberController!.text,
              'device': device,
              'mail': _usernameController!.text
            },
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/escritorio-legal.appspot.com/o/profile.webp?alt=media&token=841e2dd0-5bca-4f27-99ff-ab499255d2bf',
            lastName: _lastNameController!.text,
          ),
        );
      }

      Navigator.of(context)
          .pushNamedAndRemoveUntil('/welcome', (Route<dynamic> route) => false);
    } catch (e) {
      print('Error: $e'); // Prints 401.
      switch (e.toString().substring(1, e.toString().indexOf(']'))) {
        case 'firebase_auth/user-not-found':
          print('op1');
          showMyDialog(
                  'Tu usuario no fue encontrado. Porfavor registrate.', context)
              .then((value) => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RegisterPage(
                          _usernameController!.text.isEmpty
                              ? ''
                              : _usernameController!.text))));
          break;
        case 'firebase_auth/weak-password':
          print('op2');
          showMyDialog(
              'La contraseña debe contener al menos 6 carácteres', context);
          break;
        default:
          setState(() {
            _registering = false;
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
                  'Error al crear usuario.\nCódigo de error: ' + e.toString()
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
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
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
                              top: MediaQuery.of(context).size.height * 0.08),
                          child: Image(
                            height: MediaQuery.of(context).size.height * 0.10,
                            width: MediaQuery.of(context).size.width * 0.30,
                            image:
                                const AssetImage('assets/img/logoblanco.png'),
                          )),
                    ),
                    Center(
                      child: Container(
                          margin: const EdgeInsets.all(10.0),
                          height: MediaQuery.of(context).size.height * 0.75,
                          width: MediaQuery.of(context).size.width * 0.85,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40.0))),
                          child: SingleChildScrollView(
                            // scrollDirection: Axis.horizontal,
                            // physics: const NeverScrollableScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.03,
                                ),

                                Center(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.75,
                                    child: TextField(
                                      autocorrect: false,
                                      controller: _usernameController,
                                      decoration: InputDecoration(
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 5.0),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 5.0),
                                        ),
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                        ),
                                        labelText: 'Correo',
                                        labelStyle: const TextStyle(
                                            color: Colors.black),
                                        suffix: GestureDetector(
                                            onTap: () {
                                              _usernameController!.text =
                                                  _usernameController!.text +
                                                      '@hotmail.com';
                                            },
                                            child: const Icon(Icons.mail)),
                                        suffixIcon: IconButton(
                                          color: Colors.black,
                                          icon: const Icon(Icons.cancel),
                                          onPressed: () =>
                                              _usernameController!.clear(),
                                        ),
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      textCapitalization:
                                          TextCapitalization.none,
                                      textInputAction: TextInputAction.next,
                                      onEditingComplete: () {
                                        _focusNode?.requestFocus();
                                      },
                                    ),
                                  ),
                                ),

                                Center(
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 5.0),
                                    width: MediaQuery.of(context).size.width *
                                        0.75,
                                    child: TextField(
                                      autocorrect: false,
                                      controller: _firstNameController,
                                      decoration: InputDecoration(
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 5.0),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 5.0),
                                        ),
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                        ),
                                        labelText: 'Nombre(s)',
                                        labelStyle: const TextStyle(
                                            color: Colors.black),
                                        suffixIcon: IconButton(
                                          color: Colors.black,
                                          icon: const Icon(Icons.cancel),
                                          onPressed: () =>
                                              _firstNameController?.clear(),
                                        ),
                                      ),
                                      keyboardType: TextInputType.name,
                                      onEditingComplete: () {
                                        _focusNode?.requestFocus();
                                      },
                                      readOnly: _registering,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      textInputAction: TextInputAction.next,
                                    ),
                                  ),
                                ),

                                Center(
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 5.0),
                                    width: MediaQuery.of(context).size.width *
                                        0.75,
                                    child: TextField(
                                      autocorrect: false,
                                      controller: _lastNameController,
                                      decoration: InputDecoration(
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 5.0),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 5.0),
                                        ),
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                        ),
                                        labelText: 'Apellidos',
                                        labelStyle: const TextStyle(
                                            color: Colors.black),
                                        suffixIcon: IconButton(
                                          color: Colors.black,
                                          icon: const Icon(Icons.cancel),
                                          onPressed: () =>
                                              _lastNameController?.clear(),
                                        ),
                                      ),
                                      keyboardType: TextInputType.name,
                                      onEditingComplete: () {
                                        _focusNode?.requestFocus();
                                      },
                                      readOnly: _registering,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      textInputAction: TextInputAction.next,
                                    ),
                                  ),
                                ),

                                Center(
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 5.0),
                                    width: MediaQuery.of(context).size.width *
                                        0.75,
                                    child: TextField(
                                      autocorrect: false,
                                      controller: _phoneNumberController,
                                      decoration: InputDecoration(
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 5.0),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 5.0),
                                        ),
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                        ),
                                        labelText: 'Telefono',
                                        labelStyle: const TextStyle(
                                            color: Colors.black),
                                        suffixIcon: IconButton(
                                          color: Colors.black,
                                          icon: const Icon(Icons.cancel),
                                          onPressed: () =>
                                              _phoneNumberController?.clear(),
                                        ),
                                      ),
                                      keyboardType: TextInputType.phone,
                                      onEditingComplete: () {
                                        _focusNode?.requestFocus();
                                      },
                                      readOnly: _registering,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      textInputAction: TextInputAction.next,
                                    ),
                                  ),
                                ),

                                loggedWith != 3
                                    ? Center(
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(top: 5.0),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.75,
                                          child: TextField(
                                            autocorrect: false,
                                            // autofillHints: _registering ? null : [AutofillHints.password],
                                            controller: _passwordController,
                                            decoration: InputDecoration(
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white,
                                                    width: 5.0),
                                              ),
                                              enabledBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white,
                                                    width: 5.0),
                                              ),
                                              border: const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8),
                                                ),
                                              ),
                                              labelText: 'Contraseña',
                                              labelStyle: const TextStyle(
                                                  color: Colors.black),
                                              suffix: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      _obscure = !_obscure;
                                                    });
                                                  },
                                                  child: const Icon(
                                                      Icons.remove_red_eye)),
                                              suffixIcon: IconButton(
                                                color: Colors.black,
                                                icon: const Icon(Icons.cancel),
                                                onPressed: () =>
                                                    _passwordController
                                                        ?.clear(),
                                              ),
                                            ),
                                            focusNode: _focusNode,
                                            keyboardType: TextInputType.text,
                                            obscureText: _obscure,
                                            // onEditingComplete: _register,
                                            textCapitalization:
                                                TextCapitalization.none,
                                            // textInputAction: TextInputAction.done,
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink(),

                                ///V2.03.01
                                SizedBox(
                                  height: 25,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Checkbox(
                                        checkColor: Colors.white,
                                        fillColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.black),
                                        value: isChecked,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            isChecked = value!;
                                          });
                                        },
                                      ),
                                      Expanded(
                                          child: GestureDetector(
                                        onTap: () async => await launchUrl(
                                            Uri.parse(
                                                'https://firebasestorage.googleapis.com/v0/b/escritorio-legal.appspot.com/o/AVISO%20DE%20PRIVACIDAD%20Y%20TYC.docx.pdf?alt=media&token=8d55f595-ff22-4013-b68a-40603857f613'),
                                            mode: LaunchMode
                                                .externalNonBrowserApplication),
                                        child: RichText(
                                          text: const TextSpan(
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 10),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text:
                                                    'Estoy de acuerdo en enviar mi información de acuerdo al ',
                                              ),
                                              TextSpan(
                                                  text: 'aviso de privacidad',
                                                  style: TextStyle(
                                                      decoration: TextDecoration
                                                          .underline,
                                                      color: Colors.blue)),
                                              TextSpan(
                                                text: ' plasmado en este medio',
                                              ),
                                            ],
                                          ),
                                        ),
                                      )),
                                    ],
                                  ),
                                ),

                                ///V2.02.28

                                Center(
                                  child: GestureDetector(
                                    onTap: () => isChecked
                                        ? _register()
                                        : showMyDialog(
                                            'Debes aceptar los términos y condiciones para crear tu cuenta',
                                            context),
                                    child: Container(
                                      margin: const EdgeInsets.all(10.0),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      width: MediaQuery.of(context).size.width *
                                          0.85,
                                      decoration: const BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      child: const Center(
                                          child: Text(
                                        'Registrar',
                                        style: TextStyle(color: Colors.white),
                                      )),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ])),
        ));
  }
}
