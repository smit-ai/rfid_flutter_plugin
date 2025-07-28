/// RFID inventory bank for specifying inventory areas <br/>
/// RFID盘点区域，用于指定盘点区域
enum RfidInventoryBank {
  /// Inventory reads EPC area <br/>
  /// 盘点读取EPC区域
  epc(0),

  /// Inventory reads EPC + TID areas <br/>
  /// 盘点读取EPC + TID区域
  epcTid(1),

  /// Inventory reads EPC + TID + USER areas <br/>
  /// 盘点读取EPC + TID + USER区域
  epcTidUser(2);

  const RfidInventoryBank(this.value);

  /// The numeric value of the inventory bank <br/>
  /// 盘点区域的数值
  final int value;

  /// Get inventory bank description <br/>
  /// 获取盘点区域描述
  String get description {
    switch (this) {
      case epc:
        return 'EPC';
      case epcTid:
        return 'EPC + TID';
      case epcTidUser:
        return 'EPC + TID + USER';
    }
  }

  /// Find inventory bank by value <br/>
  /// 根据值查找盘点区域
  static RfidInventoryBank? fromValue(int value) {
    for (RfidInventoryBank bank in RfidInventoryBank.values) {
      if (bank.value == value) {
        return bank;
      }
    }
    return null;
  }
}

/// Memory bank configuration for inventory operations <br/>
/// 盘点时读取的区域配置
class RfidInventoryMode {
  /// Inventory bank, see [RfidInventoryBank] <br/>
  /// 盘点区域，见 [RfidInventoryBank]
  RfidInventoryBank inventoryBank;

  /// Offset parameter , unit: word <br/>
  /// offset参数，单位(字)
  int offset;

  /// Length parameter , unit: word <br/>
  /// length参数，单位(字)
  int length;

  /// Initialize RfidInventoryMode class <br/>
  /// 初始化RfidInventoryMode类
  ///
  /// [inventoryBank] - Inventory bank, reference RfidInventoryBank <br/>
  /// [offset] - Offset parameter, unit: word <br/>
  /// [length] - Length parameter, unit: word
  RfidInventoryMode({
    this.inventoryBank = RfidInventoryBank.epc,
    this.offset = 0,
    this.length = 6,
  });

  /// Convert to Map for serialization <br/>
  /// 转换为 Map，便于序列化
  Map<String, dynamic> toMap() {
    return {
      'inventoryBank': inventoryBank.value,
      'offset': offset,
      'length': length,
    };
  }

  /// Create RfidInventoryMode instance from Map <br/>
  /// 从 Map 创建 RfidInventoryMode 实例
  ///
  /// Returns null if [data] is null or invalid <br/>
  /// 如果 [data] 为 null 或无效则返回 null
  static RfidInventoryMode? fromMap(dynamic data) {
    if (data == null) return null;

    try {
      final Map<String, dynamic> map = data is Map<String, dynamic> ? data : Map<String, dynamic>.from(data as Map);

      return RfidInventoryMode(
        inventoryBank: RfidInventoryBank.fromValue(map['inventoryBank'] as int? ?? 0) ?? RfidInventoryBank.epc,
        offset: map['offset'] as int? ?? 0,
        length: map['length'] as int? ?? 6,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  String toString() {
    return 'RfidInventoryMode(inventoryBank: ${inventoryBank.value}, offset: $offset, length: $length)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RfidInventoryMode && other.inventoryBank == inventoryBank && other.offset == offset && other.length == length;
  }

  @override
  int get hashCode {
    return Object.hash(inventoryBank, offset, length);
  }
}
