/// Android implementation of the RFID Flutter plugin. <br/>
/// Android 超高频模块的 Flutter 插件实现。 <br/>
///
/// ### English
///
/// This library provides the official Android implementation of the RFID Flutter plugin. <br/>
/// Depending on the specific device type, the following interfaces are provided: <br/>
///
/// - [RfidWithUart] - Interfaces for handheld devices with UART-based UHF modules.
/// - [RfidWithUra4] - Interfaces for URA4 series UHF modules.
/// - [RfidWithDeviceInfo] - Interfaces for obtaining device information.
/// - [BarcodeDecoder] - Interfaces for barcode decoding.
///
///
/// ### 中文
///
/// 本库提供了 Android 超高频模块的 Flutter 插件实现，根据具体设备类型，提供了不同的接口：<br/>
///
/// - [RfidWithUart] - 手持机设备相关接口
/// - [RfidWithUra4] - URA4设备相关接口
/// - [RfidWithDeviceInfo] - 设备信息相关接口
/// - [BarcodeDecoder] - 条码解码器接口
///
library;

export 'src/rfid_with_uart.dart';
export 'src/rfid_with_ura4.dart';
export 'src/rfid_with_device_info.dart';
export 'src/barcode_decoder.dart';

export 'package:rfid_flutter_core/rfid_flutter_core.dart';
