import 'package:rfid_flutter_core/rfid_flutter_core.dart';

class RfidFilter {
  bool enabled;
  int offset;
  int length;
  RfidBank bank;
  String data;

  RfidFilter({
    required this.enabled,
    this.offset = 0,
    this.length = 0,
    this.bank = RfidBank.epc,
    this.data = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'enabled': enabled,
      'offset': offset,
      'length': length,
      'bank': bank.value,
      'data': data,
    };
  }

  @override
  String toString() {
    return 'RfidFilter(enabled: $enabled, offset: $offset, length: $length, bank: $bank, data: $data)';
  }
}
