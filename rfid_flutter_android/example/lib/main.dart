import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:signals/signals_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'view/barcode_view.dart';
import 'view/inventory_view.dart';
import 'view/read_write_view.dart';
import 'view/lock_kill_view.dart';
import 'view/settings_view.dart';
import 'entity/app_global_state.dart';
import 'widget/app_bottom_sheet.dart';
import 'entity/rfid_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Watch.builder(
      builder: (context) {
        return MaterialApp(
          title: 'RFID Flutter Android',
          builder: BotToastInit(),
          navigatorObservers: [BotToastNavigatorObserver()],
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: appState.currentLocale.watch(context),
          home: const RfidMainPage(),
        );
      },
    );
  }
}

class RfidMainPage extends StatefulWidget {
  const RfidMainPage({super.key});

  @override
  State<RfidMainPage> createState() => _RfidMainPageState();
}

class _RfidMainPageState extends State<RfidMainPage> with TickerProviderStateMixin {
  late TabController _tabController;

  static const List<Widget> _pages = [
    InventoryView(key: PageStorageKey<String>('InventoryView')),
    SettingsView(key: PageStorageKey<String>('SettingsView')),
    ReadWriteView(key: PageStorageKey<String>('ReadWriteView')),
    LockKillView(key: PageStorageKey<String>('LockKillView')),
    BarcodeView(key: PageStorageKey<String>('BarcodeView')),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _pages.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        appState.setCurrentPageIndex(_tabController.index);
      }
    });

    // RfidWithDeviceInfo.instance.setDebug(true); // Open debug log, default is false
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('app build');

    return Scaffold(
      appBar: AppBar(
        title: _buildAppBarTitle(),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => AppBottomSheet.show(context),
          ),
        ],
        bottom: TabBar(
          isScrollable: true,
          controller: _tabController,
          tabs: [
            Tab(text: AppLocalizations.of(context)!.inventory),
            Tab(text: AppLocalizations.of(context)!.settings),
            Tab(text: AppLocalizations.of(context)!.readWrite),
            Tab(text: AppLocalizations.of(context)!.lockKill),
            Tab(text: AppLocalizations.of(context)!.barcode),
          ],
        ),
      ),
      body: IndexedStack(
        index: appState.currentPageIndex.watch(context),
        children: _pages,
      ),
    );
  }

  Widget _buildAppBarTitle() {
    return Row(
      children: [
        Watch.builder(builder: (context) {
          return Text(
            appState.isHandset.value ? 'UART' : 'URA4',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          );
        }),
        const SizedBox(width: 10),
        SizedBox(
          width: 80,
          height: 34,
          child: ElevatedButton(
            onPressed: () async {
              final res = await RfidManager.instance.init();
              BotToast.showText(text: res.isEffective ? '✅ Init Success' : '❌ Init Failed');
            },
            child: const Text('Init'),
          ),
        ),
        const SizedBox(width: 6),
        SizedBox(
          width: 80,
          height: 34,
          child: ElevatedButton(
            onPressed: () async {
              final res = await RfidManager.instance.free();
              BotToast.showText(text: res.isEffective ? '✅ Free Success' : '❌ Free Failed');
            },
            child: const Text('Free'),
          ),
        ),
      ],
    );
  }
}
