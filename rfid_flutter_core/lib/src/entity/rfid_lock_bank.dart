/// RFID lock bank <br/>
/// RFID锁定区域
enum RfidLockBank {
  /// Kill password area of the Reserved memory bank <br/>
  /// Reserved 的 kill 密码区域
  kill(0x10),

  /// Access password area of the Reserved memory bank <br/>
  /// Reserved 的 access 密码区域
  access(0x20),

  /// EPC memory bank <br/>
  /// EPC区域
  epc(0x30),

  /// TID memory bank <br/>
  /// TID 区域
  tid(0x40),

  /// USER memory bank <br/>
  /// USER 区域
  user(0x50);

  const RfidLockBank(this.value);

  /// The numeric value of the memory bank <br/>
  /// 标签数据区域的数值
  final int value;

  /// Find memory bank by value <br/>
  /// 根据值查找标签数据区域
  static RfidLockBank? fromValue(int value) {
    for (RfidLockBank bank in RfidLockBank.values) {
      if (bank.value == value) {
        return bank;
      }
    }
    return null;
  }

  String get description {
    switch (this) {
      case kill:
        return 'Kill';
      case access:
        return 'Access';
      case epc:
        return 'EPC';
      case tid:
        return 'TID';
      case user:
        return 'USER';
      default:
        return 'Unknown';
    }
  }
}
