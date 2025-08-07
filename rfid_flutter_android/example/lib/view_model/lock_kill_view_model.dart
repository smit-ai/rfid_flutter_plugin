import 'package:signals/signals.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:rfid_flutter_android/rfid_flutter_android.dart';
import '../entity/rfid_manager.dart';
import '../entity/app_global_state.dart';

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
      BotToast.showText(text: appState.localizations.lockTagFailedSelectBank);
      return;
    }
    if (lockPassword.value.isEmpty) {
      BotToast.showText(text: appState.localizations.lockTagFailedEnterPassword);
      return;
    }

    final result = await RfidManager.instance.lockTag(
      filter: filter.value,
      password: lockPassword.value,
      lockBanks: lockBanks.value,
      lockMode: lockMode.value,
    );

    if (result.isEffective) {
      BotToast.showText(text: appState.localizations.lockTagSuccess);
    } else {
      BotToast.showText(text: '${appState.localizations.lockTagFailed}${result.error == null ? '' : ': ${result.error}'}');
    }
  }

  Future<void> killTag() async {
    if (killPassword.value.isEmpty) {
      BotToast.showText(text: appState.localizations.killTagFailedEnterPassword);
      return;
    }

    final result = await RfidManager.instance.killTag(
      filter: filter.value,
      password: killPassword.value,
    );

    if (result.isEffective) {
      BotToast.showText(text: appState.localizations.killTagSuccess);
    } else {
      BotToast.showText(text: '${appState.localizations.killTagFailed}${result.error == null ? '' : ': ${result.error}'}');
    }
  }
}
