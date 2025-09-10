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

  RfidFilter({
    required this.enabled,
    this.offset = 0,
    this.length = 0,
    this.bank = RfidBank.epc,
    this.data = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'enabled': enabled,
      'offset': offset,
      'length': length,
      'bank': bank.value,
      'data': data,
    };
  }

  @override
  String toString() {
    return 'RfidFilter(enabled: $enabled, offset: $offset, length: $length, bank: $bank, data: $data)';
  }
}
