import 'package:flutter/services.dart';
import 'package:rfid_flutter_core/rfid_flutter_core.dart';
import 'package:rfid_flutter_android/src/method_channel_helper.dart';

/// #### English
/// Device information interface for RFID Flutter Android plugin. <br/>
/// Provides access to device serial number, IMEI, and device type information. <br/>
///
/// #### 中文
/// RFID Flutter Android 插件的设备信息接口。 <br/>
/// 提供访问设备序列号、IMEI 和设备类型信息的功能。 <br/>
class RfidWithDeviceInfo {
  static RfidWithDeviceInfo? _instance;

  /// #### English
  /// Get the singleton instance of RfidWithDeviceInfo. <br/>
  ///
  /// #### 中文
  /// 获取 RfidWithDeviceInfo 的单例实例。 <br/>
  static RfidWithDeviceInfo get instance {
    _instance ??= RfidWithDeviceInfo._();
    return _instance!;
  }

  late final MethodChannel _channel;
  late final MethodChannelHelper _methodChannelHelper;

  // Private constructor for singleton
  RfidWithDeviceInfo._() {
    _channel = const MethodChannel('rfid_flutter_android/deviceInfo');
    _methodChannelHelper = MethodChannelHelper(_channel);
  }

  /// #### English
  /// Get the device serial number. <br/>
  /// Returns a [RfidResult] where `data` is the serial number string. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 获取设备序列号。 <br/>
  /// 返回 [RfidResult]，成功时 `data` 为序列号字符串。 <br/>
  /// 失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<String>> getSerialNumber() async {
    return _methodChannelHelper.invokeStringMethod('getSerialNumber');
  }

  /// #### English
  /// Get the device IMEI information. <br/>
  /// Returns [RfidResult]. On failure, `error` contains the error description. <br/>
  /// On success, `data` is a Map, format as:
  /// ```json
  /// {
  ///   "imei1": "123456789012345",
  ///   "imei2": "123456789012345"
  /// }
  /// ```
  ///
  /// #### 中文
  /// 获取设备 IMEI 信息。 <br/>
  /// 返回 [RfidResult]，失败时 `error` 包含错误描述信息。成功时 `data` 数据格式为：
  /// ```json
  /// {
  ///   "imei1": "123456789012345",
  ///   "imei2": "123456789012345"
  /// }
  /// ```
  /// <br/>
  Future<RfidResult<Map<String, String>>> getImei() async {
    return _methodChannelHelper.invokeObjectMethod<Map<String, String>>(
      'getImei',
      (result) {
        if (result is Map) {
          return Map<String, String>.from(result);
        }
        return null;
      },
    );
  }

  /// #### English
  /// Check if the device is a handheld device. <br/>
  /// Returns a [RfidResult] where `data` is `true` if it's a handheld device, `false` if it's URA4. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 是否为手持机设备。 <br/>
  /// 返回 [RfidResult]，成功时 `data` 为 [bool], `true` 表示手持设备，`false` 表示 URA4 设备。 <br/>
  /// 失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<bool>> isHandset() async {
    return _methodChannelHelper.invokeBoolMethod('isHandset');
  }

  /// #### English
  /// Get comprehensive device information including serial number, IMEI, and device type. <br/>
  /// Returns a [RfidResult] where `data` is a Map containing all device information. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 获取包括序列号、IMEI 和设备类型在内的综合设备信息。 <br/>
  /// 返回 [RfidResult]，成功时 `data` 为包含所有设备信息的 Map。 <br/>
  /// 失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<Map<String, dynamic>>> getDeviceInfo() async {
    try {
      final serialResult = await getSerialNumber();
      if (!serialResult.result) {
        return RfidResult.failure('Failed to get serial number: ${serialResult.error}');
      }

      final imeiResult = await getImei();
      if (!imeiResult.result) {
        return RfidResult.failure('Failed to get IMEI: ${imeiResult.error}');
      }

      final handsetResult = await isHandset();
      if (!handsetResult.result) {
        return RfidResult.failure('Failed to check device type: ${handsetResult.error}');
      }

      final deviceInfo = <String, dynamic>{
        'serialNumber': serialResult.data,
        'imei1': imeiResult.data?['imei1'],
        'imei2': imeiResult.data?['imei2'],
        'isHandset': handsetResult.data,
        'deviceType': handsetResult.data == true ? 'Handheld' : 'URA4',
      };

      return RfidResult.success(deviceInfo);
    } catch (e) {
      return RfidResult.failure('Failed to get device info: $e');
    }
  }

  /// #### English
  /// Switch debug log <br/>
  /// Returns a [RfidResult] where `data` is `true` if the debug mode is set successfully, `false` if it fails. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 开关调试日志 <br/>
  /// 返回 [RfidResult]，成功时 `data` 为 [bool], `true` 表示调试模式设置成功，`false` 表示设置失败。 <br/>
  /// 失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<bool>> setDebug(bool value) async {
    return _methodChannelHelper.invokeBoolMethod('setDebug', {'value': value});
  }

  /// #### English
  /// Set the write log to file. <br/>
  /// Before using, you need to apply for storage permissions, otherwise it will return failure. <br/>
  /// The log file is saved in the root directory/DeviceAPI_Log.txt <br/>
  ///
  /// Note: You need to declare the following permissions:
  /// ```xml
  /// <uses-permission android:name="android.permission.READ_PRIVILEGED_PHONE_STATE" />
  /// <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
  /// <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
  /// ```
  ///
  /// Returns a [RfidResult] where `data` is `true` if the write log to file is set successfully, `false` if it fails. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 设置日志保存到文件 <br/>
  /// 使用前需要申请存储权限，否则会返回失败 <br/>
  /// 日志文件保存在 根目录/DeviceAPI_Log.txt <br/>
  ///
  /// 注意，使用本接口需要声明文件读写权限:
  /// ```xml
  /// <uses-permission android:name="android.permission.READ_PRIVILEGED_PHONE_STATE" />
  /// <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
  /// <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
  /// ```
  ///
  /// 返回 [RfidResult]，成功时 `data` 为 [bool], `true` 表示日志保存到文件设置成功，`false` 表示设置失败。 <br/>
  /// 失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<bool>> setWriteLog(bool value) async {
    return _methodChannelHelper.invokeBoolMethod('setWriteLog', {'value': value});
  }
}
