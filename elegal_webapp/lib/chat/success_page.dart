import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/global_functions.dart';
import '../perfil/perfil_page.dart';
import '../welcome/welcome.dart';

class SuccessPage extends StatefulWidget{


  @override
  _SuccessPageState createState() => _SuccessPageState();

}

class _SuccessPageState extends State<SuccessPage> {

  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [

          Container(
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width,
            color: Colors.black,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => Welcome())),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: Text('Escritorio Legal', style: TextStyle(color: Colors.white, fontSize: 16),),
                  ),
                ),
                const SizedBox(width: 550,),
                GestureDetector(onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => PerfilPage())), child: const Text('Mi cuenta', style: TextStyle(color: Colors.white, fontSize: 16),)),
                GestureDetector(
                  onTap: () => logout(context),
                  child: const Padding(
                    padding: EdgeInsets.only(right: 30),
                    child: Text('Cerrar sesión', style: TextStyle(color: Colors.white, fontSize: 16),),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
          const Text('ASESORIA EN CURSO', style: TextStyle(fontSize: 27),),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
          Center(
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.05
              ),
              child: const Image(
                width: 270,
                height: 270,
                image: AssetImage('assets/waiting.png'),
              )
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
          SizedBox(width: MediaQuery.of(context).size.width * 0.30, child: const Text('¡Enhorabuena! Tu pago ha sido recibido y nuestro equipo de asesores se encuentra revisando tu caso. Recibirás una notificación en cuanto este siendo atendido', style: TextStyle(fontSize: 15), textAlign: TextAlign.center,)),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
          GestureDetector(
            onDoubleTap: () => showMyDialog('Tu caso ha sido enviado', context),
            onTap: () async {
              try {

                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Creando peticion..."),
                    duration: Duration(milliseconds: 300),
                ));

                List<String> devices = ['000'];
               String notificationId = '';
                ///V20
                String locationOp = '';
                String categoryOp = '';


                SharedPreferences prefs = await SharedPreferences.getInstance();
                notificationId = prefs.getString('notificationId') ?? "";
                ///V20
                locationOp = prefs.getString('locationOp') ?? "";
                categoryOp = prefs.getString('categoryOp') ?? "";
                

                await FirebaseFirestore.instance.collection('e_legal').doc('conf').collection('users')//.where('role', isEqualTo: 'agent')
                    ///V20
                    .where('role', isEqualTo: 'agent')
                    .where('metadata.location', isEqualTo: locationOp)
                    ///V20
                    .snapshots().forEach((element) async {


                  for (var i = 0; i < element.docs.length; ++i) {
                    DocumentSnapshot ds = element.docs[i];
                    List<dynamic> entities = ds['metadata.entity'];
                    if(entities.contains(categoryOp)){
                      if(ds['metadata.device'].toString().isNotEmpty && ds['metadata.device'].toString().length >= 22){
                        devices.add(ds['metadata.device']);
                      }
                    }

                  }

                  devices.removeAt(0);

                  await post(
                    Uri.parse(
                        'https://onesignal.com/api/v1/notifications'),
                    headers: <String, String>{
                      'Content-Type':
                      'application/json; charset=UTF-8',
                    },
                    body: jsonEncode(<String, dynamic>{
                      "app_id": '0d781e5f-f216-4ba9-80b1-e2b525eed7c6',
                      "include_player_ids": devices.toSet().toList(),
                      "android_accent_color": "green",
                      "small_icon": "icon",
                      "headings": {
                        "en": 'Nueva solicitud'
                      },
                      "contents": {
                        "en": 'Presiona para ver los detalles'
                      },
                      "data": {
                        "messageId": 'solicitud:' + notificationId,
                      }
                    }),
                  ).whenComplete(() => print('notification creada: ' + devices.toSet().toList().toString() + ' / ' + notificationId));

                  await FirebaseFirestore.instance.collection('requests').doc(notificationId).update({'status': 'active'});

                  await Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Welcome()), (Route<dynamic> route) => false);

                });


              } catch(onError){
                print('Fetal error: ' + onError.toString());
              }
            },
            child: Container(
              margin: const EdgeInsets.all(10.0),
              height: 45,
              width: MediaQuery.of(context).size.width * 0.30,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(5.0))
              ),
              child: Center(child: const Text('Entendido', style: TextStyle(color: Colors.white)))
            ),
          ),
        ],
      ),
    );
  }
}