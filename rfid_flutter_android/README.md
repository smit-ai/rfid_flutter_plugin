# RFID Flutter Android

[![pub package](https://img.shields.io/pub/v/rfid_flutter_android.svg)](https://pub.dev/packages/rfid_flutter_android)

> English | [中文文档](https://github.com/RFID-Devs/rfid_flutter_plugin/blob/main/rfid_flutter_android/README-zh.md)

RFID implementation package for the Android platform, supporting UART and URA4 related devices.

Refer to the [RFID Documentation](https://github.com/RFID-Devs/rfid_flutter_plugin/wiki/RFID-en) for details on the plugin’s interface design and usage if you are unfamiliar with RFID technology and related terminology.

**Important Note: This plugin is designed exclusively for specific pre-adapted hardware environments and is not a universal RFID solution. Unverified devices may not be compatible. Please evaluate carefully before integration.**


## 📋 API Reference

### Main Classes

| Class            | Description                                           |
| ---------------- | ----------------------------------------------------- |
| `RfidWithUart`   | UART device RFID functionality implementation         |
| `RfidWithUra4`   | URA4 device RFID functionality implementation         |
| `BarcodeDecoder` | Barcode parsing functionality implementation          |
| `DeviceManager`  | Device info (SN, IMEI, etc.) and key event monitoring |

### Core Features

#### RFID

| Feature                                 |        UART        |        URA4        | Description                |
| --------------------------------------- | :----------------: | :----------------: | -------------------------- |
| init                                    | :heavy_check_mark: | :heavy_check_mark: | Initialize RFID module     |
| free                                    | :heavy_check_mark: | :heavy_check_mark: | Release RFID module        |
| singleInventory                         | :heavy_check_mark: | :heavy_check_mark: | Single inventory           |
| startInventory                          | :heavy_check_mark: | :heavy_check_mark: | Start continuous inventory |
| stopInventory                           | :heavy_check_mark: | :heavy_check_mark: | Stop continuous inventory  |
| readData                                | :heavy_check_mark: | :heavy_check_mark: | Read tag data              |
| writeData                               | :heavy_check_mark: | :heavy_check_mark: | Write tag data             |
| lockTag                                 | :heavy_check_mark: | :heavy_check_mark: | Lock tag                   |
| killTag                                 | :heavy_check_mark: | :heavy_check_mark: | Kill tag                   |
| setFrequency <br/> getFrequency         | :heavy_check_mark: | :heavy_check_mark: | Frequency band             |
| setPower <br/> getPower                 | :heavy_check_mark: |        :x:         | Power                      |
| setAntennaState <br/> getAntennaState   |        :x:         | :heavy_check_mark: | Multi-antenna management   |
| setInventoryMode <br/> getInventoryMode | :heavy_check_mark: | :heavy_check_mark: | Inventory area             |
| setRfLink <br/> getRfLink               | :heavy_check_mark: | :heavy_check_mark: | RF Link                    |
| setGen2 <br/> getGen2                   | :heavy_check_mark: | :heavy_check_mark: | Gen2 parameters            |
| setFastId <br/> getFastId               | :heavy_check_mark: | :heavy_check_mark: | FastID                     |
| setTagFocus <br/> getTagFocus           | :heavy_check_mark: | :heavy_check_mark: | TagFocus                   |
| resetUhf                                | :heavy_check_mark: | :heavy_check_mark: | Reset UHF module           |

#### Barcode

| Feature   | Description        |
| --------- | ------------------ |
| init      | Initialize scanner |
| free      | Release scanner    |
| startScan | Start scanning     |
| stopScan  | Stop scanning      |

#### Device Manager

| Feature            | Description              |
| ------------------ | ------------------------ |
| getSerialNumber    | Get device serial number |
| getImei            | Get device IMEI          |
| keyDownEventStream | Key press event stream   |
| keyUpEventStream   | Key release event stream |


## 🚀 Getting Started

### 📥 Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  rfid_flutter_android: ^0.1.0
```

### 📖 Basic Usage

#### Import the Package

```dart
import 'package:rfid_flutter_android/rfid_flutter_android.dart';
```

#### UART Device Example

```dart
import 'package:rfid_flutter_android/rfid_flutter_android.dart';

// Initialize RFID module
final initRes = await RfidWithUart.instance.init();
print(initRes.isEffective ? 'Initialization successful' : 'Initialization failed: ${initRes.error}');
// Release RFID module
final freeRes = await RfidWithUart.instance.free();
print(freeRes.isEffective ? 'Release successful' : 'Release failed: ${freeRes.error}');

// Listen to inventory data
StreamSubscription<List<RfidTagInfo>> tagSubscription = RfidWithUart.instance.rfidTagStream.listen((tags) {
  for (final tag in tags) {
    print('Found tag: ${tag.epc}');
  }
});
// Stop listening to inventory data
tagSubscription.cancel();

// Start inventory
final startRes = await RfidWithUart.instance.startInventory();
print(startRes.isEffective ? 'Start inventory successful' : 'Start inventory failed: ${startRes.error}');
// Stop inventory
final stopRes = await RfidWithUart.instance.stopInventory();
print(stopRes.isEffective ? 'Stop inventory successful' : 'Stop inventory failed: ${stopRes.error}');

// Set frequency
final setFrequencyRes = await RfidWithUart.instance.setFrequency(RfidFrequency.china2);
print(setFrequencyRes.isEffective ? 'Set successful' : 'Set failed: ${setFrequencyRes.error}');
// Get frequency
final getFrequencyRes = await RfidWithUart.instance.getFrequency();
print(getFrequencyRes.result ? 'Get successful' : 'Get failed: ${getFrequencyRes.data}');

// Set power to 20
final setPowerRes = await RfidWithUart.instance.setPower(20);
print(setPowerRes.isEffective ? 'Set successful' : 'Set failed: ${setPowerRes.error}');
// Get power
final getPowerRes = await RfidWithUart.instance.getPower();
print(getPowerRes.result ? 'Get successful' : 'Get failed: ${getPowerRes.data}');
```

#### URA4 Device Example

```dart
import 'package:rfid_flutter_android/rfid_flutter_android.dart';

// Initialize RFID module
final initRes = await RfidWithUra4.instance.init();
print(initRes.isEffective ? 'Initialization successful' : 'Initialization failed: ${initRes.error}');
// Release RFID module
final freeRes = await RfidWithUra4.instance.free();
print(freeRes.isEffective ? 'Release successful' : 'Release failed: ${freeRes.error}');

// Listen to inventory data
StreamSubscription<List<RfidTagInfo>> tagSubscription = RfidWithUra4.instance.rfidTagStream.listen((tags) {
  for (final tag in tags) {
    print('Found tag: ${tag.epc}');
  }
});
// Stop listening to inventory data
tagSubscription.cancel();

// Start inventory
final startRes = await RfidWithUra4.instance.startInventory();
print(startRes.isEffective ? 'Start inventory successful' : 'Start inventory failed: ${startRes.error}');
// Stop inventory
final stopRes = await RfidWithUra4.instance.stopInventory();
print(stopRes.isEffective ? 'Stop inventory successful' : 'Stop inventory failed: ${stopRes.error}');

// Set frequency
final setFrequencyRes = await RfidWithUra4.instance.setFrequency(RfidFrequency.usa);
print(setFrequencyRes.isEffective ? 'Set successful' : 'Set failed: ${setFrequencyRes.error}');
// Get frequency
final getFrequencyRes = await RfidWithUra4.instance.getFrequency();
print(getFrequencyRes.result ? 'Get successful' : 'Get failed: ${getFrequencyRes.data}');

// Set power to 25
final setPowerRes = await RfidWithUra4.instance.setPower(25);
print(setPowerRes.isEffective ? 'Set successful' : 'Set failed: ${setPowerRes.error}');
// Get power
final getPowerRes = await RfidWithUra4.instance.getPower();
print(getPowerRes.result ? 'Get successful' : 'Get failed: ${getPowerRes.data}');
```

#### Barcode Example

```dart
import 'package:rfid_flutter_android/rfid_flutter_android.dart';

// Initialize barcode scanner
final initRes = await BarcodeDecoder.instance.init();
print(initRes.isEffective ? 'Initialization successful' : 'Initialization failed: ${initRes.error}');
// Release barcode scanner
final freeRes = await BarcodeDecoder.instance.free();
print(freeRes.isEffective ? 'Release successful' : 'Release failed: ${freeRes.error}');

// Listen to barcode data
StreamSubscription<RfidBarcodeInfo> barcodeSubscription = BarcodeDecoder.instance.barcodeStream.listen((barcodeInfo) {
  print(barcodeInfo.toString());
});
// Stop listening to barcode data
barcodeSubscription.cancel();

// Start barcode scanning
final startRes = BarcodeDecoder.instance.startScan();
// Stop barcode scanning
final stopRes = BarcodeDecoder.instance.stopScan();
```

For more examples, please check the example application


## 🔗 Related Packages

- **[rfid_flutter_core](https://pub.dev/packages/rfid_flutter_core)**: Core interfaces and data structures

## 📄 License

This project is licensed under the BSD License. See the [LICENSE](LICENSE) file for details.


