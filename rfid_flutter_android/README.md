# RFID Flutter Android

[![pub package](https://img.shields.io/pub/v/rfid_flutter_android.svg)](https://pub.dev/packages/rfid_flutter_android)

> English | [中文文档](https://github.com/RFID-Devs/rfid_flutter_plugin/blob/main/rfid_flutter_android/README-zh.md)

RFID implementation package for the Android platform, supporting UART and URA4 related devices.

Refer to the [RFID Documentation](https://github.com/RFID-Devs/rfid_flutter_plugin/wiki/RFID-en) for details on the plugin’s interface design and usage if you are unfamiliar with RFID technology and related terminology.

**Important Note: This plugin is designed exclusively for specific pre-adapted hardware environments and is not a universal RFID solution. Unverified devices may not be compatible. Please evaluate carefully before integration.**


## 📋 API Reference

For more detailed interface information, see [API reference](https://pub.dev/documentation/rfid_flutter_android/latest/rfid_flutter_android/)

### Main Classes

| Class                                                                                                                      | Description                                           |
| -------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------- |
| [RfidWithUart](https://pub.dev/documentation/rfid_flutter_android/latest/rfid_flutter_android/RfidWithUart-class.html)     | UART device RFID functionality implementation         |
| [RfidWithUra4](https://pub.dev/documentation/rfid_flutter_android/latest/rfid_flutter_android/RfidWithUra4-class.html)     | URA4 device RFID functionality implementation         |
| [BarcodeDecoder](https://pub.dev/documentation/rfid_flutter_android/latest/rfid_flutter_android/BarcodeDecoder-class.html) | Barcode parsing functionality implementation          |
| [DeviceManager](https://pub.dev/documentation/rfid_flutter_android/latest/rfid_flutter_android/DeviceManager-class.html)   | Device info (SN, IMEI, etc.) and key event monitoring |

### Core Features

#### RFID

| Feature                                 | UART  | URA4  | Description                |
| --------------------------------------- | :---: | :---: | -------------------------- |
| init                                    |   ✔️   |   ✔️   | Initialize RFID module     |
| free                                    |   ✔️   |   ✔️   | Release RFID module        |
| singleInventory                         |   ✔️   |   ✔️   | Single inventory           |
| startInventory                          |   ✔️   |   ✔️   | Start continuous inventory |
| stopInventory                           |   ✔️   |   ✔️   | Stop continuous inventory  |
| readData                                |   ✔️   |   ✔️   | Read tag data              |
| writeData                               |   ✔️   |   ✔️   | Write tag data             |
| lockTag                                 |   ✔️   |   ✔️   | Lock tag                   |
| killTag                                 |   ✔️   |   ✔️   | Kill tag                   |
| setFrequency <br/> getFrequency         |   ✔️   |   ✔️   | Frequency band             |
| setPower <br/> getPower                 |   ✔️   |   ❌   | Power                      |
| setAntennaState <br/> getAntennaState   |   ❌   |   ✔️   | Multi-antenna management   |
| setInventoryMode <br/> getInventoryMode |   ✔️   |   ✔️   | Inventory area             |
| setRfLink <br/> getRfLink               |   ✔️   |   ✔️   | RF Link                    |
| setGen2 <br/> getGen2                   |   ✔️   |   ✔️   | Gen2 parameters            |
| setFastId <br/> getFastId               |   ✔️   |   ✔️   | FastID                     |
| setTagFocus <br/> getTagFocus           |   ✔️   |   ✔️   | TagFocus                   |
| resetUhf                                |   ✔️   |   ✔️   | Reset UHF module           |

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


