# RFID Flutter Android

[![pub package](https://img.shields.io/pub/v/rfid_flutter_android.svg)](https://pub.dev/packages/rfid_flutter_android)

> 中文 | [English](README.md)

Android 平台 RFID 设备集成插件，支持 UART 和 URA4 设备

如不熟悉 RFID 技术背景及相关术语，建议参阅 [RFID 说明文档](https://github.com/RFID-Devs/rfid_flutter_plugin/wiki/RFID-zh)，以便更好地理解插件接口的功能设计与使用方式

**重要提示：本插件仅适用于已完成适配的特定设备环境，非通用 RFID 插件。未经验证的设备可能无法工作，使用前请认真评估**


## 📋 API 参考

更详细的接口信息请查看 [API reference](https://pub.dev/documentation/rfid_flutter_android/latest/rfid_flutter_android/)

### 主要的类

| 类                                                                                                                         | 描述                               |
| -------------------------------------------------------------------------------------------------------------------------- | ---------------------------------- |
| [RfidWithUart](https://pub.dev/documentation/rfid_flutter_android/latest/rfid_flutter_android/RfidWithUart-class.html)     | UART 设备 RFID 相关功能实现        |
| [RfidWithUra4](https://pub.dev/documentation/rfid_flutter_android/latest/rfid_flutter_android/RfidWithUra4-class.html)     | URA4 设备 RFID 相关功能实现        |
| [BarcodeDecoder](https://pub.dev/documentation/rfid_flutter_android/latest/rfid_flutter_android/BarcodeDecoder-class.html) | 条码解析相关功能实现               |
| [DeviceManager](https://pub.dev/documentation/rfid_flutter_android/latest/rfid_flutter_android/DeviceManager-class.html)   | 获取sn、imei等设备信息，按键值监听 |

### 核心功能

#### RFID

| 功能                                    | UART  | URA4  | 描述           |
| --------------------------------------- | :---: | :---: | -------------- |
| init                                    |   ✔️   |   ✔️   | 初始化RFID模块 |
| free                                    |   ✔️   |   ✔️   | 释放RFID模块   |
| singleInventory                         |   ✔️   |   ✔️   | 单次盘点       |
| startInventory                          |   ✔️   |   ✔️   | 开启连续盘点   |
| stopInventory                           |   ✔️   |   ✔️   | 停止连续盘点   |
| readData                                |   ✔️   |   ✔️   | 读取标签数据   |
| writeData                               |   ✔️   |   ✔️   | 写入标签数据   |
| lockTag                                 |   ✔️   |   ✔️   | 锁定标签       |
| killTag                                 |   ✔️   |   ✔️   | 销毁标签       |
| setFrequency <br/> getFrequency         |   ✔️   |   ✔️   | 频段           |
| setPower <br/> getPower                 |   ✔️   |   ❌   | 功率           |
| setAntennaState <br/> getAntennaState   |   ❌   |   ✔️   | 多天线管理     |
| setInventoryMode <br/> getInventoryMode |   ✔️   |   ✔️   | 盘点区域       |
| setRfLink <br/> getRfLink               |   ✔️   |   ✔️   | RF链路         |
| setGen2 <br/> getGen2                   |   ✔️   |   ✔️   | Gen2参数       |
| setFastId <br/> getFastId               |   ✔️   |   ✔️   | FastID         |
| setTagFocus <br/> getTagFocus           |   ✔️   |   ✔️   | TagFocus       |
| resetUhf                                |   ✔️   |   ✔️   | 重置UHF模块    |

#### Barcode

| 功能      | 描述         |
| --------- | ------------ |
| init      | 初始化扫描头 |
| free      | 释放扫描头   |
| startScan | 开启扫码     |
| stopScan  | 停止扫码     |

#### Device Manager

| 功能               | 描述           |
| ------------------ | -------------- |
| getSerialNumber    | 获取设备序列号 |
| getImei            | 获取设备 IMEI  |
| keyDownEventStream | 按键按下事件流 |
| keyUpEventStream   | 按键抬起事件流 |


## 🚀 快速开始

####  安装

在 `pubspec.yaml` 中添加：

```yaml
dependencies:
  rfid_flutter_android: ^0.1.0
```

#### 导入包

```dart
import 'package:rfid_flutter_android/rfid_flutter_android.dart';
```

#### UART RFID 示例

```dart
import 'package:rfid_flutter_android/rfid_flutter_android.dart';

// 初始化 RFID 模块
final initRes = await RfidWithUart.instance.init();
print(initRes.isEffective ? '初始化成功' : '初始化失败: ${initRes.error}');
// 释放 RFID 模块
final freeRes = await RfidWithUart.instance.free();
print(freeRes.isEffective ? '释放成功' : '释放失败: ${freeRes.error}');

// 监听盘点数据
StreamSubscription<List<RfidTagInfo>> tagSubscription = RfidWithUart.instance.rfidTagStream.listen((tags) {
  for (final tag in tags) {
    print('发现标签: ${tag.epc}');
  }
});
// 停止监听盘点数据
tagSubscription.cancel();

// 开始盘点
final startRes = await RfidWithUart.instance.startInventory();
print(startRes.isEffective ? '开启盘点成功' : '开启盘点失败: ${startRes.error}');
// 停止盘点
final stopRes = await RfidWithUart.instance.stopInventory();
print(stopRes.isEffective ? '停止盘点成功' : '停止盘点失败: ${stopRes.error}');

// 设置频段
final setFrequencyRes = await RfidWithUart.instance.setFrequency(RfidFrequency.china2);
print(setFrequencyRes.isEffective ? '设置成功' : '设置失败: ${setFrequencyRes.error}');
// 获取频段
final getFrequencyRes = await RfidWithUart.instance.getFrequency();
print(getFrequencyRes.result ? '获取成功' : '获取失败: ${getFrequencyRes.data}');

//设置功率 20
final setPowerRes = await RfidWithUart.instance.setPower(20);
print(setPowerRes.isEffective ? '设置成功' : '设置失败: ${setPowerRes.error}');
// 获取功率
final getPowerRes = await RfidWithUart.instance.getPower();
print(getPowerRes.result ? '获取成功' : '获取失败: ${getPowerRes.data}');
```

#### Barcode 示例

```dart
import 'package:rfid_flutter_android/rfid_flutter_android.dart';

// 初始化 RFID 模块
final initRes = await BarcodeDecoder.instance.init();
print(initRes.isEffective ? '初始化成功' : '初始化失败: ${initRes.error}');
// 释放 RFID 模块
final freeRes = await BarcodeDecoder.instance.free();
print(freeRes.isEffective ? '释放成功' : '释放失败: ${freeRes.error}');

// 监听条码数据
StreamSubscription<RfidBarcodeInfo> barcodeSubscription = BarcodeDecoder.instance.barcodeStream.listen((barcodeInfo) {
  print(barcodeInfo.toString());
});
// 停止监听条码数据
barcodeSubscription.cancel();

// 开启2d扫描
final startRes = BarcodeDecoder.instance.startScan();
// 停止2d扫描
final stopRes = BarcodeDecoder.instance.stopScan();
```

更多示例请查看示例应用


## 🔗 相关包

- **[rfid_flutter_core](https://pub.dev/packages/rfid_flutter_core)**: 核心接口和数据结构

## 📄 许可证

本项目基于 BSD 许可证开源，详细信息请查看 [LICENSE](LICENSE) 文件
