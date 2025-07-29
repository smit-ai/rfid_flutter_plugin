import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import '../view_model/inventory_view_model.dart';
import '../widget/filter_widget.dart';
import '../entity/app_global_state.dart';

class InventoryView extends StatefulWidget {
  const InventoryView({super.key});

  @override
  State<InventoryView> createState() => _InventoryViewState();
}

class _InventoryViewState extends State<InventoryView> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final InventoryViewModel _viewModel;

  late final TextEditingController _durationController;

  @override
  void initState() {
    super.initState();
    _viewModel = InventoryViewModel();
    _durationController = TextEditingController(text: _viewModel.duration.value.toString());
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // print('inventory build');

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          FilterWidget(filter: _viewModel.filter.value),
          _buildButtons(),
          _buildTimeSection(),
          _buildTagList(),
        ],
      ),
    );
  }

  /// 构建按钮区域
  Widget _buildButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => _viewModel.clearData(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 4),
            ),
            child: const Text('Clear', style: TextStyle(fontSize: 16)),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: ElevatedButton(
            onPressed: () => _viewModel.singleInventory(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 4),
            ),
            child: const Text('Single', style: TextStyle(fontSize: 16)),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: ElevatedButton(
            onPressed: () => _viewModel.inventoryToggle(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 4),
            ),
            child: Watch.builder(builder: (context) {
              return Text(
                _viewModel.isInventoryRunning.watch(context) ? 'Stop' : 'Inventory',
                style: const TextStyle(fontSize: 16),
              );
            }),
          ),
        ),
      ],
    );
  }

  /// 构建时间设置区域
  Widget _buildTimeSection() {
    return Row(
      children: [
        Watch.builder(builder: (context) {
          final unique = _viewModel.unique.watch(context);
          return GestureDetector(
            onTap: () => _viewModel.unique.value = !_viewModel.unique.value,
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
              child: Row(
                children: [
                  Checkbox(
                    value: unique,
                    onChanged: (value) => _viewModel.unique.value = value ?? false,
                    // activeColor: Colors.blue,
                    visualDensity: VisualDensity.standard,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  const Text('Unique'),
                ],
              ),
            ),
          );
        }),
        const SizedBox(width: 10),
        const Text("Duration: "),
        SizedBox(
          width: 80,
          height: 40,
          child: TextFormField(
            controller: _durationController,
            decoration: const InputDecoration(
              // border: OutlineInputBorder(),
              contentPadding: EdgeInsets.only(top: 8, left: 4),
              hintText: "999999",
              isDense: true,
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              _viewModel.duration.value = value;
            },
          ),
        ),
        const Text("(s)"),
        const SizedBox(width: 20),
        // const Text("Time: "),
        Watch.builder(builder: (context) {
          return Text(
            _viewModel.inventoryTime.watch(context).toStringAsFixed(1),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          );
        }),
        const Text(" s"),
      ],
    );
  }

  /// 构建标签列表区域
  Widget _buildTagList() {
    return Expanded(
      child: Column(
        children: [
          //  Header Info  表头信息
          Container(
            padding: const EdgeInsets.fromLTRB(8, 6, 2, 6),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('Tag: '),
                    Watch.builder(
                      builder: (context) {
                        return SizedBox(
                          width: 70,
                          child: Text(
                            _viewModel.tagCount.watch(context).toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        );
                      },
                    ),
                    const Text('All: '),
                    Watch.builder(
                      builder: (context) {
                        return Text(
                          _viewModel.allCount.watch(context).toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        );
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      constraints: const BoxConstraints(minWidth: 50),
                      alignment: Alignment.center,
                      child: const Text("Count"),
                    ),
                    if (!appState.isHandset.value)
                      Container(
                        margin: const EdgeInsets.only(left: 4),
                        constraints: const BoxConstraints(minWidth: 50),
                        alignment: Alignment.center,
                        child: const Text("Antenna"),
                      ),
                    Container(
                      constraints: const BoxConstraints(minWidth: 50),
                      alignment: Alignment.center,
                      child: const Text("Rssi"),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Tag List 标签列表
          Watch.builder(
            builder: (context) {
              // 监听 lastUpdateTimestamp 以触发UI更新
              _viewModel.lastUpdateTimestamp.watch(context);
              //print("updateTagListUI  $lastUpdateTimestamp");
              return Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: ListView.separated(
                    itemCount: _viewModel.tagList.length,
                    separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade300),
                    itemBuilder: (context, index) {
                      final tag = _viewModel.tagList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        child: Row(
                          children: [
                            // 标签信息部分
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (tag.reserved.isNotEmpty) Text('RESERVED: ${tag.reserved}'),
                                  Text('${tag.tid.isEmpty && tag.reserved.isEmpty ? tag.epc : 'EPC: ${tag.epc}'} '),
                                  if (tag.tid.isNotEmpty) Text('TID: ${tag.tid}'),
                                  if (tag.user.isNotEmpty) Text('USER: ${tag.user}'),
                                ],
                              ),
                            ),
                            // Count
                            Container(
                              constraints: const BoxConstraints(minWidth: 50),
                              alignment: Alignment.center,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              child: Text(tag.count.toString()),
                            ),
                            if (!appState.isHandset.value)
                              Container(
                                constraints: const BoxConstraints(minWidth: 50),
                                alignment: Alignment.center,
                                child: Text(tag.antenna.toString()),
                              ),
                            // RSSI
                            Container(
                              constraints: const BoxConstraints(minWidth: 50),
                              alignment: Alignment.center,
                              child: Text(tag.rssi.toString()),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
