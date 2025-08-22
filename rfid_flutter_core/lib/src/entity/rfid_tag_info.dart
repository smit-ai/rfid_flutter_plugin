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

  /// Tag PC value, EPC length is determined by PC <br/>
  /// 标签PC值. EPC的长度由PC决定
  String pc;

  /// Tag signal strength (RSSI), unit: dBm <br/>
  /// 标签信号值，单位: dBm <br/>
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

  /// Tag extensions for custom data storage <br/>
  /// 标签扩展字段，用于存储自定义数据 <br/>
  ///
  /// #### English
  /// This field allows users to attach custom data to tags without modifying the core API. <br/>
  /// Default is an empty map. <br/>
  ///
  /// #### 中文
  /// 此字段允许用户在不修改核心API的情况下为标签附加自定义数据。
  /// 默认为空Map。
  Map<String, dynamic> extensions;

  /// #### English
  /// Create a new RfidTagInfo instance <br/>
  /// If timestamp is not provided, current timestamp will be used <br/>
  ///
  /// #### 中文
  /// 创建新的RfidTagInfo实例
  /// 如果未提供时间戳，将使用当前时间戳 <br/>
  RfidTagInfo({
    this.reserved = '',
    required this.epc,
    this.tid = '',
    this.user = '',
    this.pc = '',
    this.rssi = '',
    this.antenna = 1,
    this.count = 1,
    int? timestamp,
    Map<String, dynamic>? extensions,
  })  : timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch,
        extensions = extensions ?? {};

  /// Create a copy of this RfidTagInfo with some fields replaced <br/>
  /// 创建此RfidTagInfo的副本，替换某些字段
  RfidTagInfo copyWith({
    String? reserved,
    String? epc,
    String? tid,
    String? user,
    String? pc,
    String? rssi,
    int? antenna,
    int? count,
    int? timestamp,
    Map<String, dynamic>? extensions,
  }) {
    return RfidTagInfo(
      reserved: reserved ?? this.reserved,
      epc: epc ?? this.epc,
      tid: tid ?? this.tid,
      user: user ?? this.user,
      pc: pc ?? this.pc,
      rssi: rssi ?? this.rssi,
      antenna: antenna ?? this.antenna,
      count: count ?? this.count,
      timestamp: timestamp ?? this.timestamp,
      extensions: extensions ?? Map<String, dynamic>.from(this.extensions),
    );
  }

  /// Convert to Map for serialization <br/>
  /// 转换为 Map，便于序列化
  Map<String, dynamic> toMap() {
    return {
      'reserved': reserved,
      'epc': epc,
      'tid': tid,
      'user': user,
      'pc': pc,
      'rssi': rssi,
      'antenna': antenna,
      'count': count,
      'timestamp': timestamp,
      'extensions': extensions,
    };
  }

  /// #### English
  /// Create RfidTagInfo instance from Map, RfidTagInfo rfidTagInfo <br/>
  /// Returns null if [data] is null or invalid
  ///
  /// #### 中文
  /// 从 Map 创建 RfidTagInfo 实例 <br/>
  /// 如果 [data] 为 null 或无效则返回 null
  static RfidTagInfo? fromMap(dynamic data) {
    if (data == null) return null;

    try {
      final Map<String, dynamic> map = data is Map<String, dynamic> ? data : Map<String, dynamic>.from(data as Map);

      return RfidTagInfo(
        reserved: map['reserved'] as String? ?? '',
        epc: map['epc'] as String? ?? '',
        tid: map['tid'] as String? ?? '',
        user: map['user'] as String? ?? '',
        pc: map['pc'] as String? ?? '',
        rssi: map['rssi'] as String? ?? '',
        count: map['count'] as int? ?? 1,
        antenna: map['antenna'] as int? ?? 1,
        timestamp: map['timestamp'] as int? ?? 0,
        extensions: map['extensions'] as Map<String, dynamic>?,
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
    if (extensions.isNotEmpty) {
      buffer.write(', extensions: $extensions');
    }
    buffer.write('}');
    return buffer.toString();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RfidTagInfo && other.reserved == reserved && other.epc == epc && other.tid == tid;
  }

  @override
  int get hashCode {
    return Object.hash(epc, tid, user);
  }
}
