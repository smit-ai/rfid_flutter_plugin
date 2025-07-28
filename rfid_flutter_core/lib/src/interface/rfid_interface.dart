import 'package:rfid_flutter_core/src/entity/index.dart';

abstract class RfidInterface {
  /// #### English
  /// Initialize the RFID reader and prepare it for operations, it may take a long time. <br/>
  /// Returns a [RfidResult] where `data` is [bool], `true` if initialization succeeds, `false` otherwise. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 初始化RFID读写器并准备进行操作，注意耗时时间可能会比较长。 <br/>
  /// 返回 [RfidResult]，成功时 `data` 为 [bool]，true 表示初始化成功，false 表示初始化失败。 <br/>
  /// 失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<bool>> init();

  /// #### English
  /// Release resources and disconnect from the RFID reader. <br/>
  /// Returns a [RfidResult] where `data` is [bool], `true` if the free operation succeeds, `false` otherwise. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 释放资源并断开与RFID读写器的连接。 <br/>
  /// 返回 [RfidResult]，成功时 `data` 为 [bool]，true 表示释放成功，false 表示释放失败。 <br/>
  /// 失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<bool>> free();

  /// #### English
  /// Get the stream of RFID tag information. <br/>
  /// After calling [startInventory], the RFID tags found will be returned through this stream. <br/>
  ///
  /// #### 中文
  /// 获取RFID标签信息流。 <br/>
  /// 调用 [startInventory] 后，盘点到的RFID标签会通过该流返回。 <br/>
  Stream<List<RfidTagInfo>> get rfidTagStream;

  /// #### English
  /// Get the firmware version of the RFID reader. <br/>
  /// Returns a [RfidResult] where `data` is [String], the RFID firmware version string. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 获取RFID读写器的固件版本信息。 <br/>
  /// 返回 [RfidResult]，成功时 `data` 为 [String]，UHF固件版本字符串。失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<String>> getUhfFirmwareVersion();

  /// #### English
  /// Get the hardware version of the RFID reader. <br/>
  /// Returns a [RfidResult] where `data` is [String], the RFID hardware version string. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 获取RFID读写器的硬件版本信息。 <br/>
  /// 返回 [RfidResult]，成功时 `data` 为 [String]，UHF硬件版本字符串。失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<String>> getUhfHardwareVersion();

  /// #### English
  /// Reset the RFID reader. <br/>
  /// Returns a [RfidResult] where `data` is [bool], `true` if the reset operation succeeds, `false` otherwise. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 重置RFID读写器。 <br/>
  /// 返回 [RfidResult]，成功时 `data` 为 [bool]，true 表示重置成功，false 表示重置失败。 <br/>
  /// 失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<bool>> resetUhf();

  /// #### English
  /// Get the temperature of the RFID reader module. <br/>
  /// Returns a [RfidResult] where `data` is [int], the temperature of the RFID reader, unit: ℃. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 获取RFID读写器模块的温度。 <br/>
  /// 返回 [RfidResult]，成功时 `data` 为 [int]，单位摄氏度℃，失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<int>> getUhfTemperature();

  //                                                  111
  //     1111                                         111
  //   11111111                    11        11       111
  //  1111111111                   111       111
  //  111     11                   111       111
  //  111              11111     1111111   1111111    111     111  111          111111
  //  11111           1111111    1111111   1111111    111     111 11111       111111111
  //   111111        111   111   1111111   1111111    111     1111111111      1111111111
  //    1111111     111    111     111       111      111     1111  1111     1111    111
  //       1111     1111111111     111       111      111     111    111     111     111
  //         111    1111111111     111       111      111     111    111     111     111
  //  1      111    111            111       111      111     111    111     111     111
  //  11    1111    111    11      111       111      111     111    111     1111   1111
  //  1111111111     111  111      11111     11111    111     111    111      1111111111
  //  111111111      1111111       11111     11111    111     111    111      111111 111
  //   111111         11111         1111      1111    111     111    111       1111  111
  //                                                                                 111
  //                                                                           11    111
  //                                                                           111  1111
  //                                                                           11111111
  //                                                                            111111

