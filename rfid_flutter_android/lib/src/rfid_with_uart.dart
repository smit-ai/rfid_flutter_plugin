import 'dart:async';

import 'package:flutter/services.dart';
import 'package:rfid_flutter_core/rfid_flutter_core.dart';
import 'package:rfid_flutter_android/src/method_channel_helper.dart';

class RfidWithUart implements RfidInterface {
  static RfidWithUart? _instance;

  static RfidWithUart get instance {
    _instance ??= RfidWithUart._();
    return _instance!;
  }

  late final MethodChannel _channel;
  late final MethodChannelHelper _methodChannelHelper;

  late final StreamController<List<RfidTagInfo>> _tagStreamController;
  RfidInventoryParam? _inventoryParam;
  final List<RfidTagInfo> _tagList = [];

  // Private constructor for singleton
  RfidWithUart._() {
    _channel = const MethodChannel('rfid_flutter_android/uart');
    _methodChannelHelper = MethodChannelHelper(_channel);

    _tagStreamController = StreamController<List<RfidTagInfo>>();

    const eventChannel = EventChannel('rfid_flutter_android/uartEvent');
    eventChannel.receiveBroadcastStream().listen((event) {
      if (event['type'] == 'RFID_TAG') {
        final tagInfo = RfidTagInfo.fromMap(event);
        //print('tagInfo: $tagInfo');
        if (tagInfo == null) return;

        if (_inventoryParam?.unique ?? false) {
          // filter duplicate tags
          final result = RfidTagUtil.getTagIndex(_tagList, tagInfo);
          if (result['exist'] != true) {
            _tagList.insert(result['index'], tagInfo);
            _tagStreamController.add([tagInfo]);
          }
        } else {
          // return all tags
          _tagStreamController.add([tagInfo]);
        }
      }
    });
  }

  @override
  Stream<List<RfidTagInfo>> get rfidTagStream => _tagStreamController.stream;

  @override
  Future<RfidResult<bool>> init() async {
    return _methodChannelHelper.invokeBoolMethod('init');
  }

  @override
  Future<RfidResult<bool>> free() async {
    return _methodChannelHelper.invokeBoolMethod('free');
  }

  @override
  Future<RfidResult<String>> getUhfFirmwareVersion() async {
    return _methodChannelHelper.invokeStringMethod('getUhfFirmwareVersion');
  }

  @override
  Future<RfidResult<String>> getUhfHardwareVersion() async {
    return _methodChannelHelper.invokeStringMethod('getUhfHardwareVersion');
  }

  @override
  Future<RfidResult<int>> getUhfTemperature() async {
    return _methodChannelHelper.invokeIntMethod('getUhfTemperature');
  }

  @override
  Future<RfidResult<bool>> resetUhf() async {
    return _methodChannelHelper.invokeBoolMethod('resetUhf');
  }

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
  //                                                                           11   1111
  //                                                                           111  1111
  //                                                                           11111111
  //                                                                            111111

  @override
  Future<RfidResult<RfidFrequency>> getFrequency() async {
    return _methodChannelHelper.invokeObjectMethod<RfidFrequency>(
      'getFrequency',
      (result) => RfidFrequency.fromValue(result ?? -1),
    );
  }

  @override
  Future<RfidResult<bool>> setFrequency(RfidFrequency frequency) async {
    return _methodChannelHelper.invokeBoolMethod(
      'setFrequency',
      {'value': frequency.value},
    );
  }

  @override
  Future<RfidResult<int>> getPower() async {
    return _methodChannelHelper.invokeIntMethod('getPower');
  }

  @override
  Future<RfidResult<bool>> setPower(int power) async {
    return _methodChannelHelper.invokeBoolMethod(
      'setPower',
      {'value': power},
    );
  }

  @override
  Future<RfidResult<bool>> setRfLink(RfidRfLink rfLink) async {
    return _methodChannelHelper.invokeBoolMethod(
      'setRfLink',
      {'value': rfLink.value},
    );
  }

  @override
  Future<RfidResult<RfidRfLink>> getRfLink() async {
    return _methodChannelHelper.invokeObjectMethod<RfidRfLink>(
      'getRfLink',
      (result) => RfidRfLink.fromValue(result ?? 0),
    );
  }

  @override
  Future<RfidResult<bool>> setInventoryMode(RfidInventoryMode inventoryMode) async {
    return _methodChannelHelper.invokeBoolMethod(
      'setInventoryMode',
      inventoryMode.toMap(),
      () => RfidInterfaceParamCheck.checkInventoryMode(inventoryMode),
    );
  }

  @override
  Future<RfidResult<RfidInventoryMode>> getInventoryMode() async {
    return _methodChannelHelper.invokeObjectMethod<RfidInventoryMode>(
      'getInventoryMode',
      (result) => RfidInventoryMode.fromMap(result),
    );
  }

  @override
  Future<RfidResult<bool>> setGen2(RfidGen2 gen2) async {
    return _methodChannelHelper.invokeBoolMethod(
      'setGen2',
      gen2.toMap(),
      () => RfidInterfaceParamCheck.checkGen2(gen2),
    );
  }

  @override
  Future<RfidResult<RfidGen2>> getGen2() async {
    return _methodChannelHelper.invokeObjectMethod<RfidGen2>(
      'getGen2',
      (result) => RfidGen2.fromMap(result),
    );
  }

