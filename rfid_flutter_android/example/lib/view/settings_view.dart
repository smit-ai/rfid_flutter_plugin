import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:rfid_flutter_core/rfid_flutter_core.dart';
import '../entity/app_global_state.dart';
import '../view_model/settings_view_model.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> with AutomaticKeepAliveClientMixin {
  late final SettingsViewModel viewModel;

  static final List<DropdownMenuItem<RfidFrequency>> _frequencyItems = RfidFrequency.values.map((frequency) {
    return DropdownMenuItem(
      value: frequency,
      child: Text(frequency.description, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
    );
  }).toList();

  static final List<DropdownMenuItem<RfidRfLink>> _rfLinkItems = RfidRfLink.values.map((rfLink) {
    return DropdownMenuItem(
      value: rfLink,
      child: Text(rfLink.description, style: const TextStyle(fontSize: 11), overflow: TextOverflow.ellipsis),
    );
  }).toList();

  static final List<DropdownMenuItem<RfidInventoryBank>> _inventoryBankItems = RfidInventoryBank.values.map((bank) {
    return DropdownMenuItem(value: bank, child: Text(bank.description));
  }).toList();

  static const List<DropdownMenuItem<int>> _querySessionItems = [
    DropdownMenuItem(value: RfidGen2.querySessionS0, child: Text('S0')),
    DropdownMenuItem(value: RfidGen2.querySessionS1, child: Text('S1')),
    DropdownMenuItem(value: RfidGen2.querySessionS2, child: Text('S2')),
    DropdownMenuItem(value: RfidGen2.querySessionS3, child: Text('S3')),
  ];

  static const List<DropdownMenuItem<int>> _queryTargetItems = [
    DropdownMenuItem(value: RfidGen2.queryTargetA, child: Text('A')),
    DropdownMenuItem(value: RfidGen2.queryTargetB, child: Text('B')),
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    viewModel = SettingsViewModel();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print('SettingsView build');
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildBasicFunctions(),
              const SizedBox(height: 20),
              _buildFrequencySection(),
              const SizedBox(height: 20),
              Watch.builder(builder: (context) {
                final isHandset = appState.isHandset.watch(context);
                return isHandset ? _buildPowerSection() : _buildAntennaStateSection();
              }),
              const SizedBox(height: 20),
              _buildRfLinkSection(),
              const SizedBox(height: 20),
              _buildInventoryModeSection(),
              const SizedBox(height: 20),
              _buildGen2Section(),
              const SizedBox(height: 20),
              _buildOtherFunctions(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicFunctions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('UART Basic Functions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(onPressed: viewModel.getUhfFirmwareVersion, child: const Text('Firmware Ver')),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(onPressed: viewModel.getUhfHardwareVersion, child: const Text('Hardware Ver')),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(onPressed: viewModel.getTemperature, child: const Text('Temperature')),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Reset Module'),
                      content: const Text('Are you sure you want to reset all settings?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                        TextButton(
                          onPressed: () {
                            viewModel.resetModule();
                            // 关闭弹窗
                            Navigator.pop(context);
                          },
                          child: const Text('Reset'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Reset Module'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFrequencySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Frequency', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Watch.builder(builder: (context) {
          return DropdownButtonFormField<RfidFrequency>(
            value: viewModel.selectedFrequency.watch(context),
            decoration: const InputDecoration(
              labelText: 'Select Frequency',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: _frequencyItems,
            onChanged: (frequency) {
              if (frequency != null) {
                viewModel.selectedFrequency.value = frequency;
              }
            },
          );
        }),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(onPressed: viewModel.setFrequency, child: const Text('Set Frequency')),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(onPressed: viewModel.getFrequency, child: const Text('Get Frequency')),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRfLinkSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'RF Link',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Watch.builder(builder: (context) {
          return DropdownButtonFormField<RfidRfLink>(
            value: viewModel.selectedRfLink.value,
            decoration: const InputDecoration(
              labelText: 'Select RF Link',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: _rfLinkItems,
            onChanged: (rfLink) {
              if (rfLink != null) {
                viewModel.selectedRfLink.value = rfLink;
              }
            },
          );
        }),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(onPressed: viewModel.setRfLink, child: const Text('Set RF Link')),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(onPressed: viewModel.getRfLink, child: const Text('Get RF Link')),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPowerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Power', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
            color: Colors.blue.shade50,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Power Level:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Watch.builder(builder: (context) {
                final power = viewModel.selectedPower.value.toDouble();
                return Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Colors.blue,
                        inactiveTrackColor: Colors.blue.shade200,
                        trackHeight: 6,
                        thumbColor: Colors.blue.shade700,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                        overlayColor: Colors.blue.withOpacity(0.2),
                      ),
                      child: Slider(
                        value: power,
                        min: 1,
                        max: 30,
                        divisions: 29,
                        label: '${power.round()} dBm',
                        onChanged: (value) {
                          viewModel.selectedPower.value = value.round();
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('1 dBm', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                        Text(
                          'Current: ${power.round()} dBm',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                        Text('30 dBm', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                      ],
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(onPressed: viewModel.setPower, child: const Text('Set Power')),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(onPressed: viewModel.getPower, child: const Text('Get Power')),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInventoryModeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Inventory Mode', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Watch.builder(builder: (context) {
          return Column(
            children: [
              DropdownButtonFormField<RfidInventoryBank>(
                value: viewModel.selectedInventoryBank.value,
                decoration: const InputDecoration(
                  labelText: 'Inventory Bank',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: _inventoryBankItems,
                onChanged: (bank) {
                  if (bank != null) {
                    viewModel.selectedInventoryBank.value = bank;
                  }
                },
              ),
              const SizedBox(height: 12),
              if (viewModel.selectedInventoryBank.value.value >= RfidInventoryBank.epcTidUser.value) ...[
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        key: ValueKey(viewModel.selectedOffset.value),
                        initialValue: viewModel.selectedOffset.value.toString(),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Offset (word)',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        onChanged: (value) {
                          final parsedValue = int.tryParse(value);
                          if (parsedValue != null && parsedValue >= 0) {
                            viewModel.selectedOffset.value = parsedValue;
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        key: ValueKey(viewModel.selectedLength.value),
                        initialValue: viewModel.selectedLength.value.toString(),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Length (word)',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        onChanged: (value) {
                          final parsedValue = int.tryParse(value);
                          if (parsedValue != null && parsedValue >= 1) {
                            viewModel.selectedLength.value = parsedValue;
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ],
          );
        }),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(onPressed: viewModel.setInventoryMode, child: const Text('Set')),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(onPressed: viewModel.getInventoryMode, child: const Text('Get')),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGen2Section() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Gen2 Parameters', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Watch.builder(builder: (context) {
          return Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: viewModel.selectedQuerySession.value,
                  decoration: const InputDecoration(
                    labelText: 'Query Session',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: _querySessionItems,
                  onChanged: (value) {
                    if (value != null) {
                      viewModel.selectedQuerySession.value = value;
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: viewModel.selectedQueryTarget.value,
                  decoration: const InputDecoration(
                    labelText: 'Query Target',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: _queryTargetItems,
                  onChanged: (value) {
                    if (value != null) {
                      viewModel.selectedQueryTarget.value = value;
                    }
                  },
                ),
              ),
            ],
          );
        }),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(onPressed: viewModel.setGen2, child: const Text('Set')),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(onPressed: viewModel.getGen2, child: const Text('Get')),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAntennaStateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Antenna State', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
            color: Colors.blue.shade50,
          ),
          child: Column(
            children: [
              _buildAntennaRow(1, viewModel.antenna1State),
              const SizedBox(height: 12),
              _buildAntennaRow(2, viewModel.antenna2State),
              const SizedBox(height: 12),
              _buildAntennaRow(3, viewModel.antenna3State),
              const SizedBox(height: 12),
              _buildAntennaRow(4, viewModel.antenna4State),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(onPressed: viewModel.setAntennaState, child: const Text('Set Antenna State')),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(onPressed: viewModel.getAntennaState, child: const Text('Get Antenna State')),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAntennaRow(int antennaNumber, Signal<RfidAntennaState> antennaStateSignal) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Watch.builder(builder: (context) {
            final antennaState = antennaStateSignal.watch(context);
            final enabled = antennaState.enable ?? false;
            return GestureDetector(
              onTap: () {
                antennaStateSignal.value = RfidAntennaState(
                  antenna: antennaState.antenna,
                  enable: !enabled,
                  power: antennaState.power,
                );
              },
              child: Row(
                children: [
                  Checkbox(
                    value: enabled,
                    onChanged: (value) {
                      antennaStateSignal.value = RfidAntennaState(
                        antenna: antennaState.antenna,
                        enable: value ?? false,
                        power: antennaState.power,
                      );
                    },
                    visualDensity: VisualDensity.standard,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  Text('Antenna $antennaNumber'),
                ],
              ),
            );
          }),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 3,
          child: Watch.builder(builder: (context) {
            final antennaState = antennaStateSignal.watch(context);
            final enabled = antennaState.enable ?? false;
            final power = antennaState.power ?? 20;
            return TextFormField(
              key: ValueKey('antenna${antennaNumber}Power_$power'),
              initialValue: power.toString(),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Power (dBm)',
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                suffixText: 'dBm',
                enabled: enabled,
              ),
              onChanged: (value) {
                final parsedValue = int.tryParse(value);
                if (parsedValue != null && parsedValue >= 1 && parsedValue <= 30) {
                  antennaStateSignal.value = RfidAntennaState(
                    antenna: antennaState.antenna,
                    enable: antennaState.enable,
                    power: parsedValue,
                  );
                }
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildOtherFunctions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('FastId', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => viewModel.setFastId(true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                child: const Text('Enable'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => viewModel.setFastId(false),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                child: const Text('Disable'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text('TagFocus', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => viewModel.setTagFocus(true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                child: const Text('Enable'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => viewModel.setTagFocus(false),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                child: const Text('Disable'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text('FastInventory', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => viewModel.setFastInventory(true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                child: const Text('Enable'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => viewModel.setFastInventory(false),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                child: const Text('Disable'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
