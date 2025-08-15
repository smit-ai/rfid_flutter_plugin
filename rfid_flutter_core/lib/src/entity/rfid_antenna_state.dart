/// Antenna state for RFID. <br/>
/// RFID天线状态。
class RfidAntennaState {
  /// Antenna number. <br/>
  /// 天线号
  final int antenna;

  /// Whether the antenna is enabled. <br/>
  /// 是否启用天线
  bool? enable;

  /// Power level of the antenna. <br/>
  /// 天线功率
  int? power;

  RfidAntennaState({
    required this.antenna,
    this.enable,
    this.power,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> result = {};
    result['antenna'] = antenna;
    if (enable != null) result['enable'] = enable;
    if (power != null) result['power'] = power;
    return result;
  }

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
