import 'package:rfid_flutter_android/rfid_flutter_android.dart';

class DeviceUtil {
  static bool isScanKey(RfidKeyEvent keyEvent) {
    if (keyEvent.keyCode == 139 ||
        keyEvent.keyCode == 280 ||
        keyEvent.keyCode == 291 ||
        keyEvent.keyCode == 293 ||
        keyEvent.keyCode == 294 ||
        keyEvent.keyCode == 311 ||
        keyEvent.keyCode == 312 ||
        keyEvent.keyCode == 313 ||
        keyEvent.keyCode == 315 ||
        keyEvent.keyCode == 591 ||
        keyEvent.keyCode == 593 ||
        keyEvent.keyCode == 594) {
      return true;
    }
    return false;
  }
}
