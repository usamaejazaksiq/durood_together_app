import 'package:intl/intl.dart';

String getRankSuffix(String num) {
  if(int.tryParse(num) == null){
    return "";
  }
  else if(num.length == 1){
    if(num == '1'){
      return 'st';
    }
    else if(num == '2'){
      return 'nd';
    }
    else if(num == '3'){
      return 'rd';
    }
    else{
      return 'th';
    }
  }
  String lastDigit = num.substring(num.length - 1);
  String last2digits = num.substring(num.length - 2);

  if (last2digits == '11' || last2digits == '12' || last2digits == '13') {
    return 'th';
  }
  else if(lastDigit == '1'){
    return 'st';
  }
  else if(lastDigit == '2'){
    return 'nd';
  }
  else if(lastDigit == '3'){
    return 'rd';
  }
  return 'th';
}


String getExceptionMessage(String code){
  String errorMessage = code;
  if(code=="account-exists-with-different-credential"){
    errorMessage = "This account exists with different credentials, try signing in with other method";
  } else if(code=="invalid-credential"){
    errorMessage = "Invalid credentials, try Again";
  } else if(code=="user-not-found"){
    errorMessage = "No User found with this email, try Again";
  } else if(code=="wrong-password"){
    errorMessage = "Wrong password for this email, try Again";
  } else if(code=="invalid-verification-code"){
    errorMessage = "Invalid verfication code, try Again";
  } else if(code=="network_error" || code=="network-request-failed"){
    errorMessage = "Check your connection and try again";
  }else if(code=="email-already-in-user"){
    errorMessage = "Already in user account! Try other login method";
  }
  return errorMessage;
}

String convertNumber(String number){
  return NumberFormat.compact().format(int.tryParse(number) ?? 0);
}

enum ranks{
  global,
  country,
  city,
}