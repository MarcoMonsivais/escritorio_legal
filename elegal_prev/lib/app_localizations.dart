import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'l10n/messages_all.dart';

class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale){
    final String name = locale.countryCode == null ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return new AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of(context, AppLocalizations);
  }

  String get title {
    return Intl.message(
      'Escritorio Legal',
      name: 'title',
      desc: 'The application title'
    );
  }

  String get email {
    return Intl.message(
      'Email Address',
      name: 'email',
      desc: 'Email address on Inputs'
    );
  }

  String get password {
    return Intl.message(
        'Password',
        name: 'password',
        desc: 'Password on Inputs'
    );
  }

  String get passwordConfirmation {
    return Intl.message(
        'Password Confirmation',
        name: 'passwordConfirmation',
        desc: 'Password Confirmation on Inputs'
    );
  }

  String get login {
    return Intl.message(
        'Login',
        name: 'login',
        desc: 'Login for buttons'
    );
  }

  String get loginFacebook {
    return Intl.message(
        'Login with Facebook',
        name: 'loginFacebook',
        desc: 'Login with Facebook for buttons'
    );
  }

  String get loginGoogle {
    return Intl.message(
        'Login with Google',
        name: 'loginGoogle',
        desc: 'Login with Google for buttons'
    );
  }

  String get newQuestion {
    return Intl.message(
        'New to TokTok?',
        name: 'newQuestion',
        desc: 'Question made to user for registration'
    );
  }

  String get signUp {
    return Intl.message(
        'Sign Up',
        name: 'signUp',
        desc: 'Clickable word for user to sign up'
    );
  }

  String get forgot {
    return Intl.message(
        'Forgot Password?',
        name: 'forgot',
        desc: 'Question made to user if he forgot the password'
    );
  }

  String get name {
    return Intl.message(
        'Name',
        name: 'name',
        desc: 'Asking the user about his name'
    );
  }

  String get lastName {
    return Intl.message(
        'Last Name',
        name: 'lastName',
        desc: 'Asking the user about his Last Name'
    );
  }

  String get cellphone {
    return Intl.message(
        'Cellphone',
        name: 'cellphone',
        desc: 'Asking the user about his Cellphone'
    );
  }

  String get gender {
    return Intl.message(
        'Gender',
        name: 'gender',
        desc: 'Asking the user about his Gender'
    );
  }

  String get age {
    return Intl.message(
        'Age',
        name: 'age',
        desc: 'Asking the user about his Age'
    );
  }

  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: 'Input button to form submit'
    );
  }

  String get validAge {
    return Intl.message(
        'Please enter a valid Age',
        name: 'validAge',
        desc: 'Error message when the age submitted is not valid'
    );
  }

  String get validGender {
    return Intl.message(
        'Please select a Gender',
        name: 'validGender',
        desc: 'Error message when the gender is not selected'
    );
  }

  String get validCellphone {
    return Intl.message(
        'Please enter a valid cellphone number',
        name: 'validCellphone',
        desc: 'Error message when the cellphone submitted is not valid'
    );
  }

  String get validText {
    return Intl.message(
        'Please enter some Text',
        name: 'validText',
        desc: 'Error message when the user didn\'t enter text'
    );
  }

  String get validPasswordMatch {
    return Intl.message(
        'Password doesn\'t match',
        name: 'validPasswordMatch',
        desc: 'Error message when the'
    );
  }

  String get validPasswordLength {
    return Intl.message(
        'Make it at least 8 characters long',
        name: 'validPasswordLength',
        desc: 'Error message when the password field is less than 8 characters'
    );
  }

  String get validEmail {
    return Intl.message(
        'Please enter valid email address',
        name: 'validEmail',
        desc: 'Error message when the text entered is not an email'
    );
  }

  String get validEmailText {
    return Intl.message(
        'Please enter an email address',
        name: 'validEmailText',
        desc: 'Error message when the email field is empty'
    );
  }

  String get cellphoneNumber {
    return Intl.message(
        'Your cellphone number',
        name: 'cellphoneNumber',
        desc: 'Request the cellphone number of user'
    );
  }

  String get smsCode {
    return Intl.message(
        'Please enter the code received via SMS',
        name: 'smsCode',
        desc: 'Request the sms code'
    );
  }

  String get settings {
    return Intl.message(
        'Settings',
        name: 'settings',
        desc: 'Settings label for side drawer'
    );
  }

  String get logout {
    return Intl.message(
        'Logout',
        name: 'logout',
        desc: 'Logout label for side drawer'
    );
  }

  String get language {
    return Intl.message(
        'Language',
        name: 'language',
        desc: 'Language label for side drawer'
    );
  }

  String get terminos {
    return Intl.message(
        'Terminos y condiciones',
        name: 'terminos',
        desc: 'Terminos y condiciones label for side drawer'
    );
  }

  String get selectLanguage {
    return Intl.message(
        'Select a Language',
        name: 'selectLanguage',
        desc: 'Select a language label'
    );
  }

  String get cellValidation {
    return Intl.message(
        'Cellphone Verification',
        name: 'cellValidation',
        desc: 'Cellphone Verification label'
    );
  }

  String get hello {
    return Intl.message(
        'Hello',
        name: 'hello',
        desc: 'Greeting on splash'
    );
  }

  String get whereWeGoing {
    return Intl.message(
        'Where are we going today?',
        name: 'whereWeGoing',
        desc: 'Greeting question on splash'
    );
  }

  String get getStarted {
    return Intl.message(
        'Get started',
        name: 'getStarted',
        desc: 'Button on splash'
    );
  }

  String get yourProfileInfo {
    return Intl.message(
        'Your Profile Information',
        name: 'yourProfileInfo',
        desc: 'Profile information option in menu'
    );
  }

  String get address {
    return Intl.message(
        'Address',
        name: 'address',
        desc: 'Address information on menu'
    );
  }

  String get yourVehicles {
    return Intl.message(
        'Your Vehicles',
        name: 'yourVehicles',
        desc: 'Vehicle information on menu'
    );
  }

  String get payment {
    return Intl.message(
        'Payment',
        name: 'payment',
        desc: 'Payment option on menu'
    );
  }

  String get paymentMethods {
    return Intl.message(
        'Payment Methods',
        name: 'paymentMethods',
        desc: 'Title on payment methods page'
    );
  }

  String get addPaymentMethod {
    return Intl.message(
        'Add payment method',
        name: 'addPaymentMethod',
        desc: 'Label to add a payment method'
    );
  }

  String get coupons {
    return Intl.message(
        'Coupons',
        name: 'coupons',
        desc: 'Label of coupons'
    );
  }

  String get creditOrDebit {
    return Intl.message(
        'Credit or debit card',
        name: 'creditOrDebit',
        desc: 'Label to enter credit or debit cards'
    );
  }

  String get getParked {
    return Intl.message(
        'Hello! Where are we going today?',
        name: 'getParked',
        desc: 'Label in login screen'
    );
  }

  String get enterMobile {
    return Intl.message(
        'Mobile number',
        name: 'enterMobile',
        desc: 'Label in login screen to enter mobile number'
    );
  }

  String get orConnectSocial {
    return Intl.message(
        'Or connect with social',
        name: 'orConnectSocial',
        desc: 'Label in login screen to connect with social media'
    );
  }

  String get chooseAccount {
    return Intl.message(
        'Choose an account',
        name: 'chooseAccount',
        desc: 'Label to select a social media account'
    );
  }

  String get socialDisclaimer {
    return Intl.message(
        'By clicking on a social option you may receive an SMS for verification. Message and data rates may apply.',
        name: 'socialDisclaimer',
        desc: 'Disclaimer on selecting a social media account'
    );
  }

  String get pleaseMobileNumber {
    return Intl.message(
        'Please enter your mobile number',
        name: 'pleaseMobileNumber',
        desc: 'Label when login in by mobile number'
    );
  }

  String get smsDisclaimer {
    return Intl.message(
        'By continuing you may receive an SMS for verification. Message and data rates may apply.',
        name: 'smsDisclaimer',
        desc: 'Disclaimer that a sms may be received'
    );
  }

  String get fourDigitCode {
    return Intl.message(
        'Enter the 4-digit code sent to you at',
        name: 'fourDigitCode',
        desc: 'Label askinf for code received via sms'
    );
  }

  String get correctMobile {
    return Intl.message(
        'Did you enter the correct mobile number?',
        name: 'correctMobile',
        desc: 'Label asking if the correct mobile number was introduced'
    );
  }

  String get requestAnotherCode {
    return Intl.message(
        'Request another code',
        name: 'requestAnotherCode',
        desc: 'Label to request another code'
    );
  }

  String get resendAnother {
    return Intl.message(
        'Resend code in 00:',
        name: 'resendAnother',
        desc: 'Label to request another code'
    );
  }

  String get confirmInformation {
    return Intl.message(
        'Confirm your information',
        name: 'confirmInformation',
        desc: 'Label to request user information'
    );
  }
  String get first {
    return Intl.message(
        'First',
        name: 'first',
        desc: 'Label to request user names'
    );
  }

  String get last {
    return Intl.message(
        'Last',
        name: 'last',
        desc: 'Label to request user names'
    );
  }
  String get termsAndConds1 {
    return Intl.message(
        'By continuing, I confirm that I have read and agree to the ',
        name: 'termsAndConds1',
        desc: 'Part 1 of terms and conditions'
    );
  }

  String get termsAndConds2 {
    return Intl.message(
        'Terms & Conditions',
        name: 'termsAndConds2',
        desc: 'Part 2 of terms and conditions'
    );
  }

  String get termsAndConds3 {
    return Intl.message(
        ' and ',
        name: 'termsAndConds3',
        desc: 'Part 3 of terms and conditions'
    );
  }

  String get termsAndConds4 {
    return Intl.message(
        'Privacy Policy ',
        name: 'termsAndConds4',
        desc: 'Part 4 of terms and conditions'
    );
  }



//  Code to generate the localizations file
//  flutter pub pub run intl_translation:extract_to_arb --output-dir=lib/l10n lib/app_localizations.dart
//  Code to generate the messages files for translated words
//  flutter pub pub run intl_translation:generate_from_arb \ --output-dir=lib/l10n --no-use-deferred-loading \ lib/app_localizations.dart lib/l10n/intl_es.arb lib/l10n/intl_en.arb lib/l10n/intl_messages.arb
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale){
    return ['en', 'es'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale){
    return AppLocalizations.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}

