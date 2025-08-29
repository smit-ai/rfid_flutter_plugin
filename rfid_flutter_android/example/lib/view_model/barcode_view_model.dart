import 'dart:async';
import 'package:signals/signals.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:rfid_flutter_android/rfid_flutter_android.dart';
import 'package:rfid_flutter_android_example/utils/audio_player_util.dart';

class BarcodeViewModel {
  final barcodeList = signal<List<RfidBarcodeInfo>>([]);

  StreamSubscription<RfidBarcodeInfo>? _barcodeSubscription;

  BarcodeViewModel() {
    _barcodeSubscription = BarcodeDecoder.instance.barcodeStream.listen((barcode) {
      print('barcodeStream: ${barcode.toString()}');

      if (barcode.resultCode == RfidBarcodeInfo.DECODE_SUCCESS) {
        barcodeList.value = [...barcodeList.value, barcode];
        AudioPlayerUtil.playSuccess();
      } else if (barcode.resultCode == RfidBarcodeInfo.DECODE_TIMEOUT) {
        BotToast.showText(text: 'Decode timeout');
        AudioPlayerUtil.playFailure();
      } else if (barcode.resultCode == RfidBarcodeInfo.DECODE_CANCEL) {
        BotToast.showText(text: 'Decode cancel');
        AudioPlayerUtil.playFailure();
      } else if (barcode.resultCode == RfidBarcodeInfo.DECODE_FAILURE) {
        BotToast.showText(text: 'Decode failure');
        AudioPlayerUtil.playFailure();
      } else if (barcode.resultCode == RfidBarcodeInfo.DECODE_ENGINE_ERROR) {
        BotToast.showText(text: 'Decode engine error');
        AudioPlayerUtil.playFailure();
      }
    });
  }

  void dispose() {
    _barcodeSubscription?.cancel();
  }

  void init() {
    BarcodeDecoder.instance.init().then((value) {
      if (value.isEffective) {
        BotToast.showText(text: 'Init success');
      } else {
        BotToast.showText(text: '${value.error}');
      }
    });
  }

  void free() {
    BarcodeDecoder.instance.free().then((value) {
      if (value.isEffective) {
        BotToast.showText(text: 'Free success');
      } else {
        BotToast.showText(text: '${value.error}');
      }
    });
  }

  void startScan() {
    BarcodeDecoder.instance.startScan().then((value) {
      if (value.isEffective) {
        BotToast.showText(text: 'success');
      } else {
        BotToast.showText(text: '${value.error}');
      }
    });
  }

  void stopScan() {
    BarcodeDecoder.instance.stopScan().then((value) {
      if (value.isEffective) {
        BotToast.showText(text: 'success');
      } else {
        BotToast.showText(text: '${value.error}');
      }
    });
  }

  void clear() {
    barcodeList.value = [];
  }
}
