import 'package:flutter/material.dart';
import 'package:toktok_app/helpers/size_config.dart';
import 'package:toktok_app/helpers/user.dart';


class PaymentReceipt extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final Receipt receipt = ModalRoute.of(context).settings.arguments;

    // TODO: implement build
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 15, bottom: SizeConfig.safeBlockVertical * 5),
            child: Text(
              'Payment Receipt',
              style: TextStyle(
                fontSize: 26.0,
                fontWeight: FontWeight.w700
              ),
            ),
          ),
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(width: SizeConfig.blockSizeHorizontal * 5),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                          'Time: ',
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w500
                          )
                      ),
                      SizedBox(height: SizeConfig.blockSizeHorizontal * 5),
                      Text(
                          'Fee: ',
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w500
                          )
                      ),
                      SizedBox(height: SizeConfig.blockSizeHorizontal * 5),
                      Text(
                          'Discount: ',
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w500
                          )
                      ),
                      SizedBox(height: SizeConfig.blockSizeHorizontal * 5),
                      Text(
                          'Total: ',
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w500
                          )
                      ),
                    ],
                  ),
                  SizedBox(width: SizeConfig.blockSizeHorizontal * 55),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(receipt.time,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w500
                        )
                      ),
                      SizedBox(height: SizeConfig.blockSizeHorizontal * 5),
                      Text(receipt.fee.toString(),
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w500
                          )
                      ),
                      SizedBox(height: SizeConfig.blockSizeHorizontal * 5),
                      Text(receipt.discount.toString(),
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w500
                          )
                      ),
                      SizedBox(height: SizeConfig.blockSizeHorizontal * 5),
                      Text(receipt.total.toString(),
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w500
                          )
                      ),
                    ]
                  )
                ],
              ),
              SizedBox(height: SizeConfig.safeBlockVertical * 10),
              RaisedButton(
                child: Text('Ok'),
                onPressed: ((){
                  Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (Route<dynamic> route) => false);
                }),
              )
            ],
          )
        ],
      ),
    );
  }

}