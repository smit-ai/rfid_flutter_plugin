/// Fast Inventory mode <br/>
/// 快速盘点模式 <br/>
class RfidFastInventory {
  static const int crClose = 0x00;
  static const int crID16 = 0x01;
  static const int crStoredCRC = 0x02;
  static const int crRN16 = 0x03;
  static const int crID32 = 0x04;

  /// CR parameter <br/>
  /// CR参数 <br/>
  ///
  /// Selectable values: <br/>
  /// - 0x00 - [crClose]
  /// - 0x01 - [crID16]
  /// - 0x02 - [crStoredCRC]
  /// - 0x03 - [crRN16]
  /// - 0x04 - [crID32]
  final int cr;

  /// Initialize RfidFastInventory class <br/>
  /// 初始化RfidFastInventory类 <br/>
  ///
  /// [cr] - CR parameter <br/>
  /// [cr] - CR参数 <br/>
  RfidFastInventory({required this.cr});

  /// Convert to Map for serialization <br/>
  /// 转换为 Map，便于序列化
  Map<String, dynamic> toMap() {
    return {
      'cr': cr,
    };
  }

  /// Create RfidFastInventory instance from Map <br/>
  /// 从 Map 创建 RfidFastInventory 实例 <br/>
  ///
  /// Returns null if [data] is null or invalid <br/>
  /// 如果 [data] 为 null 或无效则返回 null
  static RfidFastInventory? fromMap(dynamic data) {
    if (data == null) return null;
    try {
      final Map<String, dynamic> map = data is Map<String, dynamic> ? data : Map<String, dynamic>.from(data as Map);

      return RfidFastInventory(
        cr: map['cr'] as int? ?? crClose,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  String toString() {
    return 'RfidFastInventory(cr: $cr)';
  }
}
