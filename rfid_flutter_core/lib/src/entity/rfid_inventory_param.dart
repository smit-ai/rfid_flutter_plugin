/// #### English
/// Inventory parameters <br/>
/// Reserved for future more features extension <br/>
///
/// #### 中文
/// 盘点参数 <br/>
/// 为将来更多功能扩展预留 <br/>
class RfidInventoryParam {
  /// #### English
  /// Whether to filter duplicate tags, making the returned tags unique. Default is `false`. <br/>
  ///
  /// #### 中文
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
