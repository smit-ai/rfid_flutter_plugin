// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rfid_flutter_android/rfid_flutter_android.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('URA4 real device smoke (runs only on URA4 devices)', (tester) async {
    if (!Platform.isAndroid) {
      return;
    }

    final handset = await DeviceManager.instance.isHandset();
    expect(handset.result, true, reason: "isHandset false");
    expect(handset.data, isA<bool>(), reason: "isHandset false");
    expect(handset.data, false, reason: "请检查设备是否为URA4"); // 如果为true，则不是URA4设备

    final serial = await DeviceManager.instance.getSerialNumber();
    expect(serial.result, true, reason: "getSerialNumber false");
    expect(serial.data, isNotNull, reason: "getSerialNumber null");
    expect(serial.data!.isNotEmpty, true, reason: "getSerialNumber empty");

    // final imei = await DeviceManager.instance.getImei();
    // expect(imei.result, true);
    // final imeiData = imei.data as Map<String, String?>;
    // expect(imeiData.length, 2);
    // expect(imeiData['imei1'], isNotNull);
    // expect(imeiData['imei2'], isNotNull);
    // expect(imeiData['imei1']!.isNotEmpty, true);
    // expect(imeiData['imei2']!.isNotEmpty, true);
    // print('getImei success: ${imei.data}');

    final init = await RfidWithUra4.instance.init();
    expect(init.isEffective, true, reason: "init false");

    final fw = await RfidWithUra4.instance.getUhfFirmwareVersion();
    expect(fw.result, true, reason: "getUhfFirmwareVersion false");
    expect(fw.data, isA<String>(), reason: "getUhfFirmwareVersion null");
    expect(fw.data!.isNotEmpty, true, reason: "getUhfFirmwareVersion empty");

    final hw = await RfidWithUra4.instance.getUhfHardwareVersion();
    expect(hw.result, true, reason: "getUhfHardwareVersion false");
    expect(hw.data, isA<String>(), reason: "getUhfHardwareVersion null");
    expect(hw.data!.isNotEmpty, true, reason: "getUhfHardwareVersion empty");

    final temp = await RfidWithUra4.instance.getUhfTemperature();
    expect(temp.result, true, reason: "getUhfTemperature false");
    expect(temp.data, isA<int>(), reason: "getUhfTemperature null");

    // 获取并设置频率
    final freq = await RfidWithUra4.instance.getFrequency();
    expect(freq.result, true, reason: "getFrequency false");
    expect(freq.data, isA<RfidFrequency>(), reason: "getFrequency null");
    final setFreq = await RfidWithUra4.instance.setFrequency(freq.data!);
    expect(setFreq.isEffective, true, reason: "setFrequency false");

    // 获取并设置天线
    final ant = await RfidWithUra4.instance.getAntennaState(0);
    expect(ant.result, true, reason: "getAntennaState false");
    expect(ant.data, isA<List<RfidAntennaState>>(), reason: "getAntennaState null");
    final setAnt = await RfidWithUra4.instance.setAntennaState(ant.data!);
    expect(setAnt.isEffective, true, reason: "setAntennaState false");

    // 获取并设置射频链路
    final rfLink = await RfidWithUra4.instance.getRfLink();
    expect(rfLink.result, true, reason: "getRfLink false");
    expect(rfLink.data, isA<RfidRfLink>(), reason: "getRfLink null");
    final setRfLink = await RfidWithUra4.instance.setRfLink(rfLink.data!);
    expect(setRfLink.isEffective, true, reason: "setRfLink false");

    // 获取并设置盘点模式
    final invMode = await RfidWithUra4.instance.getInventoryMode();
    expect(invMode.result, true, reason: "getInventoryMode false");
    expect(invMode.data, isA<RfidInventoryMode>(), reason: "getInventoryMode null");
    final setInvMode = await RfidWithUra4.instance.setInventoryMode(invMode.data!);
    expect(setInvMode.isEffective, true, reason: "setInventoryMode false");

    // 获取并设置 Gen2
    final gen2 = await RfidWithUra4.instance.getGen2();
    expect(gen2.result, true, reason: "getGen2 false");
    expect(gen2.data, isA<RfidGen2>(), reason: "getGen2 null");
    final setGen2 = await RfidWithUra4.instance.setGen2(gen2.data!);
    expect(setGen2.isEffective, true, reason: "setGen2 false");

    // 获取并设置 FastInventory
    final fastInventory = await RfidWithUra4.instance.getFastInventory();
    expect(fastInventory.result, true, reason: "getFastInventory false");
    expect(fastInventory.data, isA<RfidFastInventory>(), reason: "getFastInventory null");
    final setFastInventory = await RfidWithUra4.instance.setFastInventory(fastInventory.data!);
    expect(setFastInventory.isEffective, true, reason: "setFastInventory false");

    // 获取并设置 FastId
    final fastId = await RfidWithUra4.instance.getFastId();
    expect(fastId.result, true, reason: "getFastId false");
    expect(fastId.data, isA<bool>(), reason: "getFastId null");
    final setFastId = await RfidWithUra4.instance.setFastId(fastId.data!);
    expect(setFastId.isEffective, true, reason: "setFastId false");

    // 获取并设置 tagFocus 参数
    final tagFocus = await RfidWithUra4.instance.getTagFocus();
    expect(tagFocus.result, true, reason: "getTagFocus false");
    expect(tagFocus.data, isA<bool>(), reason: "getTagFocus null");
    final setTagFocus = await RfidWithUra4.instance.setTagFocus(tagFocus.data!);
    expect(setTagFocus.isEffective, true, reason: "setTagFocus false");

    // // 重置 UHF（可选）
    // final reset = await RfidWithUra4.instance.resetUhf();
    // expect(reset.isEffective, true, reason: "resetUhf false");

    // 设置空过滤器并执行一次盘点启停
    final filter = RfidFilter(enabled: true, bank: RfidBank.epc, offset: 0, length: 0, data: '');
    final setFilter = await RfidWithUra4.instance.setFilter(filter);
    expect(setFilter.isEffective, true, reason: "setFilter(empty) false");

    final startInv = await RfidWithUra4.instance.startInventory();
    expect(startInv.isEffective, true, reason: "startInventory false");
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final stopInv = await RfidWithUra4.instance.stopInventory();
    expect(stopInv.isEffective, true, reason: "stopInventory false");

    final free = await RfidWithUra4.instance.free();
    expect(free.isEffective, true, reason: "free false");

    print('URA4 real device test success');
  });
}
