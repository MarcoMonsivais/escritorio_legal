import 'package:firebase_auth_web/firebase_auth_web.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:url_launcher/url_launcher.dart';

class Register extends StatefulWidget{

  const Register();

  @override
  _RegisterState createState() => _RegisterState();

}

class _RegisterState extends State<Register> {

  FocusNode? _focusNode;
  final bool _registering = false;
  bool _obscure = true;
  bool isChecked = false;

  String userId = '';

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController= TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.30,
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(40.0))
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [


              SizedBox(height: MediaQuery.of(context).size.height * 0.03,),

              const Text('Bienvenido a Escritorio Legal', style: TextStyle(fontSize: 24, color: Colors.black),),
              const Text('Queremos conocerte', style: TextStyle(fontSize: 18, color: Colors.black),),

              SizedBox(height: MediaQuery.of(context).size.height * 0.04,),

              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.27,
                  child: TextField(
                    autocorrect: false,
                    controller: _usernameController,
                    decoration: InputDecoration(
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.5),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.5),
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(6),
                        ),
                      ),
                      labelText: 'Correo',
                      labelStyle: const TextStyle(
                          color: Colors.black
                      ),
                      suffix: GestureDetector(
                          onTap: (){
                            _usernameController.text = _usernameController.text + '@hotmail.com';
                          },
                          child: const Icon(Icons.mail)
                      ),
                      suffixIcon: IconButton(
                        color: Colors.black,
                        icon: const Icon(Icons.cancel),
                        onPressed: () => _usernameController.clear(),
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

              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  width: MediaQuery.of(context).size.width * 0.27,
                  child: TextField(
                    autocorrect: false,
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.5),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.5),
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(6),
                        ),
                      ),
                      labelText: 'Nombre(s)',
                      labelStyle: const TextStyle(
                          color: Colors.black
                      ),
                      suffixIcon: IconButton(
                        color: Colors.black,
                        icon: const Icon(Icons.cancel),
                        onPressed: () => _firstNameController.clear(),
                      ),
                    ),
                    keyboardType: TextInputType.name,
                    onEditingComplete: () {
                      _focusNode?.requestFocus();
                    },
                    readOnly: _registering,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ),

              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  width: MediaQuery.of(context).size.width * 0.27,
                  child: TextField(
                    autocorrect: false,
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.5),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.5),
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(6),
                        ),
                      ),
                      labelText: 'Apellidos',
                      labelStyle: const TextStyle(
                          color: Colors.black
                      ),
                      suffixIcon: IconButton(
                        color: Colors.black,
                        icon: const Icon(Icons.cancel),
                        onPressed: () => _lastNameController.clear(),
                      ),
                    ),
                    keyboardType: TextInputType.name,
                    onEditingComplete: () {
                      _focusNode?.requestFocus();
                    },
                    readOnly: _registering,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ),

              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  width: MediaQuery.of(context).size.width * 0.27,
                  child: TextField(
                    autocorrect: false,
                    controller: _phoneNumberController,
                    decoration: InputDecoration(
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.5),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.5),
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(6),
                        ),
                      ),
                      labelText: 'Telefono',
                      labelStyle: const TextStyle(
                          color: Colors.black
                      ),
                      suffixIcon: IconButton(
                        color: Colors.black,
                        icon: const Icon(Icons.cancel),
                        onPressed: () => _phoneNumberController.clear(),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    onEditingComplete: () {
                      _focusNode?.requestFocus();
                    },
                    readOnly: _registering,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ),

              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  width: MediaQuery.of(context).size.width * 0.27,
                  child: TextField(
                    autocorrect: false,
                    // autofillHints: _registering ? null : [AutofillHints.password],
                    controller: _passwordController,
                    decoration: InputDecoration(
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.5),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.5),
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(6),
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
                          child: const Icon(Icons.remove_red_eye)),
                      suffixIcon: IconButton(
                        color: Colors.black,
                        icon: const Icon(Icons.cancel),
                        onPressed: () => _passwordController.clear(),
                      ),
                    ),
                    focusNode: _focusNode,
                    keyboardType: TextInputType.text,
                    obscureText: _obscure,
                    // onEditingComplete: _register,
                    textCapitalization: TextCapitalization.none,
                    // textInputAction: TextInputAction.done,
                  ),
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.02,),

              ///V21
              SizedBox(
                height: 25,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.all<Color>(Colors.black),
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    ),
                    Expanded(
                        child: GestureDetector(
                          onTap: () async => await launchUrl(Uri.parse('https://firebasestorage.googleapis.com/v0/b/escritorio-legal.appspot.com/o/AVISO%20DE%20PRIVACIDAD%20Y%20TYC.docx.pdf?alt=media&token=8d55f595-ff22-4013-b68a-40603857f613'), mode: LaunchMode.externalNonBrowserApplication),
                          child: RichText(
                            text: const TextSpan(
                              style: TextStyle(color: Colors.black, fontSize: 10),
                              children: <TextSpan>[
                                TextSpan(text: 'Estoy de acuerdo en enviar mi información de acuerdo al ',),
                                TextSpan(text: 'aviso de privacidad', style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue)),
                                TextSpan(text: ' plasmado en este medio',),
                              ],
                            ),
                          ),
                        )
                    ),
                  ],
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.02,),

              Center(
                child: GestureDetector(
                  onTap: () => _register(),
                  child: Container(
                    margin: const EdgeInsets.all(2.0),
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width * 0.27,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                    ),
                    child: const Center(child: Text('Registrar', style: TextStyle(color: Colors.white),)),),
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.02,),

              Center(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false),
                  child: Container(
                    margin: const EdgeInsets.all(2.0),
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width * 0.27,
                    decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(10.0))
                    ),
                    child: const Center(child: Text('Regresar', style: TextStyle(color: Colors.white),)),),
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.02,),

            ],
          ),
        ),
      ),
    );
  }

  _register() async {

    FirebaseChatCore.instance.config = FirebaseChatCoreConfig('/e_legal/conf/rooms', '/e_legal/conf/users');

    await FirebaseAuthWeb.instance.createUserWithEmailAndPassword(_usernameController.text, _passwordController.text,).then((value) => userId = value.user!.uid);
      await FirebaseChatCore.instance.createUserInFirestore(
        types.User(
          firstName: _firstNameController.text,
          id: userId,
          role: types.Role.user,
          metadata: {
            'phone': _phoneNumberController.text,
            'device': '',
            'mail': _usernameController.text
          },
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/mingdevelopment-site.appspot.com/o/e_legal%2Fconf%2Foth%2F14625742.jpg?alt=media&token=b522fbd3-e362-4152-801a-5190d2cdaa0f',
          lastName: _lastNameController.text,
        ),
      );

    Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (Route<dynamic> route) => false);

  }

}