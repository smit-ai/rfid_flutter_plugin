/// Gen2 parameters. <br/>
/// Gen2参数 <br/>
///
/// #### Note:
/// For specific meanings of each parameter, please refer to the document《超高频 RFID 应用层通信协议》 <br/>
/// 各参数具体含义请参考文档《超高频 RFID 应用层通信协议》
class RfidGen2 {
  // RFID Select Target values / RFID Select Target 值
  static const int selectTargetS0 = 0x00;
  static const int selectTargetS1 = 0x01;
  static const int selectTargetS2 = 0x02;
  static const int selectTargetS3 = 0x03;
  static const int selectTargetSL = 0x04;

  // RFID Select Truncate values / RFID Select Truncate 值
  /// Disable truncation / 禁用截断
  static const int selectTruncateDisable = 0x00;

  /// Enable truncation / 启用截断
  static const int selectTruncateEnable = 0x01;

  // RFID Q algorithm values / RFID Q 算法值
  /// Static Q algorithm / 静态Q算法
  static const int qStatic = 0x00;

  /// Dynamic Q algorithm / 动态Q算法
  static const int qDynamic = 0x01;

  // RFID Query DR values
  static const int queryDR_8 = 0x00;
  static const int queryDR_64_3 = 0x01;

  // RFID Query M values
  static const int queryM_FM0 = 0x00;
  static const int queryM_Miller2 = 0x01;
  static const int queryM_Miller4 = 0x02;
  static const int queryM_Miller8 = 0x03;

  // RFID Query TRext values
  /// NoPilot / 无导频
  static const int queryTRextNoPilot = 0x00;

  /// UsePilot / 使用导频
  static const int queryTRextUsePilot = 0x01;

  // RFID Query Sel values
  /// All / 全部
  static const int querySelAll = 0x00;

  /// All2 / 全部2
  static const int querySelAll2 = 0x01;

  /// NotSL / 非SL
  static const int querySelNotSL = 0x02;

  /// SL
  static const int querySelSL = 0x03;

  // RFID Query Session values
  static const int querySessionS0 = 0x00;
  static const int querySessionS1 = 0x01;
  static const int querySessionS2 = 0x02;
  static const int querySessionS3 = 0x03;

  // RFID Query Target values
  static const int queryTargetA = 0x00;
  static const int queryTargetB = 0x01;

  /// Select command Target setting. Default value is S0 <br/>
  /// Select 命令的 Target 设置。默认值为 S0
  int? selectTarget;

  /// Select command Action parameter, range: 0 ~ 7 <br/>
  /// Select 命令的 Action 参数，可取范围：0 ~ 7
  int? selectAction;

  /// Select command Truncate setting. Default value is Disable <br/>
  /// Select 命令的 Truncate 设置。默认值为 Disable
  int? selectTruncate;

  /// Q setting. Default value is Static <br/>
  /// Note: In fixed Q algorithm, Q is fixed to StartQ, ignoring MinQ and MaxQ <br/>
  /// Q 设置。默认值为 Static <br/>
  /// 注意：在固定 Q 算法下，Q 固定为 StartQ，忽略 MinQ 和 MaxQ
  int? q;

  /// StartQ setting, range: 0 ~ 15 <br/>
  /// StartQ 设置，可取范围：0 ~ 15
  int? startQ;

  /// MinQ setting, range: 0 ~ 15 <br/>
  /// MinQ 设置，可取范围：0 ~ 15
  int? minQ;

  /// MaxQ setting, range: 0 ~ 15 <br/>
  /// MaxQ 设置，可取范围：0 ~ 15
  int? maxQ;

  /// Query command DR parameter, default value is DR_8 <br/>
  /// Query 命令的 DR 参数，默认值为 DR_8
  int? queryDR;

  /// Query command M parameter, default value is FM0 <br/>
  /// Query 命令的 M 参数，默认值为 FM0
  int? queryM;

  /// Query command TRext parameter, default value is NoPilot <br/>
  /// Query 命令的 TRext 参数，默认值为 NoPilot
  int? queryTRext;

  /// Query command sel parameter, default value is All <br/>
  /// Query 命令的 sel 参数，默认值为 All
  int? querySel;

  /// Query command session parameter, default value is S0 <br/>
  /// Query 命令的 session 参数，默认值为 S0
  int? querySession;

