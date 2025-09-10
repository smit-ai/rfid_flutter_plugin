# RFID Flutter Plugin

[![License: BSD](https://img.shields.io/badge/License-BSD-yellow.svg)](https://opensource.org/license/bsd-3-clause)

> English | [中文文档](README-zh.md)

A comprehensive Flutter plugin ecosystem for RFID operations, providing unified interfaces and platform-specific implementations for RFID readers.

## 📦 Package Architecture

This project consists of multiple packages working together to provide a complete RFID solution:

```
rfid_flutter_plugin/
├── rfid_flutter_core/             # Core interfaces and shared code
├── rfid_flutter_android/          # Android handheld/fixed devices plugin
└── rfid_flutter_driver/           # RFID device Bluetooth/USB plugin (planned)
```

## 📚 Packages

### 📱 [rfid_flutter_core](./rfid_flutter_core)
[![pub package](https://img.shields.io/pub/v/rfid_flutter_core.svg)](https://pub.dev/packages/rfid_flutter_core)

The foundational core package providing:
- **RfidInterface**: Unified RFID operation interface
- **Data Classes**: results, Tag information, configurations, etc.
- **Enums**: Memory banks, frequencies, rfLink, etc.
- **Utilities**: Tag processing and validation tools

### 📱 [rfid_flutter_android](./rfid_flutter_android)
[![pub package](https://img.shields.io/pub/v/rfid_flutter_android.svg)](https://pub.dev/packages/rfid_flutter_android)

Android platform implementation supporting:
- **UART Devices**: Compatible with handheld devices
- **URA4 Devices**: Compatible with fixed devices
- **Device Information**: Access to device serial number, IMEI, etc.
- **RFID**: All RFID operations with native performance

### 🔮 Planned Packages

- **rfid_flutter_driver**: Bluetooth/USB RFID device connectivity

## 🚀 Getting Started

### 📥 Installation

For Android RFID operations, add to your `pubspec.yaml`:

```yaml
dependencies:
  rfid_flutter_android: ^0.1.0
```

The core package is automatically included as a dependency.

## ✨ Features

### 🏷️ Tag Operations
- **Inventory**: Single and continuous tag scanning
- **Read/Write**: Access all memory banks (EPC, TID, USER, RESERVED)
- **Lock/Kill**: Tag security and lifecycle management
- **Filtering**: Precise tag selection and filtering

### ⚙️ Device Configuration
- **Frequency Control**: Multiple frequency band support
- **Power Management**: Adjustable RF power
- **Protocol Settings**: Gen2 protocol configuration
- **More Features**: FastInventory, TagFocus, FastId, etc


## 📖 Documentation

- [rfid_flutter_core](./rfid_flutter_core/README.md) - Interfaces and shared code
- [rfid_flutter_android](./rfid_flutter_android/README.md) - Plugin for handheld/A4 and other Android devices


## 📄 License

This project is licensed under the BSD License. See the [LICENSE](LICENSE) file for details.