  /// #### English
  /// Set the frequency parameter. <br/>
  /// Returns a [RfidResult] where `data` is [bool], `true` if set successfully, `false` if set fails. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 设置频段参数。 <br/>
  /// 返回 [RfidResult]，成功时 `data` 为 [bool]，true 表示设置成功，false 表示设置失败。 <br/>
  /// 失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<bool>> setFrequency(RfidFrequency frequency);

  /// #### English
  /// Get the frequency parameter. <br/>
  /// Returns a [RfidResult] where `data` is [RfidFrequency]. On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 获取频段参数。 <br/>
  /// 返回 [RfidResult]，成功时 `data` 为 [RfidFrequency]，失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<RfidFrequency>> getFrequency();

  /// #### English
  /// Set the power parameter, the value range is 1-30. <br/>
  /// Returns a [RfidResult] where `data` is [bool], `true` if set successfully, `false` if set fails. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 设置功率参数，可取值范围为 1-30。 <br/>
  /// 返回 [RfidResult]，成功时 `data` 为 [bool]，true 表示设置成功，false 表示设置失败。 <br/>
  /// 失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<bool>> setPower(int power);

  /// #### English
  /// Get the power parameter. <br/>
  /// Returns a [RfidResult] where `data` is [int], the power parameter value. On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 获取功率参数。 <br/>
  /// 返回 [RfidResult]，成功时 `data` 为 [int]，失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<int>> getPower();

  /// #### English
  /// Set the RFLink parameter. <br/>
  /// Returns a [RfidResult] where `data` is [bool], `true` if set successfully, `false` if set fails. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 设置RFLink参数。 <br/>
  /// 返回 [RfidResult]，成功时 `data` 为 [bool]，true 表示设置成功，false 表示设置失败。 <br/>
  /// 失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<bool>> setRfLink(RfidRfLink rfLink);

  /// #### English
  /// Get the RFID RFLink parameter value. <br/>
  /// Returns a [RfidResult] where `data` is [RfidRfLink], the RFLink parameter value. On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 获取RFLink参数。 <br/>
  /// 返回 [RfidResult]，成功时 `data` 为 [RfidRfLink]，失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<RfidRfLink>> getRfLink();

  /// #### English
  /// Set the RFID inventory mode parameter value. <br/>
  /// Returns a [RfidResult] where `data` is [bool], `true` if set successfully, `false` if set fails. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 设置盘点模式参数 <br/>
  /// 返回 [RfidResult]，成功时 `data` 为 [bool]，true 表示设置成功，false 表示设置失败。 <br/>
  /// 失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<bool>> setInventoryMode(RfidInventoryMode inventoryMode);

  /// #### English
  /// Get the RFID inventory mode parameter value. <br/>
  /// Returns a [RfidResult] where `data` is [RfidInventoryMode], the inventory mode parameter value. On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 获取盘点模式参数。 <br/>
  /// 返回 [RfidResult]，成功时 `data` 为 [RfidInventoryMode]，失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<RfidInventoryMode>> getInventoryMode();

  /// #### English
  /// Set the Gen2 parameter. <br/>
  /// Only the properties provided in the input [gen2] will be set; other Gen2 parameters will remain unchanged. <br/>
  /// Returns a [RfidResult] where `data` is [bool], `true` if set successfully, `false` if set fails. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 设置Gen2参数。 <br/>
  /// 仅会设置传入的 [gen2] 属性参数，不会影响其他参数。 <br/>
  /// 返回 [RfidResult]，成功时 `data` 为 [bool]，true 表示设置成功，false 表示设置失败。 <br/>
  /// 失败时 `error` 包含错误描述信息。 <br/>
  ///
  /// #### Example
  /// ```dart
  /// final gen2 = RfidGen2(
  ///   querySession: RfidGen2.querySessionS0,
  ///   queryTarget: RfidGen2.queryTargetA
  /// );
  /// final result = await RfidWithUart.instance.setGen2(gen2);
  /// ```
  Future<RfidResult<bool>> setGen2(RfidGen2 gen2);

  /// #### English
  /// Get the Gen2 parameter. <br/>
  /// Returns a [RfidResult] where `data` is [RfidGen2], the Gen2 parameter value. On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 获取Gen2参数。 <br/>
  /// 返回 [RfidResult]，成功时 `data` 为 [RfidGen2]，失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<RfidGen2>> getGen2();

