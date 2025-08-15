/// Inventory parameters，reserved for future more features extension <br/>
/// 盘点参数，为将来更多功能扩展预留 <br/>
class RfidInventoryParam {
  /// Whether to filter duplicate tags, making the returned tags unique. Default is `false`. <br/>
  /// 是否过滤重复标签，使返回的标签唯一。 默认为 `false`。<br/>
  bool unique;

  RfidInventoryParam({
    this.unique = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'unique': unique,
    };
  }
}
