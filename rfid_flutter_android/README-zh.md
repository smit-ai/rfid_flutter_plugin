# RFID Flutter Android

[![pub package](https://img.shields.io/pub/v/rfid_flutter_android.svg)](https://pub.dev/packages/rfid_flutter_android)

> 中文 | [English](README.md)

Android 平台的 RFID 实现包，支持 UART 和 URA4 相关设备。

## 📦 功能特性

### 🔌 设备支持
- **UART 设备**: 支持基于 UART 的 RFID 读写器
- **URA4 设备**: 支持基于 URA4 的 RFID 读写器
- **设备信息**: 访问设备序列号、IMEI 等设备信息

### 🏷️ RFID 操作
- **标签盘点**: 单次和连续标签扫描，支持过滤
- **标签读写**: 读写不同标签内存区域的数据
- **标签锁定/销毁**: 锁定或永久销毁标签
- **实时数据流**: 实时标签数据流，支持去重过滤

### ⚙️ 配置功能
- **频段设置**: 支持多个频段
- **功率控制**: 可调节发射功率（1-30）
- **天线管理**: 多天线支持和配置
- **Gen2 协议**: 完整的 Gen2 协议参数配置
- **更多功能**: FastInventory、TagFocus、FastId 模式

## 🚀 快速开始

### 📥 安装

在 `pubspec.yaml` 中添加：

```yaml
dependencies:
  rfid_flutter_android: ^0.0.1
```

### 📱 Android 配置

若使用 `RfidWithDeviceInfo` 相关接口，需要在 `android/app/src/main/AndroidManifest.xml` 中添加以下权限：

```xml
<uses-permission android:name="android.permission.READ_PRIVILEGED_PHONE_STATE" tools:ignore="ProtectedPermissions" />
```

### 📖 基本用法

#### 导入包

```dart
import 'package:rfid_flutter_android/rfid_flutter_android.dart';
```

#### UART 设备示例

```dart
import 'package:rfid_flutter_android/rfid_flutter_android.dart';


// 初始化 RFID 模块
final initRes = await RfidWithUart.instance.init();
print(initRes.isEffective ? '初始化成功' : '初始化失败: ${initRes.error}');
// 释放 RFID 模块
final freeRes = await RfidWithUart.instance.free();
print(freeRes.isEffective ? '释放成功' : '释放失败: ${freeRes.error}');


// 监听盘点数据
RfidWithUart.instance.listen((tags) {
    for (final tag in tags) {
    print('发现标签: ${tag.epc}');
    }
});
// 开始盘点
final startRes = await RfidWithUart.instance.startInventory();
print(startRes.isEffective ? '开启盘点成功' : '开启盘点失败: ${startRes.error}');
// 停止盘点
final stopRes = await RfidWithUart.instance.stopInventoy();
print(stopRes.isEffective ? '停止盘点成功' : '停止盘点失败: ${stopRes.error}');

// 设置频段
final setFrequencyRes = await RfidWithUart.instance.setFrequency(RfidFrequency.china2);
print(setFrequencyRes.isEffective ? '设置成功' : '设置失败: ${setFrequencyRes.error}');
// 获取频段
final getFrequencyRes = await RfidWithUart.instance.getFrequency();
print(getFrequencyRes.result ? '获取成功' : '获取失败: ${getFrequencyRes.data}');

//设置功率
final setPowerRes = await RfidWithUart.instance.setPower();
print(setPowerRes.isEffective ? '设置成功' : '设置失败: ${setPowerRes.error}');
// 获取功率
final getPowerRes = await RfidWithUart.instance.getPower();
print(getPowerRes.result ? '获取成功' : '获取失败: ${getPowerRes.data}');
```

#### URA4 设备示例

```dart
import 'package:rfid_flutter_android/rfid_flutter_android.dart';


// 初始化 RFID 模块
final initRes = await RfidWithUra4.instance.init();
print(initRes.isEffective ? '初始化成功' : '初始化失败: ${initRes.error}');
// 释放 RFID 模块
final freeRes = await RfidWithUra4.instance.free();
print(freeRes.isEffective ? '释放成功' : '释放失败: ${freeRes.error}');


// 监听盘点数据
RfidWithUra4.instance.listen((tags) {
    for (final tag in tags) {
    print('发现标签: ${tag.epc}');
    }
});
// 开始盘点
final startRes = await RfidWithUra4.instance.startInventory();
print(startRes.isEffective ? '开启盘点成功' : '开启盘点失败: ${startRes.error}');
// 停止盘点
final stopRes = await RfidWithUra4.instance.stopInventoy();
print(stopRes.isEffective ? '停止盘点成功' : '停止盘点失败: ${stopRes.error}');

// 设置频段
final setFrequencyRes = await RfidWithUra4.instance.setFrequency();
print(setFrequencyRes.isEffective ? '设置成功' : '设置失败: ${setFrequencyRes.error}');
// 获取频段
final getFrequencyRes = await RfidWithUra4.instance.getFrequency();
print(getFrequencyRes.result ? '获取成功' : '获取失败: ${getFrequencyRes.data}');

//设置功率
final setPowerRes = await RfidWithUra4.instance.setPower();
print(setPowerRes.isEffective ? '设置成功' : '设置失败: ${setPowerRes.error}');
// 获取功率
final getPowerRes = await RfidWithUra4.instance.getPower();
print(getPowerRes.result ? '获取成功' : '获取失败: ${getPowerRes.data}');
```

更多示例请查看示例应用



## 📋 API 参考

### 主要类

| 类                   | 描述          |
| -------------------- | ------------- |
| `RfidWithUart`       | UART 设备实现 |
| `RfidWithUra4`       | URA4 设备实现 |
| `RfidWithDeviceInfo` | 设备信息访问  |

### 核心功能

| 功能          | UART | URA4 | 描述                            |
| ------------- | ---- | ---- | ------------------------------- |
| 基础操作      | ✅    | ✅    | 初始化、释放、重置              |
| 标签盘点      | ✅    | ✅    | 单次和连续扫描                  |
| 标签读写      | ✅    | ✅    | 内存区域访问                    |
| 标签锁定/销毁 | ✅    | ✅    | 安全操作                        |
| 频段控制      | ✅    | ✅    | 全球频段支持                    |
| 功率控制      | ✅    | ✅    | 1-30 功率级别                   |
| 天线控制      | ❌    | ✅    | 多天线支持                      |
| Gen2 配置     | ✅    | ✅    | 协议参数                        |
| 其他功能      | ✅    | ✅    | FastInventory、TagFocus、FastId |

## 🔗 相关包

- **[rfid_flutter_core](https://pub.dev/packages/rfid_flutter_core)**: 核心接口和数据结构

## 📄 许可证

本项目基于 BSD 许可证开源。详细信息请查看 [LICENSE](LICENSE) 文件。
