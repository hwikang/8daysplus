import 'strings.dart';

class FieldValidator {
  static String validateEmail(String value) {
    print('validateEmail : $value ');

    if (value.isEmpty) {
      return ValidatorTexts.enterEmail;
    }
    const Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final regex = RegExp(pattern);
    if (!regex.hasMatch(value.trim())) {
      return ValidatorTexts.enterValidEmail;
    }
    if (value.contains('@yopmail') ||
        value.contains('@emailmonkey') ||
        value.contains('@tmpmail') ||
        value.contains('@moakt') ||
        value.contains('@whowlft') ||
        value.contains('@zzrgg.com') ||
        value.contains('@wimsg.com') ||
        value.contains('@sharklasers') ||
        value.contains('@grr') ||
        value.contains('@spam4') ||
        value.contains('@ruu') ||
        value.contains('@pastmao') ||
        value.contains('@mail35') ||
        value.contains('@inmail3') ||
        value.contains('@disbox') ||
        value.contains('@tmpmail') ||
        value.contains('@bareed') ||
        value.contains('@gomail5')) {
      return ValidatorTexts.noOneTimeEmail;
    }

    return null;
  }

  static String validateMobile(String value) {
    if (value.isEmpty) {
      return ValidatorTexts.enterMobile;
    }
    const Pattern pattern = r'^[0][1-9]\d{9}$|^[1-9]\d{9}$';
    final regEx = RegExp(pattern);
    if (!regEx.hasMatch(value.trim())) {
      return ValidatorTexts.enterValidMobile;
    }
    return null;
  }

  static String validatePassword(String value) {
    print('validatePassword : $value ');
    if (value.isEmpty) {
      return ValidatorTexts.enterPassword;
    }
    if (value.length > 15 || value.length < 8) {
      return ValidatorTexts.passwordGuide;
    }
    const Pattern pattern = r'^[A-Za-z0-9]{8,15}$';
    final regex = RegExp(pattern);
    if (!regex.hasMatch(value.trim())) {
      return ValidatorTexts.passwordGuide;
    }
    return null;
  }

  static String validateNewPassword(String value, String oldPassword) {
    print('validatePassword : $value ');
    if (value.isEmpty) {
      return ValidatorTexts.enterPassword;
    }
    if (oldPassword == value) {
      return ValidatorTexts.samePasswordError;
    }
    if (value.length > 15 || value.length < 8) {
      return ValidatorTexts.passwordGuide;
    }
    const Pattern pattern = r'^[A-Za-z0-9]{8,15}$';
    final regex = RegExp(pattern);
    if (!regex.hasMatch(value.trim())) {
      return ValidatorTexts.passwordGuide;
    }
    return null;
  }

  static String validateConfirmPassword(String value, String newPassword) {
    print('validatePassword : $value ');
    if (value.isEmpty) {
      return ValidatorTexts.enterPassword;
    }
    if (newPassword != value) {
      return ValidatorTexts.differentPasswordError;
    }
    if (value.length > 15 || value.length < 8) {
      return ValidatorTexts.passwordGuide;
    }
    const Pattern pattern = r'^[A-Za-z0-9]{8,15}$';
    final regex = RegExp(pattern);
    if (!regex.hasMatch(value.trim())) {
      return ValidatorTexts.passwordGuide;
    }
    return null;
  }
}
