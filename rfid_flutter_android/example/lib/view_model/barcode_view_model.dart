import 'dart:async';
import 'package:flutter/material.dart';
import 'package:signals/signals.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:rfid_flutter_android/rfid_flutter_android.dart';
import 'package:rfid_flutter_android_example/entity/app_global_state.dart';
import 'package:rfid_flutter_android_example/utils/audio_player_util.dart';

class BarcodeViewModel {
  final barcodeList = signal<List<RfidBarcodeInfo>>([]);

  StreamSubscription<RfidBarcodeInfo>? _barcodeSubscription;
  VoidCallback? _scrollToBottomCallback;

  BarcodeViewModel() {
    _barcodeSubscription = BarcodeDecoder.instance.barcodeStream.listen((barcode) {
      // print('BarcodeViewModel barcode: ${barcode.toString()}');
      if (barcode.resultCode == RfidBarcodeInfo.DECODE_SUCCESS) {
        barcodeList.value = [...barcodeList.value, barcode];
        AudioPlayerUtil.playSuccess();
        _scrollToBottomCallback?.call(); // 触发滚动到底部
      } else if (barcode.resultCode == RfidBarcodeInfo.DECODE_TIMEOUT) {
        BotToast.showText(text: appState.localizations.decodeTimeout);
        AudioPlayerUtil.playFailure();
      } else if (barcode.resultCode == RfidBarcodeInfo.DECODE_CANCEL) {
        BotToast.showText(text: appState.localizations.decodeCancel);
        AudioPlayerUtil.playFailure();
      } else if (barcode.resultCode == RfidBarcodeInfo.DECODE_FAILURE) {
        BotToast.showText(text: appState.localizations.decodeFailure);
        AudioPlayerUtil.playFailure();
      } else if (barcode.resultCode == RfidBarcodeInfo.DECODE_ENGINE_ERROR) {
        BotToast.showText(text: appState.localizations.decodeEngineError);
        AudioPlayerUtil.playFailure();
      }
    });
  }

  void dispose() {}

  void setScrollToBottomCallback(VoidCallback callback) {
    _scrollToBottomCallback = callback;
  }

  void init() async {
    final cancel = BotToast.showLoading(
      clickClose: false,
      allowClick: false,
      crossPage: false,
      backButtonBehavior: BackButtonBehavior.none,
    );

    final result = await BarcodeDecoder.instance.init();
    cancel();
    if (result.isEffective) {
      BotToast.showText(text: appState.localizations.initSuccess);
    } else {
      BotToast.showText(text: '${appState.localizations.initFailed}:\n${result.error}');
    }
  }

  void free() async {
    final result = await BarcodeDecoder.instance.free();
    if (result.isIneffective) {
      BotToast.showText(text: '${appState.localizations.freeFailed}:\n${result.error}');
    }

    _barcodeSubscription?.cancel();
  }

  void startScan() {
    BarcodeDecoder.instance.startScan().then((value) {
      if (value.isEffective) {
        BotToast.showText(text: appState.localizations.success);
      } else {
        BotToast.showText(text: '${value.error}');
      }
    });
  }

  void stopScan() {
    BarcodeDecoder.instance.stopScan().then((value) {
      if (value.isEffective) {
        BotToast.showText(text: appState.localizations.success);
      } else {
        BotToast.showText(text: '${value.error}');
      }
    });
  }

  void clear() {
    barcodeList.value = [];
  }
}
