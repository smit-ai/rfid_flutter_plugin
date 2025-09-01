import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rfid_flutter_android/rfid_flutter_android.dart';

class DeviceInfoView extends StatefulWidget {
  const DeviceInfoView({super.key});

  @override
  State<DeviceInfoView> createState() => _DeviceInfoViewState();
}

class _DeviceInfoViewState extends State<DeviceInfoView> {
  late Future<Map<String, dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadDeviceInfo();
  }

  Future<Map<String, dynamic>> _loadDeviceInfo() async {
    final result = await RfidWithDeviceInfo.instance.getDeviceInfo();
    if (result.result && result.data != null) {
      return result.data!;
    }
    throw Exception(result.error ?? 'Unknown error');
  }

  void _refresh() {
    setState(() {
      _future = _loadDeviceInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const maxDialogWidth = 430.0;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // const Icon(Icons.info_outline),
            // const SizedBox(width: 8),
            Text(l10n.deviceInfo),
            const Spacer(),
            IconButton(
              tooltip: l10n.refresh,
              onPressed: _refresh,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: maxDialogWidth,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: FutureBuilder<Map<String, dynamic>>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 120,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return _ErrorView(
                  message: snapshot.error.toString(),
                  onRetry: _refresh,
                );
              }
              final data = snapshot.data ?? const {};
              final serial = (data['serialNumber'] ?? '') as String;
              final imei1 = (data['imei1'] ?? '') as String;
              final imei2 = (data['imei2'] ?? '') as String;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _InfoTile(
                    icon: Icons.confirmation_number_outlined,
                    label: l10n.serialNumber,
                    value: serial.isEmpty ? '-' : serial,
                  ),
                  const SizedBox(height: 10),
                  _InfoTile(
                    icon: Icons.phone_iphone,
                    label: l10n.imei1,
                    value: imei1.isEmpty ? '-' : imei1,
                  ),
                  const SizedBox(height: 10),
                  _InfoTile(
                    icon: Icons.phone_android,
                    label: l10n.imei2,
                    value: imei2.isEmpty ? '-' : imei2,
                  ),
                  const SizedBox(height: 10),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade50,
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueGrey),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                ),
                const SizedBox(height: 4),
                SelectableText(
                  value,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.error_outline, color: Colors.red, size: 40),
        const SizedBox(height: 8),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.red),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: Text(AppLocalizations.of(context)!.retry),
        ),
      ],
    );
  }
}