  /// #### English
  /// Set the `FastInventory` parameter. <br/>
  /// Returns a [RfidResult] where `data` is [bool], `true` if set successfully, `false` if set fails. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 设置快速盘点模式。 true: 开启，false: 关闭 <br/>
  /// 返回 [RfidResult]，成功时 `data` 为 [bool]，true 表示设置成功，false 表示设置失败。 <br/>
  /// 失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<bool>> setFastInventory(bool fastInventory);

  /// #### English
  /// Get the `FastInventory` parameter. <br/>
  /// Returns a [RfidResult] where `data` is [bool], `true` if get successfully, `false` if get fails. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 获取快`FastInventory`参数 <br/>
  /// 返回 [RfidResult]，成功时 `data` 为 [bool]，true 表示获取成功，false 表示获取失败。 <br/>
  /// 失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<bool>> getFastInventory();

  /// #### English
  /// Set the `TagFocus` parameter. <br/>
  /// Returns a [RfidResult] where `data` is [bool], `true` if set successfully, `false` if set fails. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 设置`TagFocus`参数。 true: 开启，false: 关闭 <br/>
  /// 返回 [RfidResult]，成功时 `data` 为 [bool]，true 表示设置成功，false 表示设置失败。 <br/>
  /// 失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<bool>> setTagFocus(bool tagFocus);

  /// #### English
  /// Get the `TagFocus` parameter. <br/>
  /// Returns a [RfidResult] where `data` is [bool], `true` if get successfully, `false` if get fails. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 获取`TagFocus`参数。 <br/>
  /// 返回 [RfidResult]，成功时 `data` 为 [bool]，true 表示获取成功，false 表示获取失败。 <br/>
  /// 失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<bool>> getTagFocus();

  /// #### English
  /// Set the `FastId` parameter. <br/>
  /// Returns a [RfidResult] where `data` is [bool], `true` if set successfully, `false` if set fails. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 设置`FastId`参数。 true: 开启，false: 关闭 <br/>
  /// 返回 [RfidResult]，成功时 `data` 为 [bool]，true 表示设置成功，false 表示设置失败。 <br/>
  /// 失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<bool>> setFastId(bool fastId);

  /// #### English
  /// Get the `FastId` parameter. <br/>
  /// Returns a [RfidResult] where `data` is [bool], `true` if get successfully, `false` if get fails. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 获取`FastId`参数。 <br/>
  /// 返回 [RfidResult]，成功时 `data` 为 [bool]，true 表示获取成功，false 表示获取失败。 <br/>
  /// 失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<bool>> getFastId();

  //  11    111    11    111    111111111
  //  11    111    11    111    111111111
  //  11    111    11    111    111
  //  11    111    11    111    111
  //  11    111    11    111    111
  //  11    111    11    111    111
  //  11    111    111111111    111111111
  //  11    111    111111111    111111111
  //  11    111    11    111    111
  //  11    111    11    111    111
  //  11    111    11    111    111
  //  111   111    11    111    111
  //  11111111     11    111    111
  //   1111111     11    111    111
  //    1111       11    111    111

  /// #### English
  /// Set the `Filter` parameter. <br/>
  /// Returns a [RfidResult] where `data` is [bool], `true` if set successfully, `false` if set fails. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 设置盘点过滤参数。 <br/>
  /// 返回 [RfidResult]，成功时 `data` 为 [bool]，true 表示设置成功，false 表示设置失败。 <br/>
  ///
  /// #### Example
  ///
  /// 取消过滤
  ///
  /// ```dart
  /// final filter = RfidFilter(
  ///   enabled: false,
  /// );
  /// final result = await RfidWithUart.instance.setFilter(filter);
  /// ```
  ///
  /// ----
  ///
  /// Filter tags whose EPC data starts with 1111 (EPC: **1111**22223333) <br/>
  /// 过滤EPC数据以 1111开头的标签（EPC: **1111**22223333）
  ///
  /// ```dart
  /// final filter = RfidFilter(
  ///   enabled: true,
  ///   bank: RfidBank.epc,
  ///   enabled: true,
  ///   offset: 32,
  ///   length: 16,
  ///   data: '1111',
  /// );
  /// final result = await RfidWithUart.instance.setFilter(filter);
  /// ```
  ///
  /// ----
  ///
  /// Filter tags whose TID data 16\~48 bit is 22223333 (TID: 1111**22223333**4444) <br/>
  /// 过滤TID数据 第16\~48 bit 为 22223333的标签（TID: 1111**22223333**4444）
  ///
  /// ```dart
  /// final filter = RfidFilter(
  ///   enabled: true,
  ///   bank: RfidBank.tid,
  ///   offset: 16,
  ///   length: 32,
  ///   data: '22223333',
  /// );
  /// final result = await RfidWithUart.instance.setFilter(filter);
  /// ```
  Future<RfidResult<bool>> setFilter(RfidFilter filter);

