# RFID Flutter Plugin

[![License: MIT](https://img.shields.io/badge/License-BSD-yellow.svg)](https://opensource.org/license/bsd-3-clause)

> 中文 | [English](README.md)

一个全面的 Flutter RFID 插件方案，为 RFID 操作提供统一接口和特定平台实现。


## 📦 包架构

本项目由多个包组成，共同提供完整的 RFID 解决方案：

```
rfid_flutter_plugin/
├── rfid_flutter_core/             # 核心接口和共享代码
├── rfid_flutter_android/          # Android 手持机/固定式设备插件
└── rfid_flutter_driver/           # 蓝牙、USB插件（计划中）
```


## 📚 软件包

### 📱 [rfid_flutter_core](./rfid_flutter_core)
[![pub package](https://img.shields.io/pub/v/rfid_flutter_core.svg)](https://pub.dev/packages/rfid_flutter_core)

基础核心包，提供：
- **RfidInterface**: 统一的 RFID 操作接口
- **数据类**: 返回结果、标签信息、配置等
- **枚举**: 内存区域、频段、RF链路等
- **工具类**: 标签处理和验证工具

### 📱 [rfid_flutter_android](./rfid_flutter_android)
[![pub package](https://img.shields.io/pub/v/rfid_flutter_android.svg)](https://pub.dev/packages/rfid_flutter_android)

Android 平台实现，支持：
- **设备兼容**: 兼容手持机、固定式设备
- **设备管理**: 设备序列号、IMEI等获取，按键事件监听
- **RFID**: 支持所有 RFID 操作
- **Barcode**: 支持扫描条形码、二维码等

### 📱 计划中的包

- **rfid_flutter_driver**: RFID 设备蓝牙、USB通讯插件


## 📄 许可证

本项目基于 BSD 许可证 - 详细信息请查看 [LICENSE](LICENSE) 文件。