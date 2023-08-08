import 'package:flutter/material.dart';
import 'package:toktok_app/helpers/size_config.dart';
import 'package:toktok_app/app_localizations.dart';

class LeftDrawer extends StatefulWidget{
  final String name;
  final String lastName;
  final String picture;
  final String email;

  LeftDrawer({Key key, @required this.name, @required this.lastName, @required this.picture, @required this.email}) : super(key: key);

  @override
  _LeftDrawer createState() => new _LeftDrawer(name, lastName, picture, email);

}

class _LeftDrawer extends State<LeftDrawer> with TickerProviderStateMixin{
  Animation animationToRight;
  AnimationController animationController;
  String name;
  String lastName;
  String picture;
  String email;
  bool toggleProfile = false;

  _LeftDrawer(this.name, this.lastName, this.picture, this.email);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Container(
      height: SizeConfig.safeBlockVertical * 35,
      width: SizeConfig.safeBlockHorizontal * 75,
      decoration: BoxDecoration(
        color: Color.fromRGBO(238, 238, 238, 1.0),
      ),
      child: Column(
        children: <Widget>[
          Container(
              height: SizeConfig.blockSizeVertical * 15,
              decoration: BoxDecoration(
                  color: Colors.black
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    width: SizeConfig.blockSizeVertical * 10,
                    height: SizeConfig.blockSizeHorizontal * 20,
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
                      '${widget.name} ${widget.lastName}',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0
                      ),
                    ),
                  ),
                ],
              )
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical * 2,
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
                SizedBox(width: SizeConfig.blockSizeHorizontal * 22),
                InkWell(
                  onTap: ((){
                    setState(() {
                      toggleProfile = false;
                    });
                    Navigator.pop(context);
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

        ],
      ),
    );
  }

}