import 'package:get/get.dart';

class LocationController extends GetxController {
  var officeInLocation = "".obs;

  void setLocation(String location) {
    officeInLocation.value = location;
  }
}