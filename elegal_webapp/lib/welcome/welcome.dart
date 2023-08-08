import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegal/chat/success_page.dart';
import 'package:elegal/helpers/global_functions.dart';
import 'package:find_dropdown/find_dropdown.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../chat/chat_page.dart';
import '../checkout/stripe_checkout.dart';
import '../constants.dart';
import '../helpers/global.dart';
import '../helpers/slide_dots.dart';
import '../perfil/perfil_page.dart';

class Slide {
  final String imagePath;
  final String title;
  final String description;

  Slide({
    required this.imagePath,
    required this.title,
    required this.description
  });
}

class Welcome extends StatefulWidget{

  const Welcome();

  @override
  _WelcomeState createState() => _WelcomeState();

}

class _WelcomeState extends State<Welcome> {

  PageController pvcontroller = PageController();
  int optionPage = 0;
  int _currentPage = 0;
  String categoryOp = '';
  String locationOp = '';///V20


  final PageController _pageController = PageController(
      initialPage: 0
  );

  // final TextEditingController _nameController = TextEditingController();
  // final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final slideList = [
    Slide(
        imagePath: "assets/img/Asset1.png",
        title: "Obtener Asesoría legal nunca fue tan facil",
        description: "Simplemente registrate en un solo paso y obtendras Asesoría legal en la palma de tu mano."
    ),
    Slide(
        imagePath: "assets/img/Asset2.png",
        title: "Dictámenes",
        description: "Tu Asesoría por escrito elaborada y firmada por un abogado con experiencia."
    ),
    // Slide(
    //     imagePath: "assets/img/Asset3.png",
    //     title: "Pólizas",
    //     description: "Pólizas anuales con consultas limitadas a un bajo costo."
    // ),
    Slide(
        imagePath: "assets/img/privacy1.png",
        title: "Privacidad",
        description: "Siéntete tranquilo, desde el momento en el que ingresas a nuestra aplicación para obtener una Asesoría Legal, toda la información que nos proporciones estará protegida por el secreto profesional."
    ),
  ];

  List<ProblemList> problemUserList = [
    ProblemList(id: 'Laboral', description: 'Contrato a un trabajador, despidos, renuncias, etc.'),
    ProblemList(id: 'Penal', description: 'Delitos: robo, fraude, homicidio, daños en propiedad ajena, etc.'),
    ProblemList(id: 'Civil', description: 'Contratos en general, compraventas entre particulares'),
    ProblemList(id: 'Mercantil', description: 'Títulos de crédito: pagarés, cheques, etc.'),
    ProblemList(id: 'Familiar', description: 'Juicios sucesorios, juicios de divorcio, etc.'),
    ProblemList(id: 'Otro', description: ''),
    ProblemList(id: 'Lo desconozco', description: ''),
  ];
  ///V20-CAMBIO DE ORDEN DE CÓDIGO DE ESTADOS
  List<ProblemList> locationUserList = [
    ProblemList(id: 'Aguascalientes', description: 'AGU'),
    ProblemList(id: 'Baja California', description: 'BCN'),
    ProblemList(id: 'Baja California Sur', description: 'BCS'),
    ProblemList(id: 'Campeche', description: 'CAM'),
    ProblemList(id: 'Chiapas', description: 'CHP'),
    ProblemList(id: 'Chihuahua', description: 'CHH'),
    ProblemList(id: 'Coahuila', description: 'COA'),
    ProblemList(id: 'Colima', description: 'COL'),
    ProblemList(id: 'Ciudad de México', description: 'DIF'),
    ProblemList(id: 'Durango', description: 'DUR'),
    ProblemList(id: 'Guanajuato', description: 'GUA'),
    ProblemList(id: 'Guerrero', description: 'GRO'),
    ProblemList(id: 'Hidalgo', description: 'HID'),
    ProblemList(id: 'Jalisco', description: 'JAL'),
    ProblemList(id: 'México', description: 'MEX'),
    ProblemList(id: 'Michoacán', description: 'MIC'),
    ProblemList(id: 'Morelos', description: 'MOR'),
    ProblemList(id: 'Nacional', description: 'NAC'),
    ProblemList(id: 'Nayarit', description: 'NAY'),
    ProblemList(id: 'Nuevo León', description: 'NLE'),
    ProblemList(id: 'Oaxaca', description: 'OAX'),
    ProblemList(id: 'Puebla', description: 'PUE'),
    ProblemList(id: 'Querétaro', description: 'QUE'),
    ProblemList(id: 'Quintana Roo', description: 'ROO'),
    ProblemList(id: 'San Luis Potosí', description: 'SLP'),
    ProblemList(id: 'Sinaloa', description: 'SIN'),
    ProblemList(id: 'Sonora', description: 'SON'),
    ProblemList(id: 'Tabasco', description: 'TAB'),
    ProblemList(id: 'Tamaulipas', description: 'TAM'),
    ProblemList(id: 'Tlaxcala', description: 'TLA'),
    ProblemList(id: 'Veracruz', description: 'VER'),
    ProblemList(id: 'Yucatán', description: 'YUC'),
    ProblemList(id: 'Zacatecas', description: 'ZAC'),
  ];

  List<dynamic> entities = [];
  ///V20

  @override
  void initState(){
    super.initState();


  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [

        Container(
          height: MediaQuery.of(context).size.height * 0.06,
          width: MediaQuery.of(context).size.width,
          color: Colors.black,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () => setState((){}),
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

        SizedBox(
          height: MediaQuery.of(context).size.height * 0.20,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                Expanded(
                  child: SingleChildScrollView(
                    primary: false,
                    child: Column(
                      children: [
                        const SizedBox(height: 8,),
                        GestureDetector(
                          onTap: () => setState(() => optionPage = 1),
                          child: Image.asset('assets/policebasic.png',
                            height: 89,),
                        ),
                        const Text('Asesoría básica, 1 consulta.')
                      ],
                    ),
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 8,),
                        GestureDetector(
                          onTap: () => setState(() => optionPage = 2),
                          child: Image.asset('assets/promoproduct.gif',
                            height: 89,),
                        ),
                        const Text('Asesoría legal promoción')
                      ],
                    ),
                  ),
                ),
                //
                // Expanded(
                //   child: SingleChildScrollView(
                //     child: Column(
                //       children: [
                //         const SizedBox(height: 8,),
                //         GestureDetector(
                //           onTap: () => setState(() => optionPage = 3),
                //           child: Image.network('https://firebasestorage.googleapis.com/v0/b/mingdevelopment-site.appspot.com/o/e_legal%2Fproducts%2Flist%2Ficon-1.png?alt=media&token=18ebfa40-7811-44ea-babe-dde0431f2f9a',
                //             height: 89,),
                //         ),
                //         const Text('Póliza, 3 meses.')
                //       ],
                //     ),
                //   ),
                // ),
                //
                // Expanded(
                //   child: SingleChildScrollView(
                //     child: Column(
                //       children: [
                //         const SizedBox(height: 8,),
                //         GestureDetector(
                //           onTap: () => setState(() => optionPage = 4),
                //           child: Image.network('https://firebasestorage.googleapis.com/v0/b/mingdevelopment-site.appspot.com/o/e_legal%2Fproducts%2Flist%2Ficon-3.png?alt=media&token=db3e699d-0d4b-441d-88e9-680c78299ede',
                //             height: 89,),
                //         ),
                //         const Text('Póliza, 1 año.')
                //       ],
                //     ),
                //   ),
                // ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 8,),
                        GestureDetector(
                          onTap: () {
                            setState((){
                              optionPage = 0;
                            });
                          },
                          child: Image.asset('assets/tutorial.png',
                            height: 89,),
                        ),
                        const Text('Tutorial')
                      ],
                    ),
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 8,),
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => HistoryPage(),)),
                          child: Image.asset('assets/history.png',
                            height: 89,),
                        ),
                        const Text('Historial de Chats')
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),

        Flexible(child: SingleChildScrollView(
          primary: false,
          child: _body(),)),

      ],),

    );
  }

  _onPageChanged(int index) {
    setState(() => _currentPage = index);
  }

  _nextPage() {

    setState(() {
      _currentPage++;
    });

    _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn);
  }

  _body(){
    switch(optionPage){
      case 0:
        return SizedBox(
          width: MediaQuery.of(context).size.width * 0.45,
          height: MediaQuery.of(context).size.height * 0.70,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    PageView.builder(
                      onPageChanged: _onPageChanged,
                      scrollDirection: Axis.horizontal,
                      controller: _pageController,
                      itemCount: slideList.length,
                      itemBuilder: (ctx, idx) => TutorialContent(idx)
                    ),
                    Stack(
                      alignment: AlignmentDirectional.topStart,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for(int i = 0; i < slideList.length; i++)
                                (i == _currentPage) ? SlideDots(true) : SlideDots(false)
                            ],
                          ),
                        )
                      ],
                    )
                  ]
                )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    color: Colors.black,
                    child: TextButton(
                      onPressed: () async {
                        setState((){
                          _pageController.jumpToPage(0);
                          optionPage = 1;
                          _currentPage = 0;
                        });
                      },
                      style: TextButton.styleFrom(
                        primary: Colors.black,
                        foregroundColor: Colors.black,
                        // textStyle: TextStyle(color: Colors.white,),
                      ),
                      child: Text(
                          _currentPage == 3 ? 'Finalizar' : 'Saltar', style: TextStyle(color: Colors.white,),
                      ),
                    ),
                  ),
                  if(_currentPage <= 2) Container(
                    color: Colors.black,
                    child: TextButton(
                        onPressed: () => _nextPage(),
                        style: TextButton.styleFrom(
                          primary: Colors.black,
                          foregroundColor: Colors.black,
                        ),
                        child: const Text(
                            'Siguiente', style: TextStyle(color: Colors.white,),
                        )
                    ),
                  )
                ]
            ),
              // const SizedBox(height: 40),
          ]),
        );
      case 1:
        return FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('e_legal')
                .doc('products')
                .collection('list').where('description', isEqualTo: 'Consulta legal básica')
                .get(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(snapshot.connectionState == ConnectionState.done) {
                for (var i = 0; i < snapshot.data!.docs.length; ++i) {
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {

                      DocumentSnapshot<Object?>? ds = snapshot.data!.docs[index];

                      return Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(height: 60,),
                                Image.network(ds['img'], height: 190,),
                                const SizedBox(height: 30,),
                                Text(ds['headerdetails']),
                                const SizedBox(height: 15,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 70, right: 70),
                                  child: Center(child: Text(ds['details'], textAlign: TextAlign.center,)),
                                ),
                              ],
                            ),
                          ),
                          Expanded(

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [

                                const Text('Cuéntanos de tu problema'),

                                const Text('Antes de iniciar, nos gustaría conocer sobre tu problema legal, ¿Consideras que tu asunto es sobre alguno de los siguientes temas?', style: TextStyle(fontSize: 14, fontStyle: FontStyle.normal), textAlign: TextAlign.left,),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FindDropdown<ProblemList>(
                                    selectedItem: ProblemList(id:'Categoría', description: 'Categoría'),
                                    items: problemUserList,
                                    showSearchBox: false,
                                    onChanged: (ProblemList? data) => categoryOp = data!.id,
                                    dropdownItemBuilder: (BuildContext context, ProblemList item, bool isSelected) {
                                      return Container(
                                        decoration: !isSelected
                                            ? null
                                            : BoxDecoration(
                                          border: Border.all(color: Theme.of(context).primaryColor),
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.white,
                                        ),
                                        child: ListTile(
                                          selected: isSelected,
                                          title: Text(item.id),
                                          subtitle: Text(item.description),
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                const SizedBox(height: 10,),
                                const Text('¿De qué estado es tu caso?', style: TextStyle(fontSize: 11, fontStyle: FontStyle.normal), textAlign: TextAlign.center,),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FindDropdown<ProblemList>(
                                    selectedItem: ProblemList(id:'Estado', description: 'Estado'),
                                    items: locationUserList,
                                    showSearchBox: false,
                                    onChanged: (ProblemList? data) => locationOp = data!.id,
                                    dropdownItemBuilder: (BuildContext context, ProblemList item, bool isSelected) {
                                      return Container(
                                        decoration: !isSelected
                                            ? null
                                            : BoxDecoration(
                                          border: Border.all(color: Theme.of(context).primaryColor),
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.white,
                                        ),
                                        child: ListTile(
                                          selected: isSelected,
                                          title: Text(item.id),
                                          subtitle: Text(item.description),
                                        ),
                                      );
                                    },
                                  ),
                                ),


                                const Text('Agrega detalles de tu problema', style: TextStyle(fontSize: 14, fontStyle: FontStyle.normal), textAlign: TextAlign.left,),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: SizedBox(
                                      width:
                                      MediaQuery.of(context).size.width *
                                          0.75,
                                      child: TextField(
                                        autocorrect: false,
                                        controller: _descriptionController,
                                        decoration: const InputDecoration(
                                          focusedBorder:
                                          OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey,
                                                width: 1.0),
                                          ),
                                          enabledBorder:
                                          OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey,
                                                width: 1.0),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                          ),
                                          labelText: 'Descripción',
                                          labelStyle: TextStyle(
                                              color: Colors.black),
                                        ),
                                        keyboardType: TextInputType.none,
                                        textCapitalization: TextCapitalization.none,
                                        textInputAction: TextInputAction.next,
                                        maxLines: 3,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10,),

                                GestureDetector(
                                  ///V21
                                  onTap: () => _payment(ds['codeItem'], context, false),
                                  child: Container(
                                    margin: const EdgeInsets.all(10.0),
                                    height: 35,
                                    width: MediaQuery.of(context).size.width * 0.85,
                                    decoration: const BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5.0))),
                                    child: const Center(child: Text('SOLICITAR', style: TextStyle(color: Colors.white),)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );

                    });
                }
              }

              if(snapshot.hasError){
                return const SizedBox.shrink();
              }

              return const Center(child: CircularProgressIndicator(),);

            });
        ///v21
      case 2:
        return FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('e_legal')
                .doc('promos')
                .collection('list')
                // .where('description', isEqualTo: 'Consulta legal básica')
                .where('status', isEqualTo: 'active')
                .get(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(snapshot.connectionState == ConnectionState.done) {
                for (var i = 0; i < snapshot.data!.docs.length; ++i) {
                  return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {

                        DocumentSnapshot<Object?>? ds = snapshot.data!.docs[index];

                        return Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 60,),
                                  Image.network(ds['img'], height: 190,),
                                  const SizedBox(height: 30,),
                                  Text(ds['headerdetails']),
                                  const SizedBox(height: 15,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 70, right: 70),
                                    child: Center(child: Text(ds['details'], textAlign: TextAlign.center,)),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [

                                  const Text('Cuéntanos de tu problema'),

                                  const Text('Antes de iniciar, nos gustaría conocer sobre tu problema legal, ¿Consideras que tu asunto es sobre alguno de los siguientes temas?', style: TextStyle(fontSize: 14, fontStyle: FontStyle.normal), textAlign: TextAlign.left,),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FindDropdown<ProblemList>(
                                      selectedItem: ProblemList(id:'Categoría', description: 'Categoría'),
                                      items: problemUserList,
                                      showSearchBox: false,
                                      onChanged: (ProblemList? data) => categoryOp = data!.id,
                                      dropdownItemBuilder: (BuildContext context, ProblemList item, bool isSelected) {
                                        return Container(
                                          decoration: !isSelected
                                              ? null
                                              : BoxDecoration(
                                            border: Border.all(color: Theme.of(context).primaryColor),
                                            borderRadius: BorderRadius.circular(5),
                                            color: Colors.white,
                                          ),
                                          child: ListTile(
                                            selected: isSelected,
                                            title: Text(item.id),
                                            subtitle: Text(item.description),
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  const SizedBox(height: 10,),
                                  const Text('¿De qué estado es tu caso?', style: TextStyle(fontSize: 11, fontStyle: FontStyle.normal), textAlign: TextAlign.center,),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FindDropdown<ProblemList>(
                                      selectedItem: ProblemList(id:'Estado', description: 'Estado'),
                                      items: locationUserList,
                                      showSearchBox: false,
                                      onChanged: (ProblemList? data) => locationOp = data!.id,
                                      dropdownItemBuilder: (BuildContext context, ProblemList item, bool isSelected) {
                                        return Container(
                                          decoration: !isSelected
                                              ? null
                                              : BoxDecoration(
                                            border: Border.all(color: Theme.of(context).primaryColor),
                                            borderRadius: BorderRadius.circular(5),
                                            color: Colors.white,
                                          ),
                                          child: ListTile(
                                            selected: isSelected,
                                            title: Text(item.id),
                                            subtitle: Text(item.description),
                                          ),
                                        );
                                      },
                                    ),
                                  ),


                                  const Text('Agrega detalles de tu problema', style: TextStyle(fontSize: 14, fontStyle: FontStyle.normal), textAlign: TextAlign.left,),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: SizedBox(
                                        width:
                                        MediaQuery.of(context).size.width *
                                            0.75,
                                        child: TextField(
                                          autocorrect: false,
                                          controller: _descriptionController,
                                          decoration: const InputDecoration(
                                            focusedBorder:
                                            OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0),
                                            ),
                                            enabledBorder:
                                            OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                            ),
                                            labelText: 'Descripción',
                                            labelStyle: TextStyle(
                                                color: Colors.black),
                                          ),
                                          keyboardType: TextInputType.none,
                                          textCapitalization: TextCapitalization.none,
                                          textInputAction: TextInputAction.next,
                                          maxLines: 3,
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 10,),

                                  GestureDetector(
                                    ///V21
                                    onTap: () => _payment(ds['codeItem'], context, true),
                                    child: Container(
                                      margin: const EdgeInsets.all(10.0),
                                      height: 35,
                                      width: MediaQuery.of(context).size.width * 0.85,
                                      decoration: const BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0))),
                                      child: const Center(child: Text('SOLICITAR', style: TextStyle(color: Colors.white),)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );

                      });
                }
              }

              if(snapshot.hasError){
                return const SizedBox.shrink();
              }

              return const Center(child: CircularProgressIndicator(),);

            });
      case 5:
        return SizedBox(
          height: 350,
          child: Center(child: Text('HISTORIAL', style: Theme.of(context).textTheme.headline3,)),);
    }
  }

  _payment(codeId, context, promo) async {
    ///V20
    if(_descriptionController.text != '' && categoryOp != '' && locationOp != '') {

      codeItem = codeId;

      String nombreUser = '', phoneUser = '';
      try {
        await FirebaseFirestore.instance.collection('e_legal').doc('conf').collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
          nombreUser = value['firstName'] + ' ' + value['lastName'];
          phoneUser = value['metadata']['phone'];
        });
      } catch (onerr){
        nombreUser = 'Dato Erroneo';
        phoneUser = 'Dato Erroneo';
        print('Error: ' + onerr.toString());
      }

      final prefs = await SharedPreferences.getInstance();
      await FirebaseFirestore.instance.collection('requests').add({
        'date': DateTime.now().toString(),
        'name': nombreUser,
        'phone': phoneUser,
        'category': categoryOp,
        ///V20
        'location': locationOp,
        'description': _descriptionController.text,
        'user': FirebaseAuth.instance.currentUser?.uid,
        'device': '0000000-0000-000-000-000000000000',
        'status': 'inactive'
      }).then((value) async => await prefs.setString('notificationId', value.id));
      await prefs.setString('locationOp', locationOp);
      await prefs.setString('categoryOp', categoryOp);

      print('notId: ' + prefs.getString('notificationId')!);

      ///v21
      if(promo){
        Navigator.of(context).pushNamedAndRemoveUntil('/success', (Route<dynamic> route) => false);
      } else {
        redirectToCheckout(context);
      }

    } else {
      showMyDialog('Rellena la información faltante', context);
    }
  }

}