  @override
  Future<RfidResult<bool>> setFastId(bool fastId) async {
    return _methodChannelHelper.invokeBoolMethod(
      'setFastId',
      {'value': fastId},
    );
  }

  @override
  Future<RfidResult<bool>> getFastId() async {
    return const RfidResult.failure('not implemented');
  }

  @override
  Future<RfidResult<bool>> setTagFocus(bool tagFocus) async {
    return _methodChannelHelper.invokeBoolMethod(
      'setTagFocus',
      {'value': tagFocus},
    );
  }

  @override
  Future<RfidResult<bool>> getTagFocus() async {
    return const RfidResult.failure('not implemented');
  }

  @override
  Future<RfidResult<bool>> setFastInventory(bool fastInventory) async {
    return _methodChannelHelper.invokeBoolMethod(
      'setFastInventory',
      {'value': fastInventory},
    );
  }

  @override
  Future<RfidResult<bool>> getFastInventory() async {
    return const RfidResult.failure('not implemented');
  }

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

  @override
  Future<RfidResult<bool>> setFilter(RfidFilter filter) async {
    return _methodChannelHelper.invokeBoolMethod(
      'setFilter',
      filter.toMap(),
      () => RfidInterfaceParamCheck.checkFilter(filter),
    );
  }

  Future<RfidResult<bool>> _setupFilter(RfidFilter? filter) async {
    if (filter == null) {
      return const RfidResult.success(true); // 无过滤器
    }

    if (filter.enabled) {
      // 启用过滤器
      final res = await setFilter(filter);
      if (res.isIneffective) {
        return RfidResult.failure("failed${res.error == null ? '' : ': ${res.error}'}");
      }
    } else {
      // 禁用过滤器 - 设置一个空的过滤器
      final emptyFilter = RfidFilter(enabled: true, bank: RfidBank.epc, offset: 0, length: 0, data: '');
      final res = await setFilter(emptyFilter);
      if (res.isIneffective) {
        return RfidResult.failure("failed${res.error == null ? '' : ': ${res.error}'}");
      }
    }

    return const RfidResult.success(true);
  }

  @override
  Future<RfidResult<RfidTagInfo>> singleInventory({RfidFilter? filter}) async {
    final filterResult = await _setupFilter(filter);
    if (filterResult.isIneffective) {
      return RfidResult.failure(filterResult.error);
    }
    return _methodChannelHelper.invokeObjectMethod<RfidTagInfo>(
      'singleInventory',
      (result) => RfidTagInfo.fromMap(result),
    );
  }

  @override
  Future<RfidResult<bool>> startInventory({
    RfidFilter? filter,
    RfidInventoryParam? inventoryParam,
  }) async {
    final filterResult = await _setupFilter(filter);
    if (filterResult.isIneffective) {
      return RfidResult.failure(filterResult.error);
    }

    _inventoryParam = inventoryParam;
    _tagList.clear();

    return _methodChannelHelper.invokeBoolMethod(
      'startInventory',
      inventoryParam?.toMap(),
    );
  }

  @override
  Future<RfidResult<bool>> stopInventory() async {
    return _methodChannelHelper.invokeBoolMethod('stopInventory');
  }

  @override
  Future<RfidResult<String>> readData({
    RfidFilter? filter,
    required RfidBank bank,
    required int offset,
    required int length,
    required String password,
  }) async {
    return _methodChannelHelper.invokeStringMethod(
      'readData',
      {
        'filter': filter?.toMap(),
        'bank': bank.value,
        'offset': offset,
        'length': length,
        'password': password,
      },
      () async {
        await RfidInterfaceParamCheck.checkFilter(filter);
        await RfidInterfaceParamCheck.checkPassword(password);
      },
    );
  }

  @override
  Future<RfidResult<bool>> writeData({
    RfidFilter? filter,
    required RfidBank bank,
    required int offset,
    required int length,
    required String password,
    required String data,
  }) async {
    return _methodChannelHelper.invokeBoolMethod(
      'writeData',
      {
        'filter': filter?.toMap(),
        'bank': bank.value,
        'offset': offset,
        'length': length,
        'password': password,
        'data': data,
      },
      () async {
        await RfidInterfaceParamCheck.checkFilter(filter);
        await RfidInterfaceParamCheck.checkPassword(password);
      },
    );
  }

  @override
  Future<RfidResult<bool>> lockTag({
    RfidFilter? filter,
    required String password,
    required List<RfidLockBank> lockBanks,
    required RfidLockMode lockMode,
  }) async {
    return _methodChannelHelper.invokeBoolMethod(
      'lockTag',
      {
        'filter': filter?.toMap(),
        'password': password,
        'lockCode': RfidTagUtil.getLockCode(lockBanks, lockMode),
      },
      () async {
        await RfidInterfaceParamCheck.checkFilter(filter);
        await RfidInterfaceParamCheck.checkPassword(password);
      },
    );
  }

  @override
  Future<RfidResult<bool>> killTag({
    RfidFilter? filter,
    required String password,
  }) async {
    return _methodChannelHelper.invokeBoolMethod(
      'killTag',
      {
        'filter': filter?.toMap(),
        'password': password,
      },
      () async {
        await RfidInterfaceParamCheck.checkFilter(filter);
        await RfidInterfaceParamCheck.checkPassword(password);
      },
    );
  }
}
