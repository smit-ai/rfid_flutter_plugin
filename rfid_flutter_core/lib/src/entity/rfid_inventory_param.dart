/// Inventory parameters，reserved for future more features extension <br/>
/// 盘点参数，为将来更多功能扩展预留 <br/>
class RfidInventoryParam {
  /// Whether to filter duplicate tags, making the returned tags unique. Default is `false` <br/>
  /// 是否过滤重复标签，使返回的标签唯一。 默认为 `false` <br/>
  bool unique;

  /// Constructor to initialize RfidInventoryParam parameters <br/>
  /// 构造函数，初始化 RfidInventoryParam 参数
  RfidInventoryParam({
    this.unique = false,
  });

  /// Convert to Map for serialization <br/>
  /// 转换为 Map，便于序列化
  Map<String, dynamic> toMap() {
    return {
      'unique': unique,
    };
  }

  /// Create RfidInventoryParam instance from Map <br/>
  /// 从 Map 创建 RfidInventoryParam 实例
  ///
  /// Returns null if [data] is null or invalid <br/>
  /// 如果 [data] 为 null 或无效则返回 null
  static RfidInventoryParam? fromMap(dynamic data) {
    if (data == null) return null;

    try {
      final Map<String, dynamic> map = data is Map<String, dynamic> ? data : Map<String, dynamic>.from(data as Map);

      return RfidInventoryParam(
        unique: map['unique'] as bool? ?? false,
      );
    } catch (e) {
      return null;
    }
  }
}
