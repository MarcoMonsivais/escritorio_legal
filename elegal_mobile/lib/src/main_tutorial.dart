import 'package:e_legal/auth/login.dart';
import 'package:e_legal/main.dart';
import 'package:e_legal/wid/globals.dart' as Globals;
import 'package:e_legal/wid/size_config.dart';
import 'package:e_legal/wid/slide_dots.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;
import 'welcome.dart';

class Slide {
  final String imagePath;
  final String title;
  final String description;

  Slide(
      {required this.imagePath,
      required this.title,
      required this.description});
}

class MainTutorialPage extends StatefulWidget {
  @override
  _MainTutorialPageState createState() => _MainTutorialPageState();
}

class _MainTutorialPageState extends State<MainTutorialPage> {
  final slideListiOs = [
    Slide(
        imagePath: "assets/img/Asset1.png",
        title: "Obtener asesoría legal nunca fue tan fácil.",
        description:
            "Simplemente regístrate en un solo paso y obtendrás asesoría legal."),
    Slide(
        imagePath: "assets/img/Asset2.png",
        title: "Dictámenes.",
        description:
            "Tu asesoría por escrito elaborada y firmada por un abogado con experiencia."),
    Slide(
        imagePath: "assets/img/Asset3.png",
        title: "Pólizas.",
        description:
            "Pólizas anuales con consultas limitadas a un bajo costo."),
    Slide(
        imagePath: "assets/img/privacy1.png",
        title: "Privacidad",
        description:
            "Siéntete tranquilo, toda la información que nos proporciones está protegida por el secreto entre abogado y cliente."),
  ];

  final slideList = [
    Slide(
        imagePath: "assets/img/Asset1.png",
        title: "Obtener asesoria legal nunca fue tan facil",
        description:
            "Simplemente registrate en un solo paso y obtendras asesoria legal en la palma de tu mano."),
    Slide(
        imagePath: "assets/img/Asset2.png",
        title: "Dictámenes",
        description:
            "Tu asesoría por escrito elaborada y firmada por un abogado con experiencia."),
    Slide(
        imagePath: "assets/img/Asset3.png",
        title: "Pólizas",
        description:
            "Pólizas anuales con consultas limitadas a un bajo costo."),
    Slide(
        imagePath: "assets/img/privacy1.png",
        title: "Privacidad",
        description:
            "Siéntete tranquilo, desde el momento en el que ingresas a nuestra aplicación para obtener una Asesoría Legal, toda la información que nos proporciones estará protegida por el secreto profesional contemplada en la Ley de Profesiones del Estado de Nuevo León, así como supletoriamente en la Ley Reglamentaria del Artículo 5 Constitucional relativo al ejercicio de las Profesiones."),
  ];

  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    // print(FirebaseAuth.instance.currentUser!.uid);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index) {
    setState(() => _currentPage = index);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              SizedBox(height: 40),
              Expanded(
                  child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                    PageView.builder(
                        onPageChanged: _onPageChanged,
                        scrollDirection: Axis.horizontal,
                        controller: _pageController,
                        itemCount: slideList.length,
                        itemBuilder: (ctx, idx) => TutorialContent(idx)),
                    Stack(
                      alignment: AlignmentDirectional.topStart,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 35),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (int i = 0; i < slideList.length; i++)
                                (i == _currentPage)
                                    ? SlideDots(true)
                                    : SlideDots(false)
                            ],
                          ),
                        )
                      ],
                    )
                  ])),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      color: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: TextButton(
                          onPressed: () async {
                            Globals.logged = true;
                            // print(Globals.logged.toString());

                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            String? loggedBefore;

                            try {
                              loggedBefore = prefs.getString('logged');
                              print('Logged Before: ' + loggedBefore!);
                            } catch (onError) {
                              loggedBefore = '';
                            }

                            if (loggedBefore == '') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()));
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Welcome()));
                              //Navigator.of(context).pop();
                            }
                          },
                          style: TextButton.styleFrom(
                            primary: Colors.black,
                            foregroundColor: Colors.black,
                            // textStyle: TextStyle(color: Colors.white,),
                          ),
                          child: Text(
                            _currentPage == 3 ? 'Finalizar' : 'Saltar',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (_currentPage <= 2)
                      Container(
                        color: Colors.black,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: TextButton(
                              onPressed: () => _nextPage(),
                              style: TextButton.styleFrom(
                                primary: Colors.black,
                                foregroundColor: Colors.black,
                                // textStyle: TextStyle(color: Colors.white,),
                              ),
                              child: const Text(
                                'Siguiente',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )),
                        ),
                      )
                  ]),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  _nextPage() {
    setState(() {
      _currentPage++;
    });

    _pageController.animateToPage(_currentPage,
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }
}

class TutorialContent extends StatelessWidget {
  final int index;

  TutorialContent(this.index);

  final slideListiOs = [
    Slide(
        imagePath: "assets/img/Asset1.png",
        title: "Obtener asesoría legal nunca fue tan fácil.",
        description:
            "Simplemente regístrate en un solo paso y obtendrás asesoría legal."),
    Slide(
        imagePath: "assets/img/Asset2.png",
        title: "Dictámenes.",
        description:
            "Tu asesoría por escrito elaborada y firmada por un abogado con experiencia."),
    Slide(
        imagePath: "assets/img/Asset3.png",
        title: "Pólizas.",
        description:
            "Pólizas anuales con consultas limitadas a un bajo costo."),
    Slide(
        imagePath: "assets/img/privacy1.png",
        title: "Privacidad",
        description:
            "Siéntete tranquilo, toda la información que nos proporciones está protegida por el secreto entre abogado y cliente."),
  ];

  final slideList = [
    Slide(
        imagePath: "assets/img/Asset1.png",
        title: "Obtener Asesoría Legal nunca fue tan fácil",
        description:
            "Simplemente regístrate en un solo paso y obtendrás Asesoría Legal en la palma de tu mano."),
    Slide(
        imagePath: "assets/img/Asset2.png",
        title: "Dictámenes",
        description:
            "Tu Asesoría Legal por escrito, elaborada y firmada por un abogado capacitado."),
    Slide(
        imagePath: "assets/img/Asset3.png",
        title: "Pólizas",
        description:
            "Obtén Asesorías Legales ilimitadas durante el plazo de tu póliza con una pequeña inversión."),
    Slide(
        imagePath: "assets/privacy1.png",
        title: "Privacidad",
        description:
            "Siéntete tranquilo, desde el momento en el que ingresas a nuestra aplicación para obtener una Asesoría Legal, toda la información que nos proporciones estará protegida por el secreto profesional contemplada en la Ley de Profesiones del Estado de Nuevo León, así como supletoriamente en la Ley Reglamentaria del Artículo 5 Constitucional relativo al ejercicio de las Profesiones."),
  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Column(children: [
      Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
              Platform.isIOS
                  ? slideListiOs[index].title
                  : slideList[index].title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 24.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold))),
      Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          margin: const EdgeInsets.only(top: 40, bottom: 20),
          child: Image(
            image: AssetImage(Platform.isIOS
                ? slideListiOs[index].imagePath
                : slideList[index].imagePath),
            width: SizeConfig.safeBlockHorizontal! * 80,
            height: SizeConfig.safeBlockVertical! * 35,
          )),
      Container(
          margin: const EdgeInsets.only(bottom: 45),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
              Platform.isIOS
                  ? slideListiOs[index].description
                  : slideList[index].description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 17.0, color: Colors.black)))
    ]);
  }
}
