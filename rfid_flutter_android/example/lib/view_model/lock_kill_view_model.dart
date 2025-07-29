import 'package:signals/signals.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:rfid_flutter_android/rfid_flutter_android.dart';
import '../entity/rfid_manager.dart';

class LockKillViewModel {
  final filter = signal(RfidFilter(
    enabled: false,
    offset: 32,
    length: 96,
    bank: RfidBank.epc,
    data: '',
  ));

  final lockPassword = signal('');
  final lockMode = signal(RfidLockMode.lock);
  final lockBanks = signal<List<RfidLockBank>>([]);

  final killPassword = signal('');

  Future<void> lockTag() async {
    // print('lockTag: ${filter.value} ${lockPassword.value} ${lockBanks.value} ${lockMode.value}');

    if (lockBanks.value.isEmpty) {
      BotToast.showText(text: '❌ Lock tag failed: Please select at least one bank to lock');
      return;
    }
    if (lockPassword.value.isEmpty) {
      BotToast.showText(text: '❌ Lock tag failed: Please enter access password');
      return;
    }

    final result = await RfidManager.instance.lockTag(
      filter: filter.value,
      password: lockPassword.value,
      lockBanks: lockBanks.value,
      lockMode: lockMode.value,
    );

    if (result.isEffective) {
      BotToast.showText(text: '✅ Lock tag successfully');
    } else {
      BotToast.showText(text: '❌ Lock tag failed${result.error == null ? '' : ': ${result.error}'} ');
    }
  }

  Future<void> killTag() async {
    if (killPassword.value.isEmpty) {
      BotToast.showText(text: '❌ Kill tag failed: Please enter kill password');
      return;
    }

    final result = await RfidManager.instance.killTag(
      filter: filter.value,
      password: killPassword.value,
    );

    if (result.isEffective) {
      BotToast.showText(text: '✅ Kill tag successfully');
    } else {
      BotToast.showText(text: '❌ Kill tag failed${result.error == null ? '' : ': ${result.error}'}');
    }
  }
}
