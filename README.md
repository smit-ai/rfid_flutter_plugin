# RFID Flutter Plugin

[![License: BSD](https://img.shields.io/badge/License-BSD-yellow.svg)](https://opensource.org/license/bsd-3-clause)

> English | [中文文档](README-zh.md)

A comprehensive Flutter plugin for RFID operations, providing unified interfaces and platform-specific implementations for RFID readers.


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
- **Device compatible**: Compatible with handheld and fixed devices
- **Device Manager**: Get the device serial number, IMEI, etc., and listen for key events
- **RFID**: Support all RFID operations with native performance
- **Barcode**: Support scanning of barcodes, QR codes, etc.

### 📱 Planned Packages

- **rfid_flutter_driver**: Bluetooth/USB RFID device connectivity


## 📄 License

This project is licensed under the BSD License. See the [LICENSE](LICENSE) file for details.


