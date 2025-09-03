import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import '../entity/app_global_state.dart';
import '../view_model/rfid_main_view_model.dart';
import '../view/inventory_view.dart';
import '../view/read_write_view.dart';
import '../view/lock_kill_view.dart';
import '../view/settings_view.dart';
import '../l10n/app_localizations.dart';

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

    RfidMainViewModel.instance.init();
  }

  @override
  void dispose() {
    _tabController.dispose();
    RfidMainViewModel.instance.free();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Watch.builder(builder: (context) {
          return Text(appState.isHandset.watch(context) ? 'RFID UART' : 'RFID URA4');
        }),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          isScrollable: true,
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          tabAlignment: TabAlignment.start,
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
}
