import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:rfid_flutter_android/rfid_flutter_android.dart';
import '../l10n/app_localizations.dart';
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

  static const List<DropdownMenuItem<int>> _fastInventoryCrItems = [
    DropdownMenuItem(value: RfidFastInventory.crClose, child: Text('Close')),
    DropdownMenuItem(value: RfidFastInventory.crID16, child: Text('CrID16')),
    DropdownMenuItem(value: RfidFastInventory.crStoredCRC, child: Text('CrStoredCRC')),
    DropdownMenuItem(value: RfidFastInventory.crRN16, child: Text('CrRN16')),
    DropdownMenuItem(value: RfidFastInventory.crID32, child: Text('CrID32')),
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
    // print('SettingsView build');
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
              _buildFastInventorySection(),
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
        Text(AppLocalizations.of(context)!.basicFunctions, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(onPressed: viewModel.getUhfFirmwareVersion, child: Text(AppLocalizations.of(context)!.firmwareVer)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(onPressed: viewModel.getUhfHardwareVersion, child: Text(AppLocalizations.of(context)!.hardwareVer)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(onPressed: viewModel.getTemperature, child: Text(AppLocalizations.of(context)!.temperature)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(AppLocalizations.of(context)!.resetModuleTitle),
                      content: Text(AppLocalizations.of(context)!.resetModuleContent),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)!.cancel)),
                        TextButton(
                          onPressed: () {
                            viewModel.resetModule();
                            // 关闭弹窗
                            Navigator.pop(context);
                          },
                          child: Text(AppLocalizations.of(context)!.reset),
                        ),
                      ],
                    ),
                  );
                },
                child: Text(AppLocalizations.of(context)!.resetModule),
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
        Text(AppLocalizations.of(context)!.frequency, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Watch.builder(builder: (context) {
          return DropdownButtonFormField<RfidFrequency>(
            value: viewModel.selectedFrequency.watch(context),
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.selectFrequency,
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
              child: ElevatedButton(onPressed: viewModel.setFrequency, child: Text(AppLocalizations.of(context)!.setFrequency)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(onPressed: viewModel.getFrequency, child: Text(AppLocalizations.of(context)!.getFrequency)),
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
        Text(
          AppLocalizations.of(context)!.rfLink,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Watch.builder(builder: (context) {
          return DropdownButtonFormField<RfidRfLink>(
            value: viewModel.selectedRfLink.value,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.selectRfLink,
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
              child: ElevatedButton(onPressed: viewModel.setRfLink, child: Text(AppLocalizations.of(context)!.setRfLink)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(onPressed: viewModel.getRfLink, child: Text(AppLocalizations.of(context)!.getRfLink)),
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
        Text(AppLocalizations.of(context)!.power, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
              Text(AppLocalizations.of(context)!.powerLevel, style: const TextStyle(fontWeight: FontWeight.bold)),
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
                          '${AppLocalizations.of(context)!.current}: ${power.round()} dBm',
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
              child: ElevatedButton(onPressed: viewModel.setPower, child: Text(AppLocalizations.of(context)!.setPower)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(onPressed: viewModel.getPower, child: Text(AppLocalizations.of(context)!.getPower)),
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
        Text(AppLocalizations.of(context)!.inventoryMode, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Watch.builder(builder: (context) {
          return Column(
            children: [
              DropdownButtonFormField<RfidInventoryBank>(
                value: viewModel.selectedInventoryBank.value,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.inventoryBank,
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.offsetWord,
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.lengthWord,
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
              child: ElevatedButton(onPressed: viewModel.setInventoryMode, child: Text(AppLocalizations.of(context)!.set)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(onPressed: viewModel.getInventoryMode, child: Text(AppLocalizations.of(context)!.get)),
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
        Text(AppLocalizations.of(context)!.gen2Parameters, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Watch.builder(builder: (context) {
          return Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: viewModel.selectedQuerySession.value,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.querySession,
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.queryTarget,
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
              child: ElevatedButton(onPressed: viewModel.setGen2, child: Text(AppLocalizations.of(context)!.set)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(onPressed: viewModel.getGen2, child: Text(AppLocalizations.of(context)!.get)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFastInventorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.fastInventory, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        Watch.builder(builder: (context) {
          return DropdownButtonFormField<int>(
            value: viewModel.selectedFastInventory.value,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.fastInventory,
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: _fastInventoryCrItems,
            onChanged: (rfLink) {
              if (rfLink != null) {
                viewModel.selectedFastInventory.value = rfLink;
              }
            },
          );
        }),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(onPressed: viewModel.setFastInventory, child: Text(AppLocalizations.of(context)!.set)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(onPressed: viewModel.getFastInventory, child: Text(AppLocalizations.of(context)!.get)),
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
        Text(AppLocalizations.of(context)!.antennaState, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
              child: ElevatedButton(onPressed: viewModel.setAntennaState, child: Text(AppLocalizations.of(context)!.setAntennaState)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(onPressed: viewModel.getAntennaState, child: Text(AppLocalizations.of(context)!.getAntennaState)),
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
                  Text('${AppLocalizations.of(context)!.antenna} $antennaNumber'),
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
                labelText: AppLocalizations.of(context)!.powerDbm,
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
        // Fast ID Section
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
            color: Colors.blue.shade50,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.fastId,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Watch.builder(builder: (context) {
                    return Switch(
                      value: viewModel.selectedFastId.watch(context),
                      onChanged: (value) {
                        viewModel.selectedFastId.value = value;
                      },
                      activeColor: Colors.green,
                    );
                  }),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(onPressed: viewModel.setFastId, child: Text(AppLocalizations.of(context)!.set)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(onPressed: viewModel.getFastId, child: Text(AppLocalizations.of(context)!.get)),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Tag Focus Section
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
            color: Colors.blue.shade50,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.tagFocus,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Watch.builder(builder: (context) {
                    return Switch(
                      value: viewModel.selectedTagFocus.watch(context),
                      onChanged: (value) {
                        viewModel.selectedTagFocus.value = value;
                      },
                      activeColor: Colors.green,
                    );
                  }),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(onPressed: viewModel.setTagFocus, child: Text(AppLocalizations.of(context)!.set)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(onPressed: viewModel.getTagFocus, child: Text(AppLocalizations.of(context)!.get)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
