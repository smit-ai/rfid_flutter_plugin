import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:rfid_flutter_android/rfid_flutter_android.dart';
import '../l10n/app_localizations.dart';
import 'package:rfid_flutter_android_example/widget/filter_widget.dart';
import 'package:rfid_flutter_android_example/view_model/lock_kill_view_model.dart';

class LockKillView extends StatefulWidget {
  const LockKillView({super.key});

  @override
  State<LockKillView> createState() => _LockKillViewState();
}

class _LockKillViewState extends State<LockKillView> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final LockKillViewModel _viewModel;

  final TextEditingController _lockPasswordController = TextEditingController();
  final TextEditingController _killPasswordController = TextEditingController();

  // Expanded state for sections
  final isLockSectionExpanded = signal(true);
  final isKillSectionExpanded = signal(true);

  @override
  void initState() {
    super.initState();
    _viewModel = LockKillViewModel();

    _lockPasswordController.addListener(() {
      _viewModel.lockPassword.value = _lockPasswordController.text;
    });
    _killPasswordController.addListener(() {
      _viewModel.killPassword.value = _killPasswordController.text;
    });
  }

  @override
  void dispose() {
    _lockPasswordController.dispose();
    _killPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // print('LockKillView build');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          // Filter Widget
          FilterWidget(filter: _viewModel.filter.value),

          const SizedBox(height: 10.0),

          // Lock Section
          _buildLockSection(),

          const SizedBox(height: 20.0),

          // Kill Section
          _buildKillSection(),
        ],
      ),
    );
  }

  Widget _buildLockSection() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.orange.shade300),
      ),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Watch.builder(builder: (context) {
            return InkWell(
              onTap: () {
                isLockSectionExpanded.value = !isLockSectionExpanded.value;
              },
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: Row(
                children: [
                  Icon(Icons.lock, color: Colors.orange.shade600),
                  const SizedBox(width: 8.0),
                  Text(
                    AppLocalizations.of(context)!.lockAndUnlock,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Expanded(child: SizedBox.shrink()),
                  AnimatedRotation(
                    turns: isLockSectionExpanded.value ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade500),
                  ),
                ],
              ),
            );
          }),

          // Expandable content
          Watch.builder(builder: (context) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: isLockSectionExpanded.value ? null : 0,
              child: isLockSectionExpanded.value
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16.0),

                        // Lock Password Input
                        TextFormField(
                          controller: _lockPasswordController,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.accessPassword,
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                            isDense: true,
                            hintText: AppLocalizations.of(context)!.cantUseDefaultPassword,
                          ),
                          maxLength: 8,
                        ),

                        // const SizedBox(height: 6.0),

                        // Lock Mode Selection
                        Watch.builder(builder: (context) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.lockMode,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4.0),
                              // First row: Lock and Permanent Lock
                              Row(
                                children: [
                                  Flexible(
                                    flex: 2,
                                    child: RadioListTile<RfidLockMode>(
                                      title: Text(
                                        AppLocalizations.of(context)!.lock,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      value: RfidLockMode.lock,
                                      groupValue: _viewModel.lockMode.value,
                                      onChanged: (value) {
                                        if (value != null) {
                                          _viewModel.lockMode.value = value;
                                        }
                                      },
                                      activeColor: Colors.orange,
                                      contentPadding: EdgeInsets.zero,
                                      dense: true,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  ),
                                  Flexible(
                                    flex: 3,
                                    child: RadioListTile<RfidLockMode>(
                                      title: Text(
                                        AppLocalizations.of(context)!.permanentLock,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      value: RfidLockMode.permanentLock,
                                      groupValue: _viewModel.lockMode.value,
                                      onChanged: (value) {
                                        if (value != null) {
                                          _viewModel.lockMode.value = value;
                                        }
                                      },
                                      activeColor: Colors.orange,
                                      contentPadding: EdgeInsets.zero,
                                      dense: true,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  ),
                                ],
                              ),
                              // Second row: Unlock and Permanent Unlock
                              Row(
                                children: [
                                  Flexible(
                                    flex: 2,
                                    child: RadioListTile<RfidLockMode>(
                                      title: Text(
                                        AppLocalizations.of(context)!.unlock,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      value: RfidLockMode.unlock,
                                      groupValue: _viewModel.lockMode.value,
                                      onChanged: (value) {
                                        if (value != null) {
                                          _viewModel.lockMode.value = value;
                                        }
                                      },
                                      activeColor: Colors.orange,
                                      contentPadding: EdgeInsets.zero,
                                      dense: true,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  ),
                                  Flexible(
                                    flex: 3,
                                    child: RadioListTile<RfidLockMode>(
                                      title: Text(
                                        AppLocalizations.of(context)!.permanentUnlock,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      value: RfidLockMode.permanentUnlock,
                                      groupValue: _viewModel.lockMode.value,
                                      onChanged: (value) {
                                        if (value != null) {
                                          _viewModel.lockMode.value = value;
                                        }
                                      },
                                      activeColor: Colors.orange,
                                      contentPadding: EdgeInsets.zero,
                                      dense: true,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }),

                        const SizedBox(height: 10.0),

                        // Lock Banks Selection
                        Watch.builder(builder: (context) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.banksToLock,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 8.0),
                              // Use Wrap for automatic line wrapping
                              Wrap(
                                spacing: 8.0,
                                runSpacing: 4.0,
                                children: RfidLockBank.values.map((bank) {
                                  final isSelected = _viewModel.lockBanks.value.contains(bank);
                                  return SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.28, // Approximately 3 items per row
                                    child: CheckboxListTile(
                                      title: Text(bank.description, style: const TextStyle(fontSize: 14)),
                                      value: isSelected,
                                      onChanged: (value) {
                                        final currentBanks = List<RfidLockBank>.from(_viewModel.lockBanks.value);
                                        if (value == true) {
                                          if (!currentBanks.contains(bank)) {
                                            currentBanks.add(bank);
                                          }
                                        } else {
                                          currentBanks.remove(bank);
                                        }
                                        _viewModel.lockBanks.value = currentBanks;
                                      },
                                      controlAffinity: ListTileControlAffinity.leading,
                                      dense: true,
                                      contentPadding: EdgeInsets.zero,
                                      activeColor: Colors.orange,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          );
                        }),

                        const SizedBox(height: 16.0),

                        // Lock Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _viewModel.lockTag,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.lockTag,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildKillSection() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.red.shade300),
        color: Colors.red.shade50,
      ),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Watch.builder(builder: (context) {
            return InkWell(
              onTap: () {
                isKillSectionExpanded.value = !isKillSectionExpanded.value;
              },
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red.shade600),
                  const SizedBox(width: 8.0),
                  Text(
                    AppLocalizations.of(context)!.killTag,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red.shade600),
                  ),
                  const Expanded(child: SizedBox.shrink()),
                  AnimatedRotation(
                    turns: isKillSectionExpanded.value ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade500),
                  ),
                ],
              ),
            );
          }),

          // Expandable content
          Watch.builder(builder: (context) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: isKillSectionExpanded.value ? null : 0,
              child: isKillSectionExpanded.value
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16.0),
                        Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.0),
                            color: Colors.red.shade100,
                            border: Border.all(color: Colors.red.shade300),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.warning_amber, color: Colors.red.shade700),
                              const SizedBox(width: 8.0),
                              Expanded(
                                child: Text(
                                  AppLocalizations.of(context)!.warningKillTag,
                                  style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w500, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16.0),

                        // Kill Password Input
                        TextFormField(
                          controller: _killPasswordController,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.killPassword,
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                            isDense: true,
                            hintText: AppLocalizations.of(context)!.cantUseDefaultPassword,
                          ),
                          maxLength: 8,
                        ),

                        const SizedBox(height: 10.0),

                        // Kill Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _viewModel.killTag,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.killTag,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            );
          }),
        ],
      ),
    );
  }
}
