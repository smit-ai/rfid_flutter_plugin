import 'package:flutter/material.dart';
import 'package:rfid_flutter_android/rfid_flutter_android.dart';
import 'package:signals/signals.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppGlobalState {
  // 单例实例
  static final AppGlobalState _instance = AppGlobalState._();
  static AppGlobalState get instance => _instance;

  // 全局状态 signals
  final Signal<Locale> currentLocale = Signal(const Locale('en'));
  final Signal<String> selectedMode = Signal('UART');
  final Signal<int> currentPageIndex = Signal(0);
  final Signal<bool> isHandset = Signal(true);

  AppGlobalState._() {
    _initLocale();
    RfidWithDeviceInfo.instance.isHandset().then((res) {
      isHandset.value = res.isEffective;
    });
  }

  // 初始化语言设置
  Future<void> _initLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final String? languageCode = prefs.getString('languageCode');

    if (languageCode != null) {
      currentLocale.value = Locale(languageCode);
    } else {
      final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;

      if (AppLocalizations.supportedLocales.contains(systemLocale)) {
        currentLocale.value = systemLocale;
      } else {
        currentLocale.value = const Locale('en');
      }
    }
  }

  void setCurrentPageIndex(int index) {
    currentPageIndex.value = index;
  }

  Future<void> setLocale(Locale locale) async {
    currentLocale.value = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);
  }

  // 获取多语言文本的方法 - 用于ViewModel等没有context的场景
  AppLocalizations get localizations {
    return lookupAppLocalizations(currentLocale.value);
  }
}

// Global access 全局访问
final appState = AppGlobalState.instance;
