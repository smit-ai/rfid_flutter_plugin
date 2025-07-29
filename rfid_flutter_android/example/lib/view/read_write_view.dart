import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:rfid_flutter_android/rfid_flutter_android.dart';
import '../view_model/read_write_view_model.dart';
import '../widget/filter_widget.dart';

class ReadWriteView extends StatefulWidget {
  const ReadWriteView({super.key});

  @override
  State<ReadWriteView> createState() => _ReadWriteViewState();
}

class _ReadWriteViewState extends State<ReadWriteView> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final ReadWriteViewModel _viewModel;

  late final TextEditingController _offsetController;
  late final TextEditingController _lengthController;
  late final TextEditingController _dataController;

  late final EffectCleanup _dataEffectCleanup;

  @override
  void initState() {
    super.initState();
    _viewModel = ReadWriteViewModel();
    _initializeControllers();
    _setupListeners();
  }

  void _initializeControllers() {
    _offsetController = TextEditingController(text: _viewModel.offset.value.toString());
    _lengthController = TextEditingController(text: _viewModel.length.value.toString());
    _dataController = TextEditingController(text: _viewModel.data.value);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _offsetController.dispose();
    _lengthController.dispose();
    _dataController.dispose();
    _dataEffectCleanup(); // 清理 effect
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // print("ReadWriteView build");

    return SingleChildScrollView(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          // 过滤器组件
          Watch((context) => FilterWidget(filter: _viewModel.filter.value)),

          const SizedBox(height: 6.0),

          // 读写参数配置
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
            ),
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bank
                Watch.builder(builder: (context) {
                  return InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Bank',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.fromLTRB(12, 8, 12, 0),
                      isDense: true,
                    ),
                    child: Transform.translate(
                      offset: const Offset(-10, 3),
                      child: Wrap(
                        spacing: 4.0,
                        children: [
                          _buildBankRadio(RfidBank.reserved, 'RESERVED', _viewModel.bank.value),
                          const SizedBox(width: 8.0),
                          _buildBankRadio(RfidBank.epc, 'EPC', _viewModel.bank.value),
                          const SizedBox(width: 8.0),
                          _buildBankRadio(RfidBank.tid, 'TID', _viewModel.bank.value),
                          const SizedBox(width: 8.0),
                          _buildBankRadio(RfidBank.user, 'USER', _viewModel.bank.value),
                        ],
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 14.0),

                // Offset 和 Length
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _offsetController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Offset (word)',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14.0),
                    Expanded(
                      child: TextFormField(
                        controller: _lengthController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Length (word)',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14.0),

                // Password
                Watch.builder(builder: (context) {
                  return TextFormField(
                    initialValue: _viewModel.password.value,
                    onChanged: (value) => _viewModel.password.value = value,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      isDense: true,
                      hintText: 'Enter password',
                    ),
                  );
                }),

                const SizedBox(height: 14.0),

                // Data
                Watch.builder(builder: (context) {
                  return TextFormField(
                    controller: _dataController,
                    decoration: const InputDecoration(
                      labelText: 'Data (hex)',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      isDense: true,
                      hintText: 'Enter hex data',
                    ),
                  );
                }),

                const SizedBox(height: 14.0),

                // 操作按钮
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _viewModel.writeData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Write', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _viewModel.readData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Read', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankRadio(RfidBank bank, String label, RfidBank selectedBank) {
    return GestureDetector(
      onTap: () => _updateBankAndOffset(bank),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<RfidBank>(
            value: bank,
            groupValue: selectedBank,
            onChanged: (value) {
              if (value != null) {
                _updateBankAndOffset(value);
              }
            },
            activeColor: Colors.blue,
            visualDensity: VisualDensity.standard,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  void _setupListeners() {
    // 监听控制器变化，同步到 ViewModel
    _offsetController.addListener(() {
      final value = int.tryParse(_offsetController.text) ?? 0;
      _viewModel.offset.value = value;
    });

    _lengthController.addListener(() {
      final value = int.tryParse(_lengthController.text) ?? 0;
      _viewModel.length.value = value;
    });

    _dataController.addListener(() {
      _viewModel.data.value = _dataController.text;
      _updateDataAndLength(_dataController.text);
    });

    // 监听 ViewModel data signal 的变化，同步到控制器
    _dataEffectCleanup = effect(() {
      final newData = _viewModel.data.value;
      if (_dataController.text != newData) {
        _dataController.text = newData;
        _updateDataAndLength(newData);
      }
    });
  }

  void _updateDataAndLength(String newData) {
    final newLength = newData.length ~/ 4;
    if (newLength != _viewModel.length.value) {
      _viewModel.length.value = newLength;
      _lengthController.text = newLength.toString();
    }
  }

  void _updateBankAndOffset(RfidBank newBank) {
    _viewModel.bank.value = newBank;
    if (newBank == RfidBank.epc) {
      _viewModel.offset.value = 2;
      _offsetController.text = '2';
    } else {
      _viewModel.offset.value = 0;
      _offsetController.text = '0';
    }
    if (newBank == RfidBank.reserved) {
      _viewModel.length.value = 4;
      _lengthController.text = '4';
    } else {
      _viewModel.length.value = 6;
      _lengthController.text = '6';
    }
  }
}
