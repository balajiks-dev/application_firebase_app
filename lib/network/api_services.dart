import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:application_firebase_app/model/meta.dart';
import 'package:application_firebase_app/network/network_utils.dart';
import 'package:application_firebase_app/utils/constants.dart';



class APIServices {

  bool validateRequest(String url) {
    if (url.isNotEmpty && url.length > 0) {
      return true;
    }
    return false;
  }

  Future<Meta> processGetURL(
      String url) async {
    if (validateRequest(url)) {
      bool isNetworkAvailable = await NetworkUtils().isInternetConnected();
      if (isNetworkAvailable) {
        try {
      
          final responses = await http.get(Uri.parse(url), headers: {
            "Content-Type": "application/json",
          });

          if (responses.statusCode == 200) {
            String responseJson = _isJsonValid(responses.body.toString())
                ? responses.body.toString()
                : json.encode(responses.body).toString();
            Meta meta =
                Meta(statusCode: responses.statusCode, statusMsg: responseJson);
            return meta;
          } else {
            Meta meta = Meta(
                statusCode: responses.statusCode,
                statusMsg: responses.body.toString());
            return meta;
          }
        } catch (error) {
          Meta meta = new Meta(
            statusCode: 500,
            statusMsg: AppStrings.connectionTimeOut);
        return meta;
        }
      } else {
        Meta meta = new Meta(
            statusCode: 102,
            statusMsg: AppStrings.checkInternet);
        return meta;
      }
    } else {
      Meta meta = new Meta(
          statusCode: 100, statusMsg: AppStrings.userNotValid);
      return meta;
    }
  }

    bool _isJsonValid(String response) {
    try {
      json.decode(response);
    } catch (e) {
      return false;
    }
    return true;
  }
}