class TutorialContent extends StatelessWidget {

  final int index;
  double widTutorial = 110.0;
  double heigTutorial = 210.0;

  TutorialContent(this.index);

  final slideList = [
    Slide(
        imagePath: "assets/img/Asset1.png",
        title: "Obtener Asesoría Legal nunca fue tan fácil",
        description: "Simplemente regístrate en un solo paso y obtendrás Asesoría Legal en la palma de tu mano."
    ),
    Slide(
        imagePath: "assets/img/Asset2.png",
        title: "Dictámenes",
        description: "Tu Asesoría Legal por escrito, elaborada y firmada por un abogado capacitado."
    ),
    // Slide(
    //     imagePath: "assets/img/Asset3.png",
    //     title: "Pólizas",
    //     description: "Obtén Asesorías Legales ilimitadas durante el plazo de tu póliza con una pequeña inversión."
    // ),
    Slide(
        imagePath: "assets/img/privacy1.png",
        title: "Privacidad",
        description: "Siéntete tranquilo, desde el momento en el que ingresas a nuestra aplicación para obtener una Asesoría Legal, toda la información que nos proporciones estará protegida por el secreto profesional."
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      primary: false,
      child: Column(
          children: [
            Text(
              slideList[index].title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24.0,
                color: Colors.black,
                fontWeight: FontWeight.bold
              )
            ),
            Image(
              image: AssetImage(slideList[index].imagePath),
              width: widTutorial,
              height: heigTutorial,
            ),
            SizedBox(
              // color: Colors.orangeAccent,
              width: MediaQuery.of(context).size.width * 0.45,
              height: MediaQuery.of(context).size.height * 0.18,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  slideList[index].description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.black
                  )
                ),
              ),
            )
          ]
      ),
    );
  }

}

