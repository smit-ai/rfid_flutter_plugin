import 'package:flutter/material.dart';
import 'package:rfid_flutter_android_example/view_model/barcode_view_model.dart';
import 'package:signals/signals_flutter.dart';
import '../l10n/app_localizations.dart';

class BarcodeView extends StatefulWidget {
  const BarcodeView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _BarcodeViewState();
  }
}

class _BarcodeViewState extends State<BarcodeView> {
  late final BarcodeViewModel _viewModel;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _viewModel = BarcodeViewModel();
    _viewModel.setScrollToBottomCallback(_scrollToBottom);
    _viewModel.init();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _viewModel.free();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.barcodeScanner),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              _buildBarcodeList(),
              _buildButtons(),
            ],
          ),
        ),
      ),
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  Widget _buildBarcodeList() {
    return Watch.builder(
      builder: (context) {
        final barcodeList = _viewModel.barcodeList.watch(context);
        return Expanded(
          child: ListView.separated(
            controller: _scrollController,
            itemCount: barcodeList.length,
            separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade300),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(barcodeList[index].barcode),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _viewModel.startScan,
            child: Text(AppLocalizations.of(context)!.start),
          ),
        ),
        Expanded(
          child: ElevatedButton(
            onPressed: _viewModel.stopScan,
            child: Text(AppLocalizations.of(context)!.stop),
          ),
        ),
        Expanded(
          child: ElevatedButton(
            onPressed: _viewModel.clear,
            child: Text(AppLocalizations.of(context)!.clear),
          ),
        ),
      ],
    );
  }
}
