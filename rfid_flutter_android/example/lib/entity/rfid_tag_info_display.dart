import 'package:rfid_flutter_android/rfid_flutter_android.dart';

/// Extension for RfidTagInfo to add display text functionality
/// 为 RfidTagInfo 添加显示文本功能的扩展
extension RfidTagInfoDisplay on RfidTagInfo {
  String get displayText {
    // Get cached display text from extensions
    // 从 extensions 中获取缓存
    final cached = extensions['displayText'] as String?;
    if (cached != null) return cached;

    // If not cached, build and cache to extensions
    // 缓存中没有，则计算并缓存到 extensions
    final result = buildDisplayText();
    extensions['displayText'] = result;
    return result;
  }

  ///  Build display text
  /// 构建显示文本
  String buildDisplayText() {
    final buffer = StringBuffer();

    if (reserved.isNotEmpty) {
      buffer.write('RESERVED: $reserved\n');
    }

    if (tid.isEmpty && reserved.isEmpty) {
      buffer.write(epc);
    } else {
      buffer.write('EPC: $epc');
    }

    if (tid.isNotEmpty) {
      buffer.write('\nTID: $tid');
    }

    if (user.isNotEmpty) {
      buffer.write('\nUSER: $user');
    }

    return buffer.toString();
  }
}
