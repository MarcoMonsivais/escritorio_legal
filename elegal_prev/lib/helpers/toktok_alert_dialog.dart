import 'package:flutter/material.dart';
import 'package:toktok_app/helpers/size_config.dart';

class TokTokAlertDialog extends StatelessWidget {
  final String title;
  final String description;
  final int type;
  TokTokAlertDialog(this.title, this.description, this.type);

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
            Container(
              width:  SizeConfig.blockSizeHorizontal* 350,
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
            )
          ],
        ),
      ),
    );
  }

}