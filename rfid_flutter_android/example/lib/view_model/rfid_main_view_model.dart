import 'package:signals/signals.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:rfid_flutter_android/rfid_flutter_android.dart';
import '../entity/rfid_manager.dart';

class RfidMainViewModel {
// 单例实例
  RfidMainViewModel._();
  static final RfidMainViewModel _instance = RfidMainViewModel._();
  static RfidMainViewModel get instance => _instance;

  final Signal<int> currentPageIndex = Signal(0);
  final Signal<RfidTagInfo?> selectedTag = Signal<RfidTagInfo?>(null);

  void init() async {
    final cancel = BotToast.showLoading(
      clickClose: false,
      allowClick: false,
      crossPage: false,
      backButtonBehavior: BackButtonBehavior.none,
    );

    final result = await RfidManager.instance.init();
    cancel();
    if (result.isEffective) {
      BotToast.showText(text: '✅ Init Success');
    } else {
      BotToast.showText(text: '❌ Init Failed:\n${result.error}');
    }
  }

  void free() async {
    final result = await RfidManager.instance.free();
    if (result.isIneffective) {
      BotToast.showText(text: '❌ Free Failed:\n${result.error}');
    }
  }
}
