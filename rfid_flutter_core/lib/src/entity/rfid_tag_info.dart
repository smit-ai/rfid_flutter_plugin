/// RFID tag information data class <br/>
/// RFID标签信息数据类
class RfidTagInfo {
  /// Tag Reserved area data <br/>
  /// 标签Reserved区域数据
  String reserved;

  /// Tag EPC area data <br/>
  /// 标签EPC区域数据
  String epc;

  /// Tag TID area data <br/>
  /// 标签TID区域数据
  String tid;

  /// Tag USER area data <br/>
  /// 标签USER区数据
  String user;

  /// Tag PC value <br/>
  /// 标签PC值
  ///
  /// EPC length is determined by PC <br/>
  /// EPC的长度由PC决定
  String pc;

  /// Tag signal strength (RSSI), range: [-80, -30] dBm <br/>
  /// 标签信号值，范围：[-80, -30] dBm
  String rssi;

  /// Tag antenna number <br/>
  /// 标签天线编号
  int antenna;

  /// Tag read count <br/>
  /// 标签读取次数
  int count;

  /// Timestamp when tag was read <br/>
  /// 读取到标签时的时间戳
  int timestamp;

  /// Tag direction, range: 0-360, default: -1 (not set) <br/>
  /// 标签方位，范围：0-360，默认：-1（未设置）
  ///
  /// Generally only needed during special operations <br/>
  /// 一般只在进行特殊操作时才需要此字段数据
  int direction;

  /// Tag signal value, range: 0-100, default: -1 (not set) <br/>
  /// 标签信号值，范围：0-100，默认：-1（未设置）
  ///
  /// Converted from RSSI, generally only needed during special operations <br/>
  /// 由rssi转化而来，一般只在进行特殊操作时才需要此字段数据
  int value;

  /// Create a new RfidTagInfo instance <br/>
  /// 创建新的RfidTagInfo实例
  ///
  /// If timestamp is not provided, current timestamp will be used <br/>
  /// 如果未提供时间戳，将使用当前时间戳
  RfidTagInfo({
    this.reserved = '',
    required this.epc,
    this.tid = '',
    this.user = '',
    this.pc = '',
    this.rssi = '',
    this.antenna = 1,
    this.count = 1,
    this.direction = -1,
    this.value = -1,
    int? timestamp,
  }) : timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;

  /// Create a copy of this RfidTagInfo with some fields replaced <br/>
  /// 创建此RfidTagInfo的副本，替换某些字段
  RfidTagInfo copyWith({
    String? epc,
    String? tid,
    String? user,
    String? pc,
    String? rssi,
    int? antenna,
    int? count,
    int? direction,
    int? value,
    int? timestamp,
  }) {
    return RfidTagInfo(
      epc: epc ?? this.epc,
      tid: tid ?? this.tid,
      user: user ?? this.user,
      pc: pc ?? this.pc,
      rssi: rssi ?? this.rssi,
      antenna: antenna ?? this.antenna,
      count: count ?? this.count,
      direction: direction ?? this.direction,
      value: value ?? this.value,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  /// Convert to Map for serialization <br/>
  /// 转换为 Map，便于序列化
  Map<String, dynamic> toMap() {
    return {
      'epc': epc,
      'tid': tid,
      'user': user,
      'pc': pc,
      'rssi': rssi,
      'antenna': antenna,
      'count': count,
      'direction': direction,
      'value': value,
      'timestamp': timestamp,
    };
  }

  /// Create RfidTagInfo instance from Map, RfidTagInfo rfidTagInfo <br/>
  /// 从 Map 创建 RfidTagInfo 实例
  ///
  /// Returns null if [data] is null or invalid <br/>
  /// 如果 [data] 为 null 或无效则返回 null
  static RfidTagInfo? fromMap(dynamic data) {
    if (data == null) return null;

    try {
      final Map<String, dynamic> map = data is Map<String, dynamic> ? data : Map<String, dynamic>.from(data as Map);

      return RfidTagInfo(
        epc: map['epc'] as String? ?? '',
        tid: map['tid'] as String? ?? '',
        user: map['user'] as String? ?? '',
        pc: map['pc'] as String? ?? '',
        rssi: map['rssi'] as String? ?? '',
        count: map['count'] as int? ?? 1,
        antenna: map['antenna'] as int? ?? 1,
        direction: map['direction'] as int? ?? -1,
        value: map['value'] as int? ?? -1,
        timestamp: map['timestamp'] as int? ?? 0,
      );
    } catch (e) {
      print('RfidTagInfo.fromMap error: $e');
      return null;
    }
  }

  @override
  String toString() {
    final buffer = StringBuffer('RfidTagInfo{');
    buffer.write('epc: $epc');
    buffer.write(', tid: $tid');
    buffer.write(', user: $user');
    buffer.write(', pc: $pc');
    buffer.write(', rssi: $rssi');
    buffer.write(', antenna: $antenna');
    buffer.write(', count: $count');
    if (direction != -1) {
      buffer.write(', direction: $direction');
    }
    if (value != -1) {
      buffer.write(', value: $value');
    }
    buffer.write('}');
    return buffer.toString();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RfidTagInfo && other.epc == epc && other.tid == tid;
  }

  @override
  int get hashCode {
    return Object.hash(epc, tid, user);
  }
}
