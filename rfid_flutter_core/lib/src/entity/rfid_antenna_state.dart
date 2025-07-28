class RfidAntennaState {
  final int antenna;
  bool? enable;
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
