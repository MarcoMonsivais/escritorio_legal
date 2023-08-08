import 'package:firebase_auth/firebase_auth.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_legal/src/waiting_page.dart';
import 'package:e_legal/wid/size_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:e_legal/wid/globals.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import '../wid/global_functions.dart';

class Reciept extends StatefulWidget{

  final String payId, monto, nombreUser, telefonoUser, categoryUser, descriptionUser;
  Reciept(this.payId, this.monto, this.nombreUser, this.telefonoUser, this.categoryUser, this.descriptionUser);

  @override
  State<StatefulWidget> createState() {
    print('recibo');
    return _RecieptState();
  }

}

class _RecieptState extends State<Reciept> with TickerProviderStateMixin {

  String impuestoString = 'ND', subtotalString = 'ND', totalString = 'ND';
  int impuestoInt = 0, subtotalInt = 0, totalInt = 0;
  bool isTapped = false;
  bool isPromo = false;

  List<String> devices = [];

  @override
  void initState() {
    // TODO: implement initState

    print('recibo2');
    _getDevices();

    if(widget.monto == 'GRATIS'){
      isPromo = true;
      subtotalString = 'GRATIS';
      impuestoString = 'SIN IMPUESTO';
      totalString = 'GRATIS';
    } else {
      try {
        impuestoInt = int.parse(widget.monto.replaceAll(',', ''));
        impuestoString = (impuestoInt * 0.16).toStringAsFixed(0);
        impuestoString = impuestoString.substring(0, impuestoString.length - 2);
      } catch (onError) {
        print('impuesto: ' + onError.toString());
        impuestoString = 'ERR';
      }

      try {
        if (widget.monto.length > 5) {
          totalInt = int.parse(widget.monto.replaceAll(',', '').substring(
              0, widget.monto.length - 3));
        } else {
          totalInt = int.parse(widget.monto.replaceAll(',', '').substring(
              0, widget.monto.length - 2));
        }

        impuestoInt = int.parse(impuestoString);
        subtotalInt = totalInt - impuestoInt;
        subtotalString = subtotalInt.toString();
      } catch (onError) {
        print('subtotal: ' + onError.toString());
        subtotalString = 'ERR';
      }

      try {
        totalString = widget.monto.substring(0, widget.monto.length - 2);
      } catch (onError) {
        totalString = 'ERR';
      }
    }
    super.initState();
  }

  _getDevices() async {
    print('recibo3');
    await FirebaseFirestore.instance.collection('e_legal').doc('conf').collection('users').where('role', isEqualTo: 'agent').snapshots().forEach((element) async {

      print('Element: ' + element.size.toString());
      ///GET DEVICES ACCORDING CATEGORY CASE
      for (var i = 0; i < element.docs.length; ++i) {
        DocumentSnapshot ds = element.docs[i];
        List<dynamic> entities = ds['metadata.entity'];
        print('Entity: ' + i.toString());
        if(entities.contains(widget.categoryUser)){
          if(ds['metadata.device'].toString().isNotEmpty && ds['metadata.device'].toString().length >= 22){
            devices.add(ds['metadata.device']);
          }
        }
      }

    }).whenComplete(() => setState(() => devices));

  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    print('recibo4');
    return Scaffold(
      body: Stack(
        children: [

          Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 10,
                    blurRadius: 5,
                    offset: Offset(0, 7), // changes position of shadow
                  ),
                ],
              ),
              child: Text(''),
            ),
          ),

          Column(
            children: <Widget>[
              SizedBox(height: SizeConfig.safeBlockVertical! * 15,),
              const Text(
                'Recibo de pago',
                style: TextStyle(
                    fontSize: 26.0,
                    fontWeight: FontWeight.w700
                ),
              ),
              Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      print(widget.monto);
                      print(widget.categoryUser);
                      print(widget.nombreUser);
                      print(widget.descriptionUser);
                      print(widget.payId);
                      print(widget.telefonoUser);
                      print(devices);
                    },
                    child: Container(
                      height: 150,
                      decoration: const BoxDecoration(
                        // color: Colors.tealAccent,
                        image: DecorationImage(
                          image: AssetImage("assets/img/recibo_logo.png"),
                          fit: BoxFit.fitHeight))),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                              'Concepto: ',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500
                              )
                          ),
                          SizedBox(height: SizeConfig.blockSizeHorizontal! * 5),const Text(
                              'Subtotal: ',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500
                              )
                          ),
                          SizedBox(height: SizeConfig.blockSizeHorizontal! * 5),
                          const Text(
                              'Impuesto: ',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500
                              )
                          ),
                          SizedBox(height: SizeConfig.blockSizeHorizontal! * 5),
                          const Text(
                              'Total: ',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500
                              )
                          ),
                        ],
                      ),

                      Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            const Text('Asesoría legal',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500
                                )
                            ),
                            SizedBox(height: SizeConfig.blockSizeHorizontal! * 5),Text(isPromo ? subtotalString : '\$' + subtotalString + '.00 MXN',
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500
                                )
                            ),
                            SizedBox(height: SizeConfig.blockSizeHorizontal! * 5),
                            SizedBox(
                              height: 17,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(isPromo ? impuestoString : '\$' + impuestoString + '.00 MXN  - 16% IVA'),
                                  // Text(' - 16% IVA', style: TextStyle(color: Colors.grey, fontSize: 10),),
                                ],
                              ),
                            ),
                            SizedBox(height: SizeConfig.blockSizeHorizontal! * 5),
                            Text(isPromo ? totalString : '\$' + totalString + '.00 MXN',
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500
                                )
                            ),
                          ]
                      )

                    ],
                  ),
                  SizedBox(height: SizeConfig.safeBlockVertical! * 5),
                  GestureDetector(
                    child: Container(
                      height: 30,
                      width: 250,
                      decoration: BoxDecoration(
                        color: Colors.black,
                          border: Border.all(
                            color: Colors.black,
                          ),
                          borderRadius:
                          const BorderRadius.all(
                              Radius.circular(10))),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Center(child: Text('Entendido', style: TextStyle(color: Colors.white),)),
                      )),
                    onTap: (() async {
                      try {
                          int progress = 0;

                          ProgressDialog pd = ProgressDialog(context: context);

                          pd.show(
                            hideValue: true,
                            max: 20,
                            msg: 'Creando petición...',
                            progressBgColor: Colors.transparent,
                          );

                         String notificationId = '';

                         var device = await OneSignal.shared.getDeviceState();

                         await FirebaseFirestore.instance.collection('requests').add({
                          'date': DateTime.now().toString(),
                          'name': widget.nombreUser,
                          'phone': widget.telefonoUser,
                          'category': widget.categoryUser,
                          'description': widget.descriptionUser,
                          'user': FirebaseAuth.instance.currentUser?.uid,
                          'device': device?.userId,
                          'status': 'active'
                         }).then((value) => notificationId = value.id);

                        print('progress $progress');
                        progress = progress + 10;
                        pd.update(value: progress, msg: 'Notificando abogados' );
                        await Future.delayed(const Duration(milliseconds: 1500));

                        await post(
                          Uri.parse('https://onesignal.com/api/v1/notifications'),
                          headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},
                          body: jsonEncode(<String, dynamic>{
                            "app_id": OneSignalId,
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

                          print('progress $progress');
                          progress = progress + 10;
                          pd.update(value: progress, msg: 'Casi listo...' );
                          await Future.delayed(const Duration(milliseconds: 1500));

                        await Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => WaitingPage()), (Route<dynamic> route) => false);

                      } catch(onError){
                        print(onError);
                      }

                    }),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
  
}

