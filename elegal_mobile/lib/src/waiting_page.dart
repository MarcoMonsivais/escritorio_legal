import 'package:e_legal/src/welcome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:e_legal/wid/size_config.dart';
import 'package:e_legal/wid/global_functions.dart';

class WaitingPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _WaitingPageState();
  }
}

class _WaitingPageState extends State<WaitingPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      drawer: menuLateral(context),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF000000),
        title: GestureDetector(
          onTap: (){
            setState(() {

            });
          },
          child: const Image(
            image: AssetImage('assets/img/navbarlogo.png'),
            width: 45.0,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[

          Center(
            child: Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.05
              ),
              child:  Image(
                width: SizeConfig.blockSizeHorizontal! * 80,
                height: SizeConfig.blockSizeVertical! * 30,
                image: const AssetImage('assets/waiting.png'),
              )
            ),
          ),

          Center(
            child: Container(
                margin: const EdgeInsets.all(10.0),
                height: MediaQuery.of(context).size.height * 0.40,
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: const BoxDecoration(
                    // color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(40.0))
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                      const Text('ASESORIA EN CURSO', style: TextStyle(fontSize: 27),),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                      const Text('¡Enhorabuena! Tu pago ha sido recibido y nuestro equipo de asesores se encuentra revisando tu caso. Recibirás una notificación en cuanto este siendo atendido', style: TextStyle(fontSize: 15), textAlign: TextAlign.center,),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Welcome()), (Route<dynamic> route) => false),
                        child: Container(
                          margin: const EdgeInsets.all(10.0),
                          height: 45,
                          width: MediaQuery.of(context).size.width * 0.85,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.all(Radius.circular(5.0))
                          ),
                          child: const Center(child: Text('ENTENDIDO', style: TextStyle(color: Colors.white),))
                        ),
                      ),

                    ],),
                )
            ),
          ),

        ]
      )
    );
  }


}



