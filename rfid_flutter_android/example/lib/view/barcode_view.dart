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
        child: Column(
          children: [
            _buildDecodingFormat(),
            _buildBarcodeList(),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildDecodingFormat() {
    return Container(
      color: Colors.blue.shade100,
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Row(
        children: [
          Text('${AppLocalizations.of(context)!.decodingFormat}:'),
          const SizedBox(width: 6),
          Watch.builder(builder: (context) {
            return DropdownButton(
              value: _viewModel.decodingFormat.watch(context),
              borderRadius: BorderRadius.circular(4),
              items: const [
                DropdownMenuItem(value: 'UTF-8', child: Text('UTF-8')),
                DropdownMenuItem(value: 'GB18030', child: Text('GB18030')),
                DropdownMenuItem(value: 'ISO-8859-1', child: Text('ISO-8859-1')),
                DropdownMenuItem(value: 'SHIFT_JIS', child: Text('SHIFT_JIS')),
              ],
              onChanged: (value) {
                _viewModel.decodingFormat.value = value ?? 'UTF-8';
              },
            );
          }),
        ],
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
              var text = barcodeList[index].extensions['decodingFormatData'];
              if (text == null || text.isEmpty) {
                text = barcodeList[index].barcode;
              }
              return Padding(
                padding: const EdgeInsets.all(6.0),
                child: SelectableText(text),
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
        const SizedBox(width: 4),
        Expanded(
          child: ElevatedButton(
            onPressed: _viewModel.startScan,
            child: Text(AppLocalizations.of(context)!.start),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: ElevatedButton(
            onPressed: _viewModel.stopScan,
            child: Text(AppLocalizations.of(context)!.stop),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: ElevatedButton(
            onPressed: _viewModel.clear,
            child: Text(AppLocalizations.of(context)!.clear),
          ),
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}
