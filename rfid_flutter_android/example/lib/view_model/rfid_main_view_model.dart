import 'package:signals/signals.dart';
import 'package:rfid_flutter_android/rfid_flutter_android.dart';

class RfidMainViewModel {
// 单例实例
  RfidMainViewModel._();
  static final RfidMainViewModel _instance = RfidMainViewModel._();
  static RfidMainViewModel get instance => _instance;

  final Signal<int> currentPageIndex = Signal(0);
  final Signal<RfidTagInfo?> selectedTag = Signal<RfidTagInfo?>(null);
}
