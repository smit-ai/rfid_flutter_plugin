import 'package:flutter/material.dart';
import 'package:rfid_flutter_android_example/view_model/barcode_view_model.dart';
import 'package:signals/signals_flutter.dart';

class BarcodeView extends StatefulWidget {
  const BarcodeView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _BarcodeViewState();
  }
}

class _BarcodeViewState extends State<BarcodeView> {
  late final BarcodeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = BarcodeViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          _buildButtons(),
          _buildBarcodeList(),
        ],
      ),
    );
  }

  Widget _buildBarcodeList() {
    return Watch.builder(
      builder: (context) {
        final barcodeList = _viewModel.barcodeList.watch(context);
        return Expanded(
          child: ListView.separated(
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
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _viewModel.init,
                child: const Text('Init'),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: _viewModel.free,
                child: const Text('Free'),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _viewModel.startScan,
                child: const Text('Start'),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: _viewModel.stopScan,
                child: const Text('Stop'),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: _viewModel.clear,
                child: const Text('Clear'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