  /// #### English
  /// Single step inventory, only inventory one tag <br/>
  /// Returns a [RfidResult] where `data` is [RfidTagInfo], the tag information. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 单步盘点，只盘点一张标签 <br/>
  /// 返回 [RfidResult]，成功时 `data` 为 [RfidTagInfo] 标签信息，失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<RfidTagInfo>> singleInventory({RfidFilter? filter});

  /// #### English
  /// Start inventory. <br/>
  /// [filter] Optional filter parameters, if empty, it means not to set the filter (note that it is not to cancel the filter) <br/>
  /// [inventoryParam] Optional inventory parameters, if empty, it means not to set the inventory parameters, using the default parameters. <br/>
  /// Returns a [RfidResult] where `data` is [bool], `true` if the inventory starts successfully, `false` if the inventory fails. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 开始盘点。 <br/>
  /// [filter] 可选过滤参数，为空时表示不设置过滤（注意不是取消过滤） <br/>
  /// [inventoryParam] 可选盘点参数，为空时表示不设置盘点参数，采用默认参数。 <br/>
  /// 返回 [RfidResult]，成功时 `data` 为 [bool]，true 表示开始盘点成功，false 表示开始盘点失败。 <br/>
  /// 失败时 `error` 包含错误描述信息。 <br/>
  ///
  /// #### Example
  ///
  /// No filter, no inventoryParam, use default parameters. <br/>
  /// 不设置过滤，不设置盘点参数，采用默认参数。
  /// ```dart
  /// final result = await RfidWithUart.instance.startInventory();
  /// ```
  ///
  /// ----
  ///
  /// Set filter, no inventoryParam, use default parameters. <br/>
  /// 过滤EPC数据以 1111开头的标签（EPC: **1111**22223333）
  /// ```dart
  /// final filter = RfidFilter(
  ///   enabled: true,
  ///   bank: RfidBank.epc,
  ///   offset: 32,
  ///   length: 16,
  ///   data: '1111',
  /// );
  /// final result = await RfidWithUart.instance.startInventory(filter: filter);
  /// ```
  ///
  /// It's equivalent to: <br/>
  /// 等价于:
  /// ```dart
  /// final filter = RfidFilter(
  ///   enabled: true,
  ///   bank: RfidBank.epc,
  ///   offset: 32,
  ///   length: 16,
  ///   data: '1111',
  /// );
  /// final result = await RfidWithUart.instance.setFilter(filter);
  /// final result = await RfidWithUart.instance.startInventory();
  /// ```
  ///
  /// ----
  ///
  /// Ensure cancel all filters, then start inventory. <br/>
  /// 确保取消所有过滤，然后开启盘点。
  /// ```dart
  /// final filter = RfidFilter(
  ///   enabled: false,
  /// );
  /// final result = await RfidWithUart.instance.startInventory(filter: filter);
  /// ```
  Future<RfidResult<bool>> startInventory({
    RfidFilter? filter,
    RfidInventoryParam? inventoryParam,
  });

  /// #### English
  /// Stop inventory. <br/>
  /// Returns a [RfidResult] where `data` is [bool], `true` if the inventory stops successfully, `false` if the inventory stops fails. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 停止盘点。 <br/>
  /// 返回 [RfidResult]，成功时 `data` 为 [bool]，true 表示停止盘点成功，false 表示停止盘点失败。 <br/>
  /// 失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<bool>> stopInventory();

