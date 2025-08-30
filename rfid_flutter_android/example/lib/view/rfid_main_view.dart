import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:signals/signals_flutter.dart';
import '../entity/app_global_state.dart';
import '../view_model/rfid_main_view_model.dart';
import '../entity/rfid_manager.dart';
import '../view/inventory_view.dart';
import '../view/read_write_view.dart';
import '../view/lock_kill_view.dart';
import '../view/settings_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rfid_flutter_android/rfid_flutter_android.dart';

class RfidMainView extends StatefulWidget {
  const RfidMainView({super.key});

  @override
  State<RfidMainView> createState() => _RfidMainViewState();
}

class _RfidMainViewState extends State<RfidMainView> with TickerProviderStateMixin {
  late TabController _tabController;

  static const List<Widget> _pages = [
    InventoryView(key: PageStorageKey<String>('InventoryView')),
    SettingsView(key: PageStorageKey<String>('SettingsView')),
    ReadWriteView(key: PageStorageKey<String>('ReadWriteView')),
    LockKillView(key: PageStorageKey<String>('LockKillView')),
  ];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: _pages.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        RfidMainViewModel.instance.currentPageIndex.value = _tabController.index;
      }
    });

    RfidManager.instance.init().then((res) {
      if (res.isEffective) {
        BotToast.showText(text: '✅ Init Success');
      } else {
        BotToast.showText(text: '❌ Init Failed:\n${res.error}');
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    RfidManager.instance.free();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildAppBarTitle(),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          isScrollable: false,
          controller: _tabController,
          tabs: [
            Tab(text: AppLocalizations.of(context)!.inventory),
            Tab(text: AppLocalizations.of(context)!.settings),
            Tab(text: AppLocalizations.of(context)!.readWrite),
            Tab(text: AppLocalizations.of(context)!.lockKill),
          ],
        ),
      ),
      body: IndexedStack(
        index: RfidMainViewModel.instance.currentPageIndex.watch(context),
        children: _pages,
      ),
    );
  }

  Widget _buildAppBarTitle() {
    return Row(
      children: [
        Watch.builder(builder: (context) {
          return Text(
            appState.isHandset.value ? 'RFID UART' : 'RFID URA4',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          );
        }),
      ],
    );
  }
}
