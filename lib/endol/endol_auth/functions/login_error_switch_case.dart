import 'package:endol/constants/strings.dart';

String loginError(String error) {
  String errorMessage;

  if (error.contains('[firebase_auth/invalid-credential]')) {
    errorMessage = 'The email address is badly formatted.';
  } else if (error.contains('[firebase_auth/channel-error]')) {
    errorMessage = 'Something went wrong please try again';
  } else {
    errorMessage = Strings.somethingWentWrong;
  }

  return errorMessage;
}
