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
      final imeiResult = await getImei();
      final handsetResult = await isHandset();

      if (!serialResult.result) {
        return RfidResult.failure('Failed to get serial number: ${serialResult.error}');
      }
      if (!imeiResult.result) {
        return RfidResult.failure('Failed to get IMEI: ${imeiResult.error}');
      }
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
}
