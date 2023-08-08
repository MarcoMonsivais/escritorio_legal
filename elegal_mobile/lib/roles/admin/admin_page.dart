import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_legal/wid/global_functions.dart';
import 'package:flutter/material.dart';
import 'chat_master.dart';

class AdminPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _AdminPageState();
  }

}

class _AdminPageState extends State<AdminPage> with TickerProviderStateMixin {

  TextEditingController _user = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: menuLateral(context),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.message),
        backgroundColor: Colors.black,
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatMasterPage())),
      ),
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
      body: Stack(
        children: [

          Container(
            color: Colors.black,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),

          Center(
            child: Container(
              margin: const EdgeInsets.all(10.0),
              height: MediaQuery.of(context).size.height * 0.85,
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(40.0))
              ),
              child: FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance.collection('e_legal').doc('conf').collection('users').get(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

                  return PageView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {

                      DocumentSnapshot<Object?>? ds = snapshot.data!.docs[index];

                      return Center(
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 15, top: 15, left: 5, right: 5),
                            clipBehavior: Clip.none,
                            margin: const EdgeInsets.all(4.0),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(ds['imageUrl']),
                                Text(ds.id),
                                Text(ds['role']),
                                Text(ds['firstName']),
                                Text(ds['lastName']),
                                TextFormField(
                                  controller: _user,
                                  onEditingComplete: () async {
                                    _user.clear();
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    await FirebaseFirestore.instance.collection('e_legal').doc('conf').collection('users').doc(ds.id).update({
                                      'role': _user.text
                                    }).whenComplete(() => showMyDialog('Información actualizada', context)).whenComplete(() => setState(() => null));

                                  },
                                )
                              ],
                            )));
                    });
                }
              )
            ),
          ),

        ],
      ),
    );
  }
  
}