import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:rfid_flutter_android_example/view/device_info_view.dart';
import 'package:signals/signals_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'entity/app_global_state.dart';
import 'widget/feature_card.dart';
import 'view/rfid_main_view.dart';
import 'view/barcode_view.dart';
import 'package:rfid_flutter_android/rfid_flutter_android.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
  final _appNameAndVersion = signal('RFID Flutter Demo');

  @override
  void initState() {
    super.initState();
    _getAppNameAndVersion();
    RfidWithDeviceInfo.instance.isHandset().then((res) {
      appState.isHandset.value = res.data ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Watch.builder(builder: (context) {
          return Text(_appNameAndVersion.watch(context));
        }),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // elevation: 0,
        actions: [
          IconButton(
            icon: Image.asset(
              appState.currentLocale.value.languageCode == 'en' ? 'assets/image/lang_en.png' : 'assets/image/lang_cn.png',
              width: 28,
            ),
            onPressed: () {
              // AppBottomSheet.show(context);
              appState.setLocale(appState.currentLocale.value.languageCode == 'en' ? const Locale('zh') : const Locale('en'));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: [
                    FeatureCard(
                      title: AppLocalizations.of(context)!.deviceInfo,
                      subtitle: AppLocalizations.of(context)!.deviceInfoSubtitle,
                      icon: Icons.info_outline,
                      color: Colors.black,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const DeviceInfoView(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    FeatureCard(
                      title: AppLocalizations.of(context)!.rfidScanner,
                      subtitle: AppLocalizations.of(context)!.rfidScannerSubtitle,
                      icon: Icons.sensors,
                      color: Colors.blue,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const RfidMainView(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    FeatureCard(
                      title: AppLocalizations.of(context)!.barcodeScanner,
                      subtitle: AppLocalizations.of(context)!.barcodeScannerSubtitle,
                      icon: Icons.qr_code_scanner,
                      color: Colors.green,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const BarcodeView(),
                          ),
                        );
                      },
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _getAppNameAndVersion() {
    PackageInfo.fromPlatform().then((packageInfo) {
      _appNameAndVersion.value = 'RFID Flutter Demo_v${packageInfo.version}';
    });
  }
}