  /// #### English
  /// Read tag data.
  ///
  /// [filter]   Filter parameters, if empty, it means not to specify the tag (note that it is not to cancel the filter) <br/>
  /// [bank]     Read data area <br/>
  /// [offset]   Read start position <br/>
  /// [length]   Read data length <br/>
  /// [password] Read tag password <br/>
  ///
  /// Returns a [RfidResult] where `data` is [String], the tag data. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 读取标签数据
  ///
  /// [filter]   过滤参数，为空时表示不指定标签（注意不是取消过滤） <br/>
  /// [bank]     读取的数据区域 <br/>
  /// [offset]   读取的起始位置 <br/>
  /// [length]   读取的数据长度 <br/>
  /// [password] 读取的标签密码 <br/>
  ///
  /// 返回 [RfidResult]，成功时 `data` 为 [String] 标签数据，失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<String>> readData({
    RfidFilter? filter = null,
    required RfidBank bank,
    required int offset,
    required int length,
    required String password,
  });

  /// #### English
  /// Write tag data.
  ///
  /// [filter]    Filter parameters, if empty, it means not to specify the tag (note that it is not to cancel the filter) <br/>
  /// [bank]      Write data area <br/>
  /// [offset]    Write start position <br/>
  /// [length]    Write data length <br/>
  /// [password]  Write tag password <br/>
  /// [data]      Write data <br/>
  ///
  /// Returns a [RfidResult] where `data` is [bool], `true` if the write operation succeeds, `false` otherwise. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 写入标签数据
  ///
  /// [filter]    过滤参数，为空时表示不指定标签（注意不是取消过滤） <br/>
  /// [bank]      写入的数据区域 <br/>
  /// [offset]    写入的起始位置 <br/>
  /// [length]    写入的数据长度 <br/>
  /// [password]  写入的标签密码（如果标签有密码） <br/>
  /// [data]      写入的数据 <br/>
  ///
  /// 返回 [RfidResult]，成功时 `data` 为 [bool]，true 表示写入成功，false 表示写入失败。 <br/>
  /// 失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<bool>> writeData({
    RfidFilter? filter = null,
    required RfidBank bank,
    required int offset,
    required int length,
    required String password,
    required String data,
  });

  /// #### English
  /// Lock tag.
  ///
  /// [filter]    Filter parameters, if empty, it means not to specify the tag <br/>
  /// [password]  Tag access password <br/>
  /// [lockBanks] Lock tag banks <br/>
  /// [lockMode]  Lock tag operation mode <br/>
  ///
  /// Returns a [RfidResult] where `data` is [bool], `true` if the lock operation succeeds, `false` otherwise. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 锁定标签
  ///
  /// [filter]    过滤参数，为空时表示不指定标签 <br/>
  /// [password]  标签访问密码 <br/>
  /// [lockBanks] 需要操作的标签区域列表 <br/>
  /// [lockMode]  标签操作模式 <br/>
  ///
  /// 返回 [RfidResult]，成功时 `data` 为 [bool]，true 表示锁定成功，false 表示锁定失败。 <br/>
  /// 失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<bool>> lockTag({
    RfidFilter? filter = null,
    required String password,
    required List<RfidLockBank> lockBanks,
    required RfidLockMode lockMode,
  });

  /// #### English
  /// Kill tag.
  ///
  /// [filter]    Filter parameters, if empty, it means not to specify the tag <br/>
  /// [password]  Kill tag password <br/>
  ///
  /// Returns a [RfidResult] where `data` is [bool], `true` if the kill operation succeeds, `false` otherwise. <br/>
  /// On failure, `error` contains the error description. <br/>
  ///
  /// #### 中文
  /// 销毁标签
  ///
  /// [filter]   过滤参数，为空时表示不指定标签 <br/>
  /// [password] 标签销毁密码 <br/>
  ///
  /// 返回 [RfidResult]，成功时 `data` 为 [bool]，true 表示销毁成功，false 表示销毁失败。 <br/>
  /// 失败时 `error` 包含错误描述信息。 <br/>
  Future<RfidResult<bool>> killTag({
    RfidFilter? filter = null,
    required String password,
  });
}
