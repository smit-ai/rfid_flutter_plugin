import 'package:signals/signals.dart';
import 'package:rfid_flutter_android/rfid_flutter_android.dart';

class AppGlobalState {
  // 单例实例
  static final AppGlobalState _instance = AppGlobalState._();
  static AppGlobalState get instance => _instance;

  // 全局状态 signals
  final Signal<bool> isEnglish = Signal(true);
  final Signal<String> selectedMode = Signal('UART');
  final Signal<int> currentPageIndex = Signal(0);
  final Signal<bool> isHandset = Signal(true);

  // 私有构造函数
  AppGlobalState._() {
    RfidWithDeviceInfo.instance.isHandset().then((res) {
      isHandset.value = res.isEffective;
    });
  }

  void toggleLanguage() {
    isEnglish.value = !isEnglish.value;
  }

  void setMode(String mode) {
    selectedMode.value = mode;
  }

  void setCurrentPageIndex(int index) {
    currentPageIndex.value = index;
  }

  // 获取当前语言对应的文本
  String getText(String englishText, String chineseText) {
    return isEnglish.value ? englishText : chineseText;
  }
}

// Global access 全局访问
final appState = AppGlobalState.instance;
