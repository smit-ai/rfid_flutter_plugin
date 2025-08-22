import 'package:flutter/material.dart';
import 'package:rfid_flutter_android/rfid_flutter_android.dart';
import 'package:signals/signals_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FilterWidget extends StatefulWidget {
  final RfidFilter filter;

  const FilterWidget({
    super.key,
    required this.filter,
  });

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  late TextEditingController _offsetController;
  late TextEditingController _lengthController;
  late TextEditingController _dataController;

  late Signal<bool> _enabled;
  late Signal<bool> _expanded;
  late Signal<RfidBank> _selectedBank;

  @override
  void initState() {
    super.initState();
    _offsetController = TextEditingController(text: widget.filter.offset.toString());
    _lengthController = TextEditingController(text: widget.filter.length.toString());
    _dataController = TextEditingController(text: widget.filter.data);

    _enabled = signal(widget.filter.enabled);
    _expanded = signal(widget.filter.enabled);
    _selectedBank = signal(widget.filter.bank);
  }

  @override
  void dispose() {
    _offsetController.dispose();
    _lengthController.dispose();
    _dataController.dispose();
    _enabled.dispose();
    _expanded.dispose();
    _selectedBank.dispose();
    super.dispose();
  }

  void _toggleFilter() {
    widget.filter.enabled = !widget.filter.enabled;
    _enabled.value = widget.filter.enabled;
    _expanded.value = _enabled.value;
  }

  void _toggleExpanded() {
    _expanded.value = !_expanded.value;
  }

  void _updateBankAndOffset(RfidBank bank) {
    widget.filter.bank = bank;
    _selectedBank.value = bank;

    // 根据Bank类型自动设置Offset
    if (bank == RfidBank.epc) {
      widget.filter.offset = 32;
      _offsetController.text = '32';
    } else {
      widget.filter.offset = 0;
      _offsetController.text = '0';
    }
  }

  void _updateDataAndLength(String data) {
    widget.filter.data = data.toUpperCase();
    // 根据Data长度自动计算Length
    final length = data.length * 4;
    widget.filter.length = length;
    _lengthController.text = length.toString();
  }

  @override
  Widget build(BuildContext context) {
    //print('FilterWidget build, filter: ${widget.filter}');
    return Container(
      // margin: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.blue.shade50,
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Row(
              children: [
                Watch.builder(builder: (context) {
                  final enabled = _enabled.watch(context);
                  return GestureDetector(
                    onTap: _toggleFilter,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                      child: Row(
                        children: [
                          Checkbox(
                            value: enabled,
                            onChanged: (value) => _toggleFilter(),
                            activeColor: Colors.blue,
                            visualDensity: VisualDensity.standard,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          Text(
                            AppLocalizations.of(context)!.filter,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                Watch.builder(builder: (context) {
                  final expanded = _expanded.watch(context);
                  return Expanded(
                    child: GestureDetector(
                      onTap: _toggleExpanded,
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6.0)),
                        padding: const EdgeInsets.fromLTRB(8, 12, 6, 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.grey.shade600),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          // Expandable content
          Watch.builder(builder: (context) {
            final expanded = _expanded.watch(context);
            if (!expanded) return const SizedBox.shrink();

            return Padding(
              padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Watch.builder(builder: (context) {
                    final selectedBank = _selectedBank.watch(context);
                    return InputDecorator(
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.bank,
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                        isDense: true,
                      ),
                      child: Transform.translate(
                        offset: const Offset(-10, 3),
                        child: Row(
                          children: [
                            _buildBankRadio(RfidBank.epc, 'EPC', selectedBank),
                            const SizedBox(width: 8.0),
                            _buildBankRadio(RfidBank.tid, 'TID', selectedBank),
                            const SizedBox(width: 8.0),
                            _buildBankRadio(RfidBank.user, 'USER', selectedBank),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 14.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _offsetController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: '${AppLocalizations.of(context)!.offset} (bit)',
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                            isDense: true,
                          ),
                          onChanged: (value) {
                            final parsedValue = int.tryParse(value) ?? -1;
                            widget.filter.offset = parsedValue;
                          },
                        ),
                      ),
                      const SizedBox(width: 14.0),
                      Expanded(
                        child: TextFormField(
                          controller: _lengthController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: '${AppLocalizations.of(context)!.length} (bit)',
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                            isDense: true,
                          ),
                          onChanged: (value) {
                            final parsedValue = int.tryParse(value) ?? -1;
                            widget.filter.length = parsedValue;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14.0),
                  TextFormField(
                    controller: _dataController,
                    decoration: InputDecoration(
                      labelText: '${AppLocalizations.of(context)!.data} (hex)',
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      isDense: true,
                      hintText: AppLocalizations.of(context)!.enterHexData,
                    ),
                    onChanged: _updateDataAndLength,
                  ),
                ],
              ),
            );
          }),
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
}
