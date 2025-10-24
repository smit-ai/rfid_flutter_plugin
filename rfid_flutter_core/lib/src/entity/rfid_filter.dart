import 'package:rfid_flutter_core/rfid_flutter_core.dart';

/// RFID filter parameter <br/>
/// RFID 过滤参数
class RfidFilter {
  /// Whether the filter is enabled <br/>
  /// 是否启用过滤
  bool enabled;

  /// Offset of the filter, unit bit <br/>
  /// 过滤器偏移量，单位 bit
  int offset;

  /// Length of the filter, unit bit <br/>
  /// 过滤长度，单位 bit
  int length;

  /// Bank of the filter <br/>
  /// 过滤区域
  RfidBank bank;

  /// Data of the filter <br/>
  /// 过滤数据
  String data;

  /// Constructor to initialize RfidFilter parameters <br/>
  /// 构造函数，初始化 RfidFilter 参数
  RfidFilter({
    required this.enabled,
    this.offset = 0,
    this.length = 0,
    this.bank = RfidBank.epc,
    this.data = '',
  });

  /// Convert to Map for serialization <br/>
  /// 转换为 Map，便于序列化
  Map<String, dynamic> toMap() {
    return {
      'enabled': enabled,
      'offset': offset,
      'length': length,
      'bank': bank.value,
      'data': data,
    };
  }

  /// Create RfidFilter instance from Map <br/>
  /// 从 Map 创建 RfidFilter 实例
  ///
  /// Returns null if [data] is null or invalid <br/>
  /// 如果 [data] 为 null 或无效则返回 null
  static RfidFilter? fromMap(dynamic data) {
    if (data == null) return null;
    try {
      final Map<String, dynamic> map = data is Map<String, dynamic> ? data : Map<String, dynamic>.from(data as Map);

      return RfidFilter(
        enabled: map['enabled'] as bool? ?? false,
        offset: map['offset'] as int? ?? 0,
        length: map['length'] as int? ?? 0,
        bank: RfidBank.fromValue(map['bank'] as int? ?? RfidBank.epc.value) ?? RfidBank.epc,
        data: map['data'] as String? ?? '',
      );
    } catch (e) {
      return null;
    }
  }

  @override
  String toString() {
    return 'RfidFilter(enabled: $enabled, offset: $offset, length: $length, bank: $bank, data: $data)';
  }
}
