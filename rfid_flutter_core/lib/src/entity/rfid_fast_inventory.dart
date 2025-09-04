class RfidFastInventory {
  static const int crClose = 0x00;
  static const int crID16 = 0x01;
  static const int crStoredCRC = 0x02;
  static const int crRN16 = 0x03;
  static const int crID32 = 0x04;

  final int cr;

  RfidFastInventory({required this.cr});

  Map<String, dynamic> toMap() {
    return {
      'cr': cr,
    };
  }

  static RfidFastInventory? fromMap(dynamic data) {
    if (data == null) return null;
    try {
      final Map<String, dynamic> map = data is Map<String, dynamic> ? data : Map<String, dynamic>.from(data as Map);

      return RfidFastInventory(
        cr: map['cr'] as int? ?? crClose,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  String toString() {
    return 'RfidFastInventory(cr: $cr)';
  }
}
