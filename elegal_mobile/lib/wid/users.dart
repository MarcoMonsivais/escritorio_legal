class User {
  late String name;
  late String lastName;
  late String email;
  late String password;
  late String passwordConfirmation;
  late double cellphone;
  late int age;
  late int gender;
  late String error;

}

class SocialUser {
  late String name;
  late String lastName;
  late String email;
  late String socialToken;
  late String image;
  late String network;
  late String cellphone;
}

class Receipt {
  late String time;
  late double total;
  late double fee;
  late int discount;
  late String error;
  late String cardThatPayed;
  late String holderName;
  late String dateCreated;

}
