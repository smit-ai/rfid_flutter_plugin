# RFID Flutter Plugin

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

> English | [中文文档](README-zh.md)

A comprehensive Flutter plugin ecosystem for RFID operations, providing unified interfaces and platform-specific implementations for RFID readers.

## 📦 Package Architecture

This project consists of multiple packages working together to provide a complete RFID solution:

```
rfid_flutter_plugin/
├── rfid_flutter_core/             # Core interfaces and shared code
├── rfid_flutter_android/          # Android handheld/A4 plugin
├── rfid_flutter_bluetooth/        # RFID device Bluetooth plugin (planned)
└── rfid_flutter_usb/              # RFID device USB plugin (planned)
```

## 📚 Packages

### 🔧 [rfid_flutter_core](./rfid_flutter_core)
[![pub package](https://img.shields.io/pub/v/rfid_flutter_core.svg)](https://pub.dev/packages/rfid_flutter_core)

The foundational core package providing:
- **RfidInterface**: Unified RFID operation interface
- **Data Classes**: Tag information, results, configurations
- **Enums**: Memory banks, frequencies, protocols
- **Utilities**: Tag processing and validation tools

### 📱 [rfid_flutter_android](./rfid_flutter_android)
[![pub package](https://img.shields.io/pub/v/rfid_flutter_android.svg)](https://pub.dev/packages/rfid_flutter_android)

Android platform implementation supporting:
- **UART Devices**: Serial communication RFID readers
- **URA4 Devices**: URA4 protocol RFID readers
- **Device Information**: Access to device serial number, IMEI, and more
- **Full Feature Set**: All RFID operations with native performance

### 🔮 Planned Packages

- **rfid_flutter_bluetooth**: Bluetooth RFID device support
- **rfid_flutter_usb**: USB RFID device connectivity

## 🚀 Getting Started

### 📥 Installation

For Android RFID operations, add to your `pubspec.yaml`:

```yaml
dependencies:
  rfid_flutter_android: ^0.0.1
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
- **Power Management**: Adjustable RF power (1-30)
- **Protocol Settings**: Gen2 protocol configuration
- **More Features**: FastInventory, TagFocus, FastId

### 🔄 Real-time Processing
- **Live Streaming**: Real-time tag data streams
- **Duplicate Filtering**: Automatic tag deduplication
- **Event Handling**: Comprehensive event management

## 📖 Documentation

- [rfid_flutter_core](./rfid_flutter_core/README.md) - Interfaces and shared code
- [rfid_flutter_android](./rfid_flutter_android/README.md) - Plugin for handheld/A4 and other Android devices


## 📄 License

This project is licensed under the BSD License. See the [LICENSE](LICENSE) file for details.


