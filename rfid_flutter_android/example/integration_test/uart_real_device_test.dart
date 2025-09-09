// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rfid_flutter_android/rfid_flutter_android.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('UART real device smoke (runs only on handset devices)', (tester) async {
    if (!Platform.isAndroid) {
      return;
    }

    final handset = await DeviceManager.instance.isHandset();
    expect(handset.result, true, reason: "isHandset false");
    expect(handset.data, true, reason: '请检查设备是否为手持设备');

    final serial = await DeviceManager.instance.getSerialNumber();
    expect(serial.result, true, reason: "getSerialNumber false");
    expect(serial.data, isNotNull, reason: "getSerialNumber null");
    expect(serial.data!.isNotEmpty, true, reason: "getSerialNumber empty");

    final imei = await DeviceManager.instance.getImei();
    expect(imei.result, true, reason: "getImei false");
    final imeiData = imei.data as Map<String, String?>;
    expect(imeiData.length, 2, reason: "getImei length");
    expect(imeiData['imei1'], isNotNull, reason: "getImei imei1 null");
    expect(imeiData['imei2'], isNotNull, reason: "getImei imei2 null");
    expect(imeiData['imei1']!.isNotEmpty, true, reason: "getImei imei1 empty");
    expect(imeiData['imei2']!.isNotEmpty, true, reason: "getImei imei2 empty");

    final init = await RfidWithUart.instance.init();
    expect(init.isEffective, true, reason: "init false");

    final fw = await RfidWithUart.instance.getUhfFirmwareVersion();
    expect(fw.result, true, reason: "getUhfFirmwareVersion false");
    expect(fw.data, isA<String>(), reason: "getUhfFirmwareVersion null");
    expect(fw.data!.isNotEmpty, true, reason: "getUhfFirmwareVersion empty");

    final hw = await RfidWithUart.instance.getUhfHardwareVersion();
    expect(hw.result, true, reason: "getUhfHardwareVersion false");
    expect(hw.data, isA<String>(), reason: "getUhfHardwareVersion null");
    expect(hw.data!.isNotEmpty, true, reason: "getUhfHardwareVersion empty");

    final temp = await RfidWithUart.instance.getUhfTemperature();
    expect(temp.result, true, reason: "getUhfTemperature false");
    expect(temp.data, isA<int>(), reason: "getUhfTemperature null");

    // 获取并设置频率
    final freq = await RfidWithUart.instance.getFrequency();
    expect(freq.result, true, reason: "getFrequency false");
    expect(freq.data, isA<RfidFrequency>(), reason: "getFrequency null");
    final setFreq = await RfidWithUart.instance.setFrequency(freq.data!);
    expect(setFreq.isEffective, true, reason: "setFrequency false");

    // 获取并设置功率
    final power = await RfidWithUart.instance.getPower();
    expect(power.result, true, reason: "getPower false");
    expect(power.data, isA<int>(), reason: "getPower null");
    final setPower = await RfidWithUart.instance.setPower(power.data!);
    expect(setPower.isEffective, true, reason: "setPower false");

    // 获取并设置射频链路
    final rfLink = await RfidWithUart.instance.getRfLink();
    expect(rfLink.result, true, reason: "getRfLink false");
    expect(rfLink.data, isA<RfidRfLink>(), reason: "getRfLink null");
    final setRfLink = await RfidWithUart.instance.setRfLink(rfLink.data!);
    expect(setRfLink.isEffective, true, reason: "setRfLink false");

    // 获取并设置盘点模式
    final invMode = await RfidWithUart.instance.getInventoryMode();
    expect(invMode.result, true, reason: "getInventoryMode false");
    expect(invMode.data, isA<RfidInventoryMode>(), reason: "getInventoryMode null");
    final setInvMode = await RfidWithUart.instance.setInventoryMode(invMode.data!);
    expect(setInvMode.isEffective, true, reason: "setInventoryMode false");

    // 获取并设置 Gen2
    final gen2 = await RfidWithUart.instance.getGen2();
    expect(gen2.result, true, reason: "getGen2 false");
    expect(gen2.data, isA<RfidGen2>(), reason: "getGen2 null");
    final setGen2 = await RfidWithUart.instance.setGen2(gen2.data!);
    expect(setGen2.isEffective, true, reason: "setGen2 false");

    // 获取并设置 FastInventory
    final fastInventory = await RfidWithUart.instance.getFastInventory();
    expect(fastInventory.result, true, reason: "getFastInventory false");
    expect(fastInventory.data, isA<RfidFastInventory>(), reason: "getFastInventory null");
    final setFastInventory = await RfidWithUart.instance.setFastInventory(fastInventory.data!);
    expect(setFastInventory.isEffective, true, reason: "setFastInventory false");

    // 获取并设置 FastId
    final fastId = await RfidWithUart.instance.getFastId();
    expect(fastId.result, true, reason: "getFastId false");
    expect(fastId.data, isA<bool>(), reason: "getFastId null");
    final setFastId = await RfidWithUart.instance.setFastId(fastId.data!);
    expect(setFastId.isEffective, true, reason: "setFastId false");

    // 获取并设置 tagFocus 参数
    final tagFocus = await RfidWithUart.instance.getTagFocus();
    expect(tagFocus.result, true, reason: "getTagFocus false");
    expect(tagFocus.data, isA<bool>(), reason: "getTagFocus null");
    final setTagFocus = await RfidWithUart.instance.setTagFocus(tagFocus.data!);
    expect(setTagFocus.isEffective, true, reason: "setTagFocus false");

    // // 重置 UHF（可选）
    // final reset = await RfidWithUart.instance.resetUhf();
    // expect(reset.isEffective, true, reason: "resetUhf false");

    // 设置空过滤器并执行一次盘点启停
    final filter = RfidFilter(enabled: true, bank: RfidBank.epc, offset: 0, length: 0, data: '');
    final setFilter = await RfidWithUart.instance.setFilter(filter);
    expect(setFilter.isEffective, true, reason: "setFilter(empty) false");

    final startInv = await RfidWithUart.instance.startInventory();
    expect(startInv.isEffective, true, reason: "startInventory false");
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final stopInv = await RfidWithUart.instance.stopInventory();
    expect(stopInv.isEffective, true, reason: "stopInventory false");

    final free = await RfidWithUart.instance.free();
    expect(free.isEffective, true, reason: "free false");

    print('UART real device test success');
  });
}
