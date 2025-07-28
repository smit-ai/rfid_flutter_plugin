import 'package:rfid_flutter_android/rfid_flutter_android.dart';
import 'package:rfid_flutter_core/rfid_flutter_core.dart';
import 'app_global_state.dart';

class RfidManager {
  static RfidInterface get instance {
    if (appState.isHandset.value) {
      return RfidWithUart.instance;
    } else {
      return RfidWithUra4.instance;
    }
  }
}
