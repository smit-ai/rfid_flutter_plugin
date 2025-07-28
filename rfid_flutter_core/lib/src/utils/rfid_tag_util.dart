import '../entity/rfid_tag_info.dart';
import '../entity/rfid_lock_bank.dart';
import '../entity/rfid_lock_mode.dart';

class RfidTagUtil {
  /// ### English
  /// Convert RSSI value to signal strength value (0-100) <br/>
  /// [rssi] RSSI value as string or number <br/>
  /// Returns signal strength value between 0-100 <br/>
  ///
  /// ### 中文
  /// 将RSSI值转换为信号强度值(0-100)
  /// [rssi] RSSI值作为字符串或数字
  /// 返回0-100之间的信号强度值
  static int rssiToValue(dynamic rssi) {
    double rssiValue;

    // Convert rssi to double
    if (rssi is String) {
      rssiValue = double.tryParse(rssi) ?? -80.0;
    } else if (rssi is num) {
      rssiValue = rssi.toDouble();
    } else {
      rssiValue = -80.0;
    }

    if (rssiValue <= -80.0) {
      return 0;
    } else if (rssiValue >= -30.0) {
      return 100;
    } else {
      return ((rssiValue + 80.0) * 2).toInt();
    }
  }

  /// ### English
  /// Binary search to find if a tag exists in the tag list <br/>
  /// [tagList] List of RFID tags to search in <br/>
  /// [tag] The tag to search for <br/>
  /// Returns a Map:
  /// ```json
  /// {
  ///   'index': index of the tag in the list or the position where it should be inserted,
  ///   'exist': whether the tag was found
  /// }
  /// ```
  ///
  /// ### 中文
  /// 二分法查找列表中是否存在某个标签 <br/>
  /// [tagList] 需要查找的标签列表 <br/>
  /// [tag] 需要查找的标签 <br/>
  /// 返回一个Map: <br/>
  /// ```dart
  /// {
  ///   'index': 标签所在位置或应该插入的位置,
  ///   'exist': 是否找到标签
  /// }
  /// ```
  static Map<String, dynamic> getTagIndex(List<RfidTagInfo> tagList, RfidTagInfo tag) {
    if (tagList.isEmpty) {
      return {'index': 0, 'exist': false};
    }

    final targetKey = tag.epc + tag.tid;

    int left = 0;
    int right = tagList.length - 1;

    while (left <= right) {
      final mid = left + ((right - left) >> 1); // More efficient than (left + right) / 2
      final midKey = tagList[mid].epc + tagList[mid].tid;
      final comparison = targetKey.compareTo(midKey);

      if (comparison == 0) {
        return {'index': mid, 'exist': true};
      } else if (comparison < 0) {
        right = mid - 1;
      } else {
        left = mid + 1;
      }
    }

    return {'index': left, 'exist': false};
  }

  /// ### English
  /// Generate lock code for RFID tag locking operation. <br/>
  /// [banks] List of memory banks to lock/unlock <br/>
  /// [mode] Lock mode (unlock, lock, permanentUnlock, permanentLock) <br/>
  /// Returns 6-digit hexadecimal string representing the lock code <br/>
  ///
  /// ### 中文
  /// 生成RFID标签锁定操作的代码。 <br/>
  /// [banks] 需要锁定的区域列表 <br/>
  /// [mode] 锁定模式（解锁，锁定，永久解锁，永久锁定） <br/>
  /// 返回6位16进制字符串表示的锁定代码 <br/>
  static String getLockCode(List<RfidLockBank> banks, RfidLockMode mode) {
    int iCode = 0;

    for (var bank in banks) {
      switch (bank) {
        case RfidLockBank.kill:
          switch (mode) {
            case RfidLockMode.unlock:
              // No operation for unlock
              break;
            case RfidLockMode.lock:
              iCode = iCode | 0x200;
              break;
            case RfidLockMode.permanentUnlock:
              iCode = iCode | 0x100;
              iCode = iCode | 0x40000;
              break;
            case RfidLockMode.permanentLock:
              iCode = iCode | 0x200;
              iCode = iCode | 0x100;
              iCode = iCode | 0x40000;
              break;
          }
          iCode = iCode | 0x80000;
          break;

        case RfidLockBank.access:
          switch (mode) {
            case RfidLockMode.unlock:
              // No operation for unlock
              break;
            case RfidLockMode.lock:
              iCode = iCode | 0x80;
              break;
            case RfidLockMode.permanentUnlock:
              iCode = iCode | 0x40;
              iCode = iCode | 0x10000;
              break;
            case RfidLockMode.permanentLock:
              iCode = iCode | 0x80;
              iCode = iCode | 0x40;
              iCode = iCode | 0x10000;
              break;
          }
          iCode = iCode | 0x20000;
          break;

        case RfidLockBank.epc:
          switch (mode) {
            case RfidLockMode.unlock:
              // No operation for unlock
              break;
            case RfidLockMode.lock:
              iCode = iCode | 0x20;
              break;
            case RfidLockMode.permanentUnlock:
              iCode = iCode | 0x10;
              iCode = iCode | 0x4000;
              break;
            case RfidLockMode.permanentLock:
              iCode = iCode | 0x20;
              iCode = iCode | 0x10;
              iCode = iCode | 0x4000;
              break;
          }
          iCode = iCode | 0x8000;
          break;

        case RfidLockBank.tid:
          // TID bank operations - currently commented out but available for future use
          // TID区域操作 - 当前被注释但保留供将来使用
          switch (mode) {
            case RfidLockMode.unlock:
              // No operation for unlock
              break;
            case RfidLockMode.lock:
              iCode = iCode | 0x08;
              break;
            case RfidLockMode.permanentUnlock:
              iCode = iCode | 0x04;
              iCode = iCode | 0x1000;
              break;
            case RfidLockMode.permanentLock:
              iCode = iCode | 0x08;
              iCode = iCode | 0x04;
              iCode = iCode | 0x1000;
              break;
          }
          iCode = iCode | 0x2000;
          break;

        case RfidLockBank.user:
          switch (mode) {
            case RfidLockMode.unlock:
              // No operation for unlock
              break;
            case RfidLockMode.lock:
              iCode = iCode | 0x02;
              break;
            case RfidLockMode.permanentUnlock:
              iCode = iCode | 0x01;
              iCode = iCode | 0x400;
              break;
            case RfidLockMode.permanentLock:
              iCode = iCode | 0x02;
              iCode = iCode | 0x01;
              iCode = iCode | 0x400;
              break;
          }
          iCode = iCode | 0x800;
          break;
      }
    }

    // Convert the generated value to a 6-digit hexadecimal string
    // 将生成的数值转换为6位16进制字符串
    const String zero = "000000";
    final String hexCode = iCode.toRadixString(16);
    return hexCode.length == 6 ? hexCode : zero.substring(0, 6 - hexCode.length) + hexCode;
  }
}
