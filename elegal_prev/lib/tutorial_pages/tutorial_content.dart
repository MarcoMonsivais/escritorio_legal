import 'package:flutter/material.dart';
import 'package:toktok_app/helpers/size_config.dart';
import 'slide.dart';

class TutorialContent extends StatelessWidget {
  final int index;
  TutorialContent(this.index);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            slideList[index].title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.black,
              fontWeight: FontWeight.bold
            )
          )
        ),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            margin: EdgeInsets.only(top: 40, bottom: 20),
            child: Image(
              image: AssetImage(slideList[index].imagePath),
              width: SizeConfig.safeBlockHorizontal * 80,
              height: SizeConfig.safeBlockVertical * 35,
            )
        ),
        Container(
            margin: EdgeInsets.only(bottom: 45),
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
                slideList[index].description,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black
                )
            )
        )
      ]
    );
  }
}
