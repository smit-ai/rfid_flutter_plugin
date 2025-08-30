import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:signals/signals_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'entity/app_global_state.dart';
import 'widget/app_bottom_sheet.dart';
import 'widget/feature_card.dart';
import 'view/rfid_main_view.dart';
import 'view/barcode_view.dart';
import 'package:rfid_flutter_android/rfid_flutter_android.dart';

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
  @override
  void initState() {
    super.initState();
    RfidWithDeviceInfo.instance.isHandset().then((res) {
      appState.isHandset.value = res.data ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RFID Flutter Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => AppBottomSheet.show(context),
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
                      title: 'RFID Scanner',
                      subtitle: 'Scan and manage RFID tags',
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
                      title: 'Barcode Scanner',
                      subtitle: 'Scan barcodes, QR codes, etc.',
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
}
