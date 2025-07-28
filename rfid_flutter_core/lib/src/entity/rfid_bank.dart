/// RFID tag memory banks <br/>
/// 标签数据区域
enum RfidBank {
  /// 0: RESERVED memory bank <br/>
  /// 保留区域
  reserved(0),

  /// 1: EPC memory bank <br/>
  /// EPC区域
  epc(1),

  /// 2: TID memory bank <br/>
  /// TID区域
  tid(2),

  /// 3: USER memory bank <br/>
  /// USER区域
  user(3);

  const RfidBank(this.value);

  /// The numeric value of the memory bank <br/>
  /// 标签数据区域的数值
  final int value;

  /// Get memory bank description <br/>
  /// 获取标签数据区域描述
  String get description {
    switch (this) {
      case reserved:
        return 'RESERVED';
      case epc:
        return 'EPC';
      case tid:
        return 'TID';
      case user:
        return 'USER';
    }
  }

  /// Find memory bank by value <br/>
  /// 根据值查找标签数据区域
  static RfidBank? fromValue(int value) {
    for (RfidBank bank in RfidBank.values) {
      if (bank.value == value) {
        return bank;
      }
    }
    return null;
  }
}
