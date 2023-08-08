import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:toktok_app/helpers/size_config.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:country_pickers/country.dart';
import 'package:toktok_app/helpers/user.dart';
import 'package:toktok_app/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:toktok_app/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toktok_app/helpers/toktok_alert_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:math';


class UpdateUserProfile extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _UpdateUserProfile();
  }
}

class _UpdateUserProfile extends State<UpdateUserProfile>{
  bool _isLoading = false;
  bool _hasEmail = false;
  var countryCode = '52';
  var cellNumber;
  String profilePicture = 'https://www.uic.mx/posgrados/files/2018/05/default-user.png';
  String number;
  File sampleImage;


  SocialUser socialUser = SocialUser();

  Country _selectedDialogCountry =
  CountryPickerUtils.getCountryByPhoneCode('52');

  Country _selectedFilteredDialogCountry =
  CountryPickerUtils.getCountryByPhoneCode('52');

  Country _selectedCupertinoCountry =
  CountryPickerUtils.getCountryByIsoCode('mx');

  Country _selectedFilteredCupertinoCountry =
  CountryPickerUtils.getCountryByIsoCode('MX');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children:<Widget>[
          _isLoading ? Container(
            color: Colors.black12,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ) : SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: _getImage,
                  child: Container(
                    margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 3),
                    width: SizeConfig.blockSizeHorizontal* 40,
                    height: SizeConfig.blockSizeVertical* 20,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(profilePicture),
                            fit: BoxFit.cover
                        )
                    ),
                  ),
                ),
                Container(
//                height: SizeConfig.blockSizeVertical * 74,
                  margin: EdgeInsets.only(
                      top: SizeConfig.blockSizeVertical * 5,
                      left: SizeConfig.blockSizeHorizontal * 5,
                      right: SizeConfig.blockSizeHorizontal * 5
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                    child: TextField(
                                      controller: TextEditingController(text: socialUser.name),
                                      decoration: InputDecoration(
                                          floatingLabelBehavior: FloatingLabelBehavior.always,
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black, width: 2.0),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black, width: 1.0),
                                          ),
                                          labelText: 'First',
                                          labelStyle: TextStyle(
                                              fontSize: 16.0
                                          )
                                      ),
                                      style: TextStyle(
                                          fontSize: 20.0
                                      ),
                                      onChanged: (String value){
//                                  setState(() {
                                        socialUser.name = value;
//                                  });
                                      },
                                    )
                                ),
                                SizedBox(height: 10, width: 10),
                                Flexible(
                                  child: TextField(
                                    controller: TextEditingController(text: socialUser.lastName),
                                    decoration: InputDecoration(
                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black, width: 2.0),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black, width: 1.0),
                                        ),
                                        labelText: 'Last',
                                        labelStyle: TextStyle(
                                          fontSize: 16.0,
                                        )
                                    ),
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                    onChanged: (String value){
//                                setState(() {
                                      socialUser.lastName = value;
//                                });
                                    },
                                  ),
                                )
                              ],
                            )
                        ),
                        Container(
                            margin: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical * 2,
                            ),
                            child:TextField(
                              readOnly: _hasEmail,
                              controller: TextEditingController(text: socialUser.email),
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                                  ),
                                  labelText: 'Email',
                                  labelStyle: TextStyle(
                                      fontSize: 16.0
                                  )
                              ),
                              style: TextStyle(
                                  fontSize: 20.0
                              ),
                              onChanged: (String value){
//                          setState(() {
                                socialUser.email = value;
//                            _hasEmail = false;
//                          });
                              },
                            )
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: SizeConfig.blockSizeVertical * 2
                          ),
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                                child: CountryPickerDropdown(
                                  initialValue: 'mx',
                                  itemBuilder: _buildDropdownItem,
                                  onValuePicked: (Country country) {
                                    countryCode = country.phoneCode;
                                  },
                                ),
                              ),
                              Flexible(
                                child: TextField(
                                  readOnly: true,
                                  style: TextStyle(color: Colors.black, fontSize: 20.0),
                                  maxLength: 10,
                                  textInputAction: TextInputAction.none,
                                  controller: TextEditingController(text: socialUser.cellphone),
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                      counterText: '',
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                                      ),
                                      labelStyle: TextStyle(color: Colors.grey, fontSize: 16.0),
                                      labelText: AppLocalizations.of(context).cellphoneNumber
                                  ),
                                  onChanged: (String value) {
//                              setState(() {
                                    cellNumber = value;
//                              });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: SizeConfig.blockSizeHorizontal * 35,
                          margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 3),
                          child: RaisedButton(
                            color: Color(0xFF000000),
                            onPressed: _isLoading ? null : () async {
                              setState(() {
                                _isLoading = true;
                              });
                              var helper = await _verifyNumber();
                              if(helper == false){
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return TokTokAlertDialog(
                                        'Error en el numero',
                                        'Porfavor verifica el numero que ingresaste',
                                        1
                                    );
                                    },
                                );
                              }
                              },
                            textColor: Colors.white,
                            child: Text('Guardar'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future _getUser() async{
    final prefs = await SharedPreferences.getInstance();
    final response = await http.get(
        Uri.parse('${Globals.BASE_API_URL}/users/${prefs.getInt('userId')}'),
        headers: {
          'Authorization' : 'Bearer ${prefs.getString('access_token')}',
          'Content-Type' : 'application/json'
        }
    );

    var c = (jsonDecode(response.body));

    setState(() {
      if(c['data']['name'] != null)
        socialUser.name = '${c['data']['name']}';
      if(c['data']['name'] != null)
        socialUser.lastName = '${c['data']['lastName']}';
      if(c['data']['photo'] != null) {
        profilePicture = c['data']['photo'];
        socialUser.image = c['data']['photo'];
      }
      if(c['data']['email'] != null)
        socialUser.email = c['data']['email'];
      if(c['data']['cellphone'] != null) {
        var fullNumber = c['data']['cellphone'].toString();
        fullNumber = fullNumber.substring(fullNumber.length - 10);
        socialUser.cellphone = fullNumber;
        cellNumber = fullNumber;
      }
    });

    return true;
  }

  Future _verifyNumber() async{
    if(cellNumber == null){
      setState(() {
        _isLoading = false;
      });
      return false;
    }
    if(cellNumber.length == 10){
      setState(() {
        _isLoading = true;
      });
      number = '$countryCode$cellNumber';
      _updateUserInfo();
    } else if (cellNumber.length < 10 || cellNumber.length > 10){
      setState(() {
        _isLoading = false;
      });
      return false;
    }
  }

  void _updateUserInfo() async {
    final prefs = await SharedPreferences.getInstance();

    var mapData = new Map();
    mapData['name'] = socialUser.name;
    mapData['lastName'] = socialUser.lastName;
    mapData['email'] = socialUser.email;
    mapData['image'] = socialUser.image;
    mapData['_method'] = 'put';

    String json = jsonEncode(mapData);

    final response = await http.post(
        Uri.parse('${Globals.BASE_API_URL}/users/${prefs.getInt('userId')}'),
        headers: {
          'Authorization' : 'Bearer ${prefs.getString('access_token')}',
          'Content-Type' : 'application/json',
//          'Accept': 'application/json',
        },
        body: json,
        encoding: Encoding.getByName("utf-8")
    );
    print(json);
    var c = (jsonDecode(response.body));
    print(c);
    setState(() {
      _isLoading = false;
    });

  }
  
  Future _getImage() async {
    final prefs = await SharedPreferences.getInstance();
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    var rand = Random();

    setState(() {
      sampleImage = tempImage;
    });

    int fileName = rand.nextInt(9999);

    final Reference firebaseStorageReference = FirebaseStorage.instance.ref().child('profileImages/${prefs.getInt('userId')}/$fileName.jpg');
    UploadTask task = firebaseStorageReference.putFile(sampleImage);
    var downUrl = await (await task).ref.getDownloadURL();

    setState(() {
      socialUser.image = downUrl.toString();
      profilePicture = downUrl.toString();
    });

  }

  Widget _buildDropdownItem(Country country) => Container(
    width: 110.0,
    child: Row(
      children: <Widget>[
        CountryPickerUtils.getDefaultFlagImage(country),
        SizedBox(
          width: 8.0,
        ),
        Flexible(
          child: Text("+${country.phoneCode}(${country.isoCode})"),
        )
      ],
    ),
  );

  Widget _buildDialogItem(Country country) => Row(
    children: <Widget>[
      CountryPickerUtils.getDefaultFlagImage(country),
      SizedBox(width: 8.0),
      Text("+${country.phoneCode}"),
      SizedBox(width: 8.0),
      Flexible(child: Text(country.name))
    ],
  );

  void _openCountryPickerDialog() => showDialog(
    context: context,
    builder: (context) => Theme(
        data: Theme.of(context).copyWith(primaryColor: Colors.pink),
        child: CountryPickerDialog(
            titlePadding: EdgeInsets.all(8.0),
            searchCursorColor: Colors.pinkAccent,
            searchInputDecoration: InputDecoration(hintText: 'Search...'),
            isSearchable: true,
            title: Text('Select your phone code'),
            onValuePicked: (Country country) =>
                setState(() => _selectedDialogCountry = country),
            itemBuilder: _buildDialogItem)),
  );

  void _openCupertinoCountryPicker() => showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return CountryPickerCupertino(
          pickerSheetHeight: 300.0,
          onValuePicked: (Country country) =>
              setState(() => _selectedCupertinoCountry = country),
        );
      }
  );

}
