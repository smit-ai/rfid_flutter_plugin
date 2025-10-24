/// Antenna state for RFID <br/>
/// RFID天线状态
class RfidAntennaState {
  /// Antenna number. <br/>
  /// 天线号
  final int antenna;

  /// Whether the antenna is enabled <br/>
  /// 是否启用天线
  bool? enable;

  /// Power level of the antenna <br/>
  /// 天线功率
  int? power;

  /// Constructor to initialize RfidAntennaState parameters <br/>
  /// 构造函数，初始化 RfidAntennaState 参数
  RfidAntennaState({
    required this.antenna,
    this.enable,
    this.power,
  });

  /// Convert to Map for serialization <br/>
  /// 转换为 Map，便于序列化
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> result = {};
    result['antenna'] = antenna;
    if (enable != null) result['enable'] = enable;
    if (power != null) result['power'] = power;
    return result;
  }

  /// Create RfidAntennaState instance from Map <br/>
  /// 从 Map 创建 RfidAntennaState 实例
  ///
  /// Returns null if [data] is null or invalid <br/>
  /// 如果 [data] 为 null 或无效则返回 null
  static RfidAntennaState? fromMap(dynamic data) {
    if (data == null) return null;

    try {
      final Map<String, dynamic> map = data is Map<String, dynamic> ? data : Map<String, dynamic>.from(data as Map);

      return RfidAntennaState(
        antenna: map['antenna'],
        enable: map['enable'],
        power: map['power'],
      );
    } catch (e) {
      return null;
    }
  }

  @override
  String toString() {
    return 'RfidAntennaState(antenna: $antenna, enable: $enable, power: $power)';
  }
}
