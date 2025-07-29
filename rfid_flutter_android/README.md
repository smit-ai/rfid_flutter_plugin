# RFID Flutter Android

[![pub package](https://img.shields.io/pub/v/rfid_flutter_android.svg)](https://pub.dev/packages/rfid_flutter_android)

> English | [中文文档](https://github.com/RFID-Devs/rfid_flutter_plugin/blob/main/rfid_flutter_android/README-zh.md)

RFID implementation package for the Android platform, supporting UART and URA4 related devices.

## 📦 Features

### 🔌 Device Support
- **UART Devices**: Support for UART-based RFID readers
- **URA4 Devices**: Support for URA4-based RFID readers  
- **Device Information**: Access to device serial number, IMEI and other device information

### 🏷️ RFID Operations
- **Tag Inventory**: Single and continuous tag scanning with filtering support
- **Tag Read/Write**: Read and write data to different tag memory banks
- **Tag Lock/Kill**: Lock or permanently disable tags
- **Real-time Streaming**: Live tag data stream with duplicate filtering options

### ⚙️ Configuration
- **Frequency Settings**: Support for multiple frequency bands
- **Power Control**: Adjustable transmission power (1-30)
- **Antenna Management**: Multi-antenna support and configuration
- **Gen2 Protocol**: Full Gen2 protocol parameter configuration
- **More Features**: FastInventory, TagFocus, FastId modes

## 🚀 Getting Started

### 📥 Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  rfid_flutter_android: ^0.0.1
```

### 📱 Android Setup

If using `RfidWithDeviceInfo` related interfaces, add the following permission to your `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.READ_PRIVILEGED_PHONE_STATE" tools:ignore="ProtectedPermissions" />
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
RfidWithUart.instance.rfidTagStream.listen((tags) {
    for (final tag in tags) {
    print('Found tag: ${tag.epc}');
    }
});
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

// Set power
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
RfidWithUra4.instance.rfidTagStream.listen((tags) {
    for (final tag in tags) {
    print('Found tag: ${tag.epc}');
    }
});
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

// Set power
final setPowerRes = await RfidWithUra4.instance.setPower(25);
print(setPowerRes.isEffective ? 'Set successful' : 'Set failed: ${setPowerRes.error}');
// Get power
final getPowerRes = await RfidWithUra4.instance.getPower();
print(getPowerRes.result ? 'Get successful' : 'Get failed: ${getPowerRes.data}');
```

For more examples, please check the example application



## 📋 API Reference

### Main Classes

| Class                | Description        |
| -------------------- | ------------------ |
| `RfidWithUart`       | UART device implementation |
| `RfidWithUra4`       | URA4 device implementation |
| `RfidWithDeviceInfo` | Device information access  |

### Key Features

| Feature           | UART | URA4 | Description                        |
| ----------------- | ---- | ---- | ---------------------------------- |
| Basic Operations  | ✅    | ✅    | Init, free, reset                  |
| Tag Inventory     | ✅    | ✅    | Single and continuous scanning     |
| Tag Read/Write    | ✅    | ✅    | Memory bank access                 |
| Tag Lock/Kill     | ✅    | ✅    | Security operations                |
| Frequency Control | ✅    | ✅    | Global frequency support           |
| Power Control     | ✅    | ✅    | 1-30 power levels                  |
| Antenna Control   | ❌    | ✅    | Multi-antenna support              |
| Gen2 Configuration| ✅    | ✅    | Protocol parameters                |
| Other Features    | ✅    | ✅    | FastInventory, TagFocus, FastId    |

## 🔗 Related Packages

- **[rfid_flutter_core](https://pub.dev/packages/rfid_flutter_core)**: Core interfaces and data structures

## 📄 License

This project is licensed under the BSD License. See the [LICENSE](LICENSE) file for details.


