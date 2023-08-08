import 'package:flutter/material.dart';
import 'package:toktok_app/helpers/size_config.dart';
import 'package:toktok_app/app_localizations.dart';

class MenuProfile extends StatefulWidget{
  final String name;
  final String lastName;
  final String picture;
  final String email;

  MenuProfile({Key key, @required this.name, @required this.lastName, @required this.picture, @required this.email}) : super(key: key);

  @override
  _MenuProfile createState() => new _MenuProfile(name, lastName, picture, email);

}

class _MenuProfile extends State<MenuProfile> with TickerProviderStateMixin{
  Animation animationToRight;
  AnimationController animationController;
  String name;
  String lastName;
  String picture;
  String email;
  bool toggleProfile = false;

  _MenuProfile(this.name, this.lastName, this.picture, this.email);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(duration: Duration(seconds: 1), vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);


    animationToRight = Tween(begin: SizeConfig.safeBlockHorizontal * 1, end: SizeConfig.safeBlockHorizontal * 25).animate(CurvedAnimation(
        parent: animationController, curve: Curves.ease));

    animationController.forward();

    // TODO: implement build
    return toggleProfile ? AnimatedContainer(
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
      margin: EdgeInsets.only(
          top: SizeConfig.safeBlockVertical* 14,
          right: animationToRight.value
      ),
      height: SizeConfig.safeBlockVertical * 35,
      width: toggleProfile ? SizeConfig.safeBlockHorizontal * 75 : 0,
      decoration: BoxDecoration(
          color: Color.fromRGBO(238, 238, 238, 1.0),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0)
          )
      ),
      child: Column(
        children: <Widget>[
          GestureDetector(
            child: Container(
                height: SizeConfig.blockSizeVertical * 7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0)
                  ),
                  color: Colors.black
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: SizeConfig.blockSizeVertical * 5,
                      height: SizeConfig.blockSizeHorizontal * 10,
                      margin: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 5
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: new NetworkImage(widget.picture),
                            fit: BoxFit.cover
                        ),
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.blockSizeHorizontal * 5.0,
                    ),
                    Container(
                      width: SizeConfig.blockSizeHorizontal * 45.0,
                      child: Text(
                          widget.name,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0
                          ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 1.0, color: Colors.white)
                      ),
                      child: Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                        size: 22.0,
                      ),
                    )
                  ],
                )
            ),
            onTap: ((){
              setState(() {
                toggleProfile = false;
              });
            }),
          ),
          SizedBox(
            height: 15.0,
          ),
          Container(
            child: Row(
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).yourProfileInfo,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                  ),
                ),
                InkWell(
                  onTap: ((){
                    setState(() {
                      toggleProfile = false;
                    });
                    Navigator.of(context).pushNamed('/editProfile');
                  }),
                  child: Icon(
                    Icons.edit
                  ),
                )
              ],
            ),
            color: Colors.white,
            width: SizeConfig.blockSizeHorizontal * 100,
            padding: EdgeInsets.only(
              left: 10.0
            ),
          ),
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                    padding: EdgeInsets.only(
                        left: 16.0
                    ),
                    width: SizeConfig.blockSizeHorizontal * 22,
                    child: Text(
                      AppLocalizations.of(context).name,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                    width: SizeConfig.blockSizeHorizontal * 50,
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text('${widget.name} ${widget.lastName}'),
                  )
                ],
              ),
//              Row(
//                children: <Widget>[
//                  Container(
//                    margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1),
//                    padding: EdgeInsets.only(
//                        left: 16.0
//                    ),
//                    width: SizeConfig.blockSizeHorizontal * 22,
//                    child: Text(
//                      AppLocalizations.of(context).address,
//                      style: TextStyle(
//                          fontSize: 16.0,
//                          fontWeight: FontWeight.bold
//                      ),
//                    ),
//                  ),
//                  Container(
//                    margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1),
//                    width: SizeConfig.blockSizeHorizontal * 50,
//                    padding: EdgeInsets.only(left: 20.0),
//                    child: Text('Santa Clarita, California'),
//                  )
//                ],
//              ),
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1),
                    padding: EdgeInsets.only(
                        left: 16.0
                    ),
                    width: SizeConfig.blockSizeHorizontal * 22,
                    child: Text(
                      'Email',
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1),
                    width: SizeConfig.blockSizeHorizontal * 50,
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(widget.email),
                  )
                ],
              )
            ],
          ),
          Container(
            child: Text(
              AppLocalizations.of(context).yourVehicles,
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold
              ),
            ),
            color: Colors.white,
            width: SizeConfig.blockSizeHorizontal * 100,
            margin: EdgeInsets.only(top: SizeConfig.blockSizeHorizontal * 5),
            padding: EdgeInsets.only(
                left: 20.0
            ),
          ),
        ],
      ),
    ) : Container(
        padding: EdgeInsets.only(
          top: SizeConfig.blockSizeVertical*15,
        ),
        child: GestureDetector(
            onTap: ((){
              setState(() {
                this.toggleProfile = true;
              });
            }),
            child: Stack(
              children: <Widget>[
                Container(
                  width: SizeConfig.blockSizeHorizontal*15,
                  height: SizeConfig.blockSizeVertical*5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0)
                    ),
                    color: Colors.black,
                  ),
                ),
                Container(
                  width: SizeConfig.blockSizeVertical*7,
                  height: SizeConfig.blockSizeHorizontal*8,
                  margin: EdgeInsets.only(
                      top: SizeConfig.blockSizeVertical*1
                  ),
                  child: Image(
                    image: new NetworkImage(widget.picture),
                  ),
                ),
              ],
            )
        )
    );
  }

}