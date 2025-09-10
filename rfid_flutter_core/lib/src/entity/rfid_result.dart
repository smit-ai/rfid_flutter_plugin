/// A generic class that represents the result of a command execution <br/>
/// 一个通用的类，表示命令执行的结果 <br/>
class RfidResult<T> {
  /// #### English
  /// Whether the command execution is successful. <br/>
  /// If `true`, it means the command execution is successful, and [data] is the return data of the command execution. <br/>
  /// If `false`, it means the command execution failed, and [error] is the error description. <br/>
  ///
  /// #### 中文
  /// 命令执行是否成功。 <br/>
  /// 若为 `true`，则表示命令执行成功，此时 [data] 为命令执行返回数据。 <br/>
  /// 若为 `false`，则表示命令执行失败，此时 [error] 为错误描述。 <br/>
  final bool result;

  /// #### English
  /// The result of the command execution. Only valid when [result] is `true`. <br/>
  ///
  /// #### 中文
  /// 命令执行返回数据。只在 [result] 为 `true` 时有效。 <br/>
  final T? data;

  /// ### English
  /// The error description. Only valid when [result] is `false`. <br/>
  ///
  /// ### 中文
  /// 错误描述。只在 [result] 为 `false` 时有效。 <br/>
  final String? error;

  const RfidResult.success(this.data)
      : result = true,
        error = null;

  const RfidResult.failure(this.error)
      : result = false,
        data = null;

  /// #### English
  /// Whether the command execution is successful and the returned data is also `true`. <br/>
  /// This is useful for operations where you only care about whether the action was effective, <br/>
  /// such as setting parameters where success means both execution succeeded and the setting took effect. <br/>
  ///
  /// #### 中文
  /// 命令执行结果[result]为 `true` 且返回数据[data]也为 `true`。 <br/>
  /// 这对于只关心操作是否生效的场景很有用，<br/>
  /// 比如设置参数时，成功意味着执行成功且设置已生效。 <br/>
  bool get isEffective => result && data == true;

  /// #### English
  /// Whether the command execution failed or the returned data is `false`. <br/>
  /// This is the opposite of [isEffective], useful for checking if an operation did not take effect. <br/>
  ///
  /// #### 中文
  /// 命令执行结果[result]为 `false` 或返回数据[data]为 `false`。 <br/>
  /// 这是 [isEffective] 的反义词，用于检查操作是否未生效。 <br/>
  bool get isIneffective => !isEffective;

  @override
  String toString() {
    return 'RfidResult(result: $result, data: $data, error: $error)';
  }
}
