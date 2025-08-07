import 'package:signals/signals.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:rfid_flutter_android/rfid_flutter_android.dart';
import '../entity/rfid_manager.dart';
import '../entity/app_global_state.dart';

class SettingsViewModel {
  final selectedFrequency = signal(RfidFrequency.china1);
  final selectedPower = signal(1);
  final selectedRfLink = signal(RfidRfLink.prAskMiller8_160KHz);

  final selectedInventoryBank = signal(RfidInventoryBank.epc);
  final selectedOffset = signal(0);
  final selectedLength = signal(6);

  final selectedQuerySession = signal(RfidGen2.querySessionS0);
  final selectedQueryTarget = signal(RfidGen2.queryTargetA);

  final antenna1State = signal(RfidAntennaState(antenna: 1, enable: false, power: 1));
  final antenna2State = signal(RfidAntennaState(antenna: 2, enable: false, power: 1));
  final antenna3State = signal(RfidAntennaState(antenna: 3, enable: false, power: 1));
  final antenna4State = signal(RfidAntennaState(antenna: 4, enable: false, power: 1));

  SettingsViewModel() {
    //
  }

  void dispose() {
    // signals will be automatically disposed when no longer watched
  }

  void showResult(RfidResult<dynamic> res, {showData = false}) {
    if (res.result) {
      BotToast.showText(text: '✅ ${showData ? res.data : appState.localizations.success}');
    } else {
      BotToast.showText(text: '❌ ${appState.localizations.failed}:\n${res.error}');
    }
  }

  Future<void> getUhfFirmwareVersion() async {
    final result = await RfidManager.instance.getUhfFirmwareVersion();
    showResult(result, showData: true);
  }

  Future<void> getUhfHardwareVersion() async {
    final result = await RfidManager.instance.getUhfHardwareVersion();
    showResult(result, showData: true);
  }

  Future<void> getTemperature() async {
    final res = await RfidManager.instance.getUhfTemperature();
    if (res.result) {
      BotToast.showText(text: '✅ ${res.data} ℃');
    } else {
      BotToast.showText(text: '❌ ${appState.localizations.failed}:\n${res.error}');
    }
  }

  Future<void> resetModule() async {
    final result = await RfidManager.instance.resetUhf();
    showResult(result);
  }

  Future<void> getFrequency() async {
    final res = await RfidManager.instance.getFrequency();
    if (res.result) {
      selectedFrequency.value = res.data ?? RfidFrequency.china1;
    }
    showResult(res);
  }

  Future<void> setFrequency() async {
    final result = await RfidManager.instance.setFrequency(selectedFrequency.value);
    showResult(result);
  }

  Future<void> getPower() async {
    final res = await RfidWithUart.instance.getPower();
    if (res.result) {
      selectedPower.value = res.data ?? 1;
    }
    showResult(res);
  }

  Future<void> setPower() async {
    final result = await RfidWithUart.instance.setPower(selectedPower.value.round());
    showResult(result);
  }

  Future<void> getRfLink() async {
    final res = await RfidManager.instance.getRfLink();
    if (res.result) {
      selectedRfLink.value = res.data!;
    }
    showResult(res);
  }

  Future<void> setRfLink() async {
    final result = await RfidManager.instance.setRfLink(selectedRfLink.value);
    showResult(result);
  }

  Future<void> setInventoryMode() async {
    final inventoryMode = RfidInventoryMode(
      inventoryBank: selectedInventoryBank.value,
      offset: selectedOffset.value,
      length: selectedLength.value,
    );
    final result = await RfidManager.instance.setInventoryMode(inventoryMode);
    showResult(result);
  }

  Future<void> getInventoryMode() async {
    final res = await RfidManager.instance.getInventoryMode();
    if (res.result) {
      selectedInventoryBank.value = res.data!.inventoryBank;
      selectedOffset.value = res.data!.offset;
      selectedLength.value = res.data!.length;
    }
    showResult(res);
  }

  Future<void> setGen2() async {
    final gen2 = RfidGen2(
      querySession: selectedQuerySession.value,
      queryTarget: selectedQueryTarget.value,
    );
    final result = await RfidManager.instance.setGen2(gen2);
    showResult(result);
  }

  Future<void> getGen2() async {
    final res = await RfidManager.instance.getGen2();
    if (res.result) {
      selectedQuerySession.value = res.data!.querySession ?? RfidGen2.querySessionS0;
      selectedQueryTarget.value = res.data!.queryTarget ?? RfidGen2.queryTargetA;
    }
    showResult(res);
  }

  Future<void> resetUhf() async {
    final result = await RfidManager.instance.resetUhf();
    showResult(result);
  }

  Future<void> setFastId(bool enabled) async {
    final result = await RfidManager.instance.setFastId(enabled);
    showResult(result);
  }

  Future<void> setTagFocus(bool enabled) async {
    final result = await RfidManager.instance.setTagFocus(enabled);
    showResult(result);
  }

  Future<void> setFastInventory(bool enabled) async {
    final result = await RfidManager.instance.setFastInventory(enabled);
    showResult(result);
  }

  // 天线状态相关方法
  Future<void> getAntennaState() async {
    final res = await RfidWithUra4.instance.getAntennaState(0); // 0表示获取所有天线状态
    if (res.result && res.data != null) {
      final antennaStates = res.data!;
      for (var state in antennaStates) {
        switch (state.antenna) {
          case 1:
            antenna1State.value = RfidAntennaState(antenna: 1, enable: state.enable ?? true, power: state.power ?? 20);
            break;
          case 2:
            antenna2State.value = RfidAntennaState(antenna: 2, enable: state.enable ?? true, power: state.power ?? 20);
            break;
          case 3:
            antenna3State.value = RfidAntennaState(antenna: 3, enable: state.enable ?? true, power: state.power ?? 20);
            break;
          case 4:
            antenna4State.value = RfidAntennaState(antenna: 4, enable: state.enable ?? true, power: state.power ?? 20);
            break;
        }
      }
    }
    showResult(res);
  }

  Future<void> setAntennaState() async {
    final antennaStates = [
      antenna1State.value,
      antenna2State.value,
      antenna3State.value,
      antenna4State.value,
    ];
    final result = await RfidWithUra4.instance.setAntennaState(antennaStates);
    showResult(result);
  }
}
