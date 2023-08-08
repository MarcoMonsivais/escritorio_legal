import 'package:flutter/material.dart';
import 'package:toktok_app/helpers/size_config.dart';

class NoPaymentAlert extends StatelessWidget {
  final String title;
  final String description;
  final int type;
  NoPaymentAlert(this.title, this.description, this.type);

  @override
  Widget build(BuildContext context) {
    String image;
    Color alertColor;
    if(this.type == 1) {
      image = 'assets/img/logonegro.png';
      alertColor = Colors.black;
    }
    else if (this.type == 2) {
      image = 'assets/img/logonegro.png';
      alertColor = Colors.black;
    }
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(20.0)), //this right here
      child: Container(
        height: SizeConfig.blockSizeVertical * 52,
//        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(height: SizeConfig.blockSizeVertical * 20, child: Image(image: AssetImage(image), width: SizeConfig.blockSizeHorizontal * 30)),
//            SizedBox(height: SizeConfig.blockSizeVertical * 1),
            Container(child: Text(this.title, style: TextStyle(color: alertColor, fontSize: SizeConfig.blockSizeVertical * 4.2, fontWeight: FontWeight.w600), textAlign: TextAlign.center,)),
            SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
            Container(height: SizeConfig.blockSizeVertical * 13, child: SingleChildScrollView(child: Text(this.description, style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 2), textAlign: TextAlign.center,))),
            SizedBox(height: SizeConfig.blockSizeVertical * 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15),
                  // width:  SizeConfig.blockSizeHorizontal* 35,
                  height: SizeConfig.blockSizeVertical * 4,
                  child: RaisedButton(
                    child: new Text("Close"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    disabledColor: Color(0xFFE14300),
                    color: Color(0xFF000000),
                    textColor: Colors.white,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 15),
                  // width:  SizeConfig.blockSizeHorizontal* 35,
                  height: SizeConfig.blockSizeVertical * 4,
                  child: RaisedButton(
                    child: Text("Add Method"),
                    onPressed: () {
                      Navigator.of(context).popAndPushNamed("/addPaymentMethod");
                    },
                    disabledColor: Color(0xFFE14300),
                    color: Colors.green,
                    textColor: Colors.white,
                  ),
                )
              ],
            ),

          ],
        ),
      ),
    );
  }

}