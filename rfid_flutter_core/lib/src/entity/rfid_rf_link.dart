/// RFLink combinations for RFID <br/>
/// RF链路组合 <br/>
///
/// #### Note:
/// Gen2X links require UHF firmware version V7.1.8+ <br/>
/// Gen2X链路需要UHF固件版本V7.1.8+
enum RfidRfLink {
  /// 0x00: PR_ASK/Miller8/160KHz
  prAskMiller8_160KHz(0x00),

  /// 0x01: PR_ASK/Miller4/250KHz
  prAskMiller4_250KHz(0x01),

  /// 0x02: PR_ASK/Miller4/320KHz
  prAskMiller4_320KHz(0x02),

  /// 0x03: PR_ASK/Miller4/640KHz
  prAskMiller4_640KHz(0x03),

  /// 0x04: PR_ASK/Miller2/320KHz
  prAskMiller2_320KHz(0x04),

  /// 0x05: PR_ASK/Miller2/640KHz
  prAskMiller2_640KHz(0x05),

  /// 0x0A: Gen2X/Miller8/160KHz
  gen2xMiller8_160KHz(0x0A),

  /// 0x0B: Gen2X/Miller4/250KHz
  gen2xMiller4_250KHz(0x0B),

  /// 0x0C: Gen2X/Miller4/320KHz
  gen2xMiller4_320KHz(0x0C),

  /// 0x0D: Gen2X/Miller4/640KHz
  gen2xMiller4_640KHz(0x0D),

  /// 0x0E: Gen2X/Miller2/320KHz
  gen2xMiller2_320KHz(0x0E),

  /// 0x0F: Gen2X/Miller2/640KHz
  gen2xMiller2_640KHz(0x0F);

  const RfidRfLink(this.value);

  /// The numeric value of the RF link <br/>
  /// RF链路的数值
  final int value;

  /// Get RF link description <br/>
  /// 获取RF链路描述
  String get description {
    switch (this) {
      case prAskMiller8_160KHz:
        return 'PR_ASK/Miller8/160KHz';
      case prAskMiller4_250KHz:
        return 'PR_ASK/Miller4/250KHz';
      case prAskMiller4_320KHz:
        return 'PR_ASK/Miller4/320KHz';
      case prAskMiller4_640KHz:
        return 'PR_ASK/Miller4/640KHz';
      case prAskMiller2_320KHz:
        return 'PR_ASK/Miller2/320KHz';
      case prAskMiller2_640KHz:
        return 'PR_ASK/Miller2/640KHz';
      case gen2xMiller8_160KHz:
        return 'Gen2X/Miller8/160KHz';
      case gen2xMiller4_250KHz:
        return 'Gen2X/Miller4/250KHz';
      case gen2xMiller4_320KHz:
        return 'Gen2X/Miller4/320KHz';
      case gen2xMiller4_640KHz:
        return 'Gen2X/Miller4/640KHz';
      case gen2xMiller2_320KHz:
        return 'Gen2X/Miller2/320KHz';
      case gen2xMiller2_640KHz:
        return 'Gen2X/Miller2/640KHz';
    }
  }

  /// Find RF link by value <br/>
  /// 根据值查找RF链路
  static RfidRfLink? fromValue(int value) {
    for (RfidRfLink rfLink in RfidRfLink.values) {
      if (rfLink.value == value) {
        return rfLink;
      }
    }
    return null;
  }
}
