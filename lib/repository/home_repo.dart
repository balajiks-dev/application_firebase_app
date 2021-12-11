import 'package:application_firebase_app/network/api_services.dart';
import 'package:application_firebase_app/utils/url_utils.dart';

import '../model/meta.dart';

class HomeRepository {
  Future<Meta> getDishesUrl() async {
    APIServices gmapiService = APIServices();
    Meta meta = await gmapiService.processGetURL(
        URLUtils().getDishes());
    return meta;
  }
}