  /// Query command Target parameter, default value is A <br/>
  /// Query 命令的 Target 参数，默认值为 A
  int? queryTarget;

  /// Link Frequency setting (reserved), range: 0 ~ 7 <br/>
  /// Link Frequency 设置（预留），可取范围：0 ~ 7
  int? linkFrequency;

  /// Constructor to initialize RFIDGen2 parameters
  /// 构造函数，初始化 RFIDGen2 参数
  RfidGen2({
    this.selectTarget,
    this.selectAction,
    this.selectTruncate,
    this.q,
    this.startQ,
    this.minQ,
    this.maxQ,
    this.queryDR,
    this.queryM,
    this.queryTRext,
    this.querySel,
    this.querySession,
    this.queryTarget,
    this.linkFrequency,
  });

  /// Convert to Map for serialization <br/>
  /// 转换为 Map，便于序列化
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> result = {};

    if (selectTarget != null) result['selectTarget'] = selectTarget;
    if (selectAction != null) result['selectAction'] = selectAction;
    if (selectTruncate != null) result['selectTruncate'] = selectTruncate;
    if (q != null) result['q'] = q;
    if (startQ != null) result['startQ'] = startQ;
    if (minQ != null) result['minQ'] = minQ;
    if (maxQ != null) result['maxQ'] = maxQ;
    if (queryDR != null) result['queryDR'] = queryDR;
    if (queryM != null) result['queryM'] = queryM;
    if (queryTRext != null) result['queryTRext'] = queryTRext;
    if (querySel != null) result['querySel'] = querySel;
    if (querySession != null) result['querySession'] = querySession;
    if (queryTarget != null) result['queryTarget'] = queryTarget;
    if (linkFrequency != null) result['linkFrequency'] = linkFrequency;

    return result;
  }

  /// Create RFIDGen2 instance from Map <br/>
  /// 从 Map 创建 RFIDGen2 实例
  ///
  /// Returns null if [data] is null or invalid <br/>
  /// 如果 [data] 为 null 或无效则返回 null
  static RfidGen2? fromMap(dynamic data) {
    if (data == null) return null;

    try {
      final Map<String, dynamic> map = data is Map<String, dynamic> ? data : Map<String, dynamic>.from(data as Map);

      return RfidGen2(
        selectTarget: map['selectTarget'],
        selectAction: map['selectAction'],
        selectTruncate: map['selectTruncate'],
        q: map['q'],
        startQ: map['startQ'],
        minQ: map['minQ'],
        maxQ: map['maxQ'],
        queryDR: map['queryDR'],
        queryM: map['queryM'],
        queryTRext: map['queryTRext'],
        querySel: map['querySel'],
        querySession: map['querySession'],
        queryTarget: map['queryTarget'],
        linkFrequency: map['linkFrequency'],
      );
    } catch (e) {
      return null;
    }
  }

  @override
  String toString() {
    return 'RFIDGen2(selectTarget: $selectTarget, selectAction: $selectAction, '
        'selectTruncate: $selectTruncate, q: $q, startQ: $startQ, '
        'minQ: $minQ, maxQ: $maxQ, queryDR: $queryDR, queryM: $queryM, '
        'queryTRext: $queryTRext, querySel: $querySel, '
        'querySession: $querySession, queryTarget: $queryTarget, '
        'linkFrequency: $linkFrequency)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RfidGen2 &&
        other.selectTarget == selectTarget &&
        other.selectAction == selectAction &&
        other.selectTruncate == selectTruncate &&
        other.q == q &&
        other.startQ == startQ &&
        other.minQ == minQ &&
        other.maxQ == maxQ &&
        other.queryDR == queryDR &&
        other.queryM == queryM &&
        other.queryTRext == queryTRext &&
        other.querySel == querySel &&
        other.querySession == querySession &&
        other.queryTarget == queryTarget &&
        other.linkFrequency == linkFrequency;
  }

  @override
  int get hashCode {
    return Object.hash(
      selectTarget,
      selectAction,
      selectTruncate,
      q,
      startQ,
      minQ,
      maxQ,
      queryDR,
      queryM,
      queryTRext,
      querySel,
      querySession,
      queryTarget,
      linkFrequency,
    );
  }
}
