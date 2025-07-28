enum RfidLockMode {
  /// lock the tag <br/>
  /// 锁定标签
  lock(0x10),

  /// unlock the tag
  /// 解锁标签
  unlock(0x20),

  /// permanent lock the tag <br/>
  /// 永久锁定标签
  permanentLock(0x30),

  /// permanent unlock the tag <br/>
  /// 永久解锁标签
  permanentUnlock(0x40);

  const RfidLockMode(this.value);

  final int value;

  static RfidLockMode? fromValue(int value) {
    for (RfidLockMode mode in RfidLockMode.values) {
      if (mode.value == value) {
        return mode;
      }
    }
    return null;
  }

  String get description {
    switch (this) {
      case lock:
        return 'Lock';
      case unlock:
        return 'Unlock';
      case permanentLock:
        return 'Permanent Lock';
      case permanentUnlock:
        return 'Permanent Unlock';
      default:
        return 'Unknown';
    }
  }
}
