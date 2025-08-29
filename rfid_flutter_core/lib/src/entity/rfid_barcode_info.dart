/// Barcode information data class <br/>
/// 条码信息数据类
class RfidBarcodeInfo {
  static const int DECODE_SUCCESS = 1;
  static const int DECODE_TIMEOUT = 0;
  static const int DECODE_CANCEL = -1;
  static const int DECODE_FAILURE = -2;
  static const int DECODE_ENGINE_ERROR = -3;

  /// Result code <br/>
  /// 结果码 <br/>
  ///
  /// ### English
  /// | Result Code | Description |
  /// | :---: | --- |
  /// |   1   | Decode success |
  /// |   0   | Decode timeout |
  /// |  -1   | Decode cancel |
  /// |  -2   | Decode failure |
  /// | -3 | Decode engine error |
  ///
  /// ### 中文
  ///
  /// | 结果码 | 描述 |
  /// | :---: | --- |
  /// |   1   | 解码成功 |
  /// |   0   | 解码超时 |
  /// |  -1   | 解码取消 |
  /// |  -2   | 解码失败 |
  /// |  -3   | 解码引擎错误 |
  int resultCode;

  /// Barcode data, default use utf-8 decode. If you need to use other encoding, please use [barcodeData] field <br/>
  /// 条码数据，默认使用 utf-8 解析，如果需要其他编码进行解析，请使用 [barcodeData] 字段
  String barcode;

  /// Barcode data bytes <br/>
  /// 条码数据字节
  List<int> barcodeData;

  /// Barcode type <br/>
  /// 条码类型
  String barcodeType;

  /// Decode time, unit: milliseconds <br/>
  /// 解码时间，单位：毫秒
  int decodeTime;

  /// Extensions for custom data storage <br/>
  /// 扩展字段，用于存储自定义数据 <br/>
  ///
  /// #### English
  /// Default is an empty map. <br/>
  /// This field allows users to attach custom data to tags without modifying the core API. <br/>
  ///
  /// #### 中文
  /// 默认为空Map。
  /// 此字段允许用户在不修改核心 API 的情况下为标签附加自定义数据。
  Map<String, dynamic> extensions;

  /// Timestamp when barcode was read <br/>
  /// 读取到条码时的时间戳
  int timestamp;

  RfidBarcodeInfo({
    required this.resultCode,
    required this.barcode,
    this.barcodeData = const [],
    this.barcodeType = '',
    this.decodeTime = 0,
    Map<String, dynamic>? extensions,
    int? timestamp,
  })  : extensions = extensions ?? {},
        timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> toMap() {
    return {
      'resultCode': resultCode,
      'barcode': barcode,
      'barcodeData': barcodeData,
      'barcodeType': barcodeType,
      'decodeTime': decodeTime,
      'extensions': extensions,
      'timestamp': timestamp,
    };
  }

  /// #### English
  /// Create RfidBarcodeInfo instance from Map, RfidBarcodeInfo rfidBarcodeInfo <br/>
  /// Returns null if [data] is null or invalid
  ///
  /// #### 中文
  /// 从 Map 创建 RfidBarcodeInfo 实例 <br/>
  /// 如果 [data] 为 null 或无效则返回 null
  static RfidBarcodeInfo? fromMap(dynamic data) {
    if (data == null) return null;

    try {
      final Map<String, dynamic> map = data is Map<String, dynamic> ? data : Map<String, dynamic>.from(data as Map);

      return RfidBarcodeInfo(
        resultCode: map['resultCode'] as int? ?? 0,
        barcode: map['barcode'] as String? ?? '',
        barcodeData: map['barcodeData'] as List<int>? ?? [],
        barcodeType: map['barcodeType'] as String? ?? '',
        decodeTime: map['decodeTime'] as int? ?? 0,
        extensions: map['extensions'] as Map<String, dynamic>? ?? {},
        timestamp: map['timestamp'] as int? ?? 0,
      );
    } catch (e) {
      print('RfidBarcodeInfo.fromMap error: $e');
      return null;
    }
  }

  @override
  String toString() {
    final buffer = StringBuffer('RfidBarcodeInfo{');
    buffer.write('resultCode: $resultCode');
    buffer.write(', barcode: $barcode');
    buffer.write(', barcodeData: $barcodeData');
    buffer.write(', barcodeType: $barcodeType');
    buffer.write(', decodeTime: $decodeTime');
    buffer.write(', timestamp: $timestamp');
    if (extensions.isNotEmpty) {
      buffer.write(', extensions: $extensions');
    }
    buffer.write('}');
    return buffer.toString();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RfidBarcodeInfo &&
        other.resultCode == resultCode &&
        other.barcode == barcode &&
        other.barcodeData == barcodeData &&
        other.barcodeType == barcodeType &&
        other.decodeTime == decodeTime;
  }

  @override
  int get hashCode => Object.hash(resultCode, barcode, barcodeData, barcodeType, decodeTime);
}
