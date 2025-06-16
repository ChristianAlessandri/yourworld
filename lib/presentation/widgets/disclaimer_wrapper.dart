import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisclaimerWrapper extends StatefulWidget {
  final Widget child;

  const DisclaimerWrapper({super.key, required this.child});

  @override
  State<DisclaimerWrapper> createState() => _DisclaimerWrapperState();
}

class _DisclaimerWrapperState extends State<DisclaimerWrapper> {
  @override
  void initState() {
    super.initState();
    _checkDisclaimer();
  }

  Future<void> _checkDisclaimer() async {
    final prefs = await SharedPreferences.getInstance();
    final shown = prefs.getBool('disclaimer_shown') ?? false;

    if (!shown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showDisclaimerDialog();
        }
      });
    }
  }

  void _showDisclaimerDialog() {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Disclaimer & Liability Notice",
              style: Theme.of(context).textTheme.titleLarge),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "🔒 Your data is stored exclusively on your device. Nothing is uploaded to the cloud or external servers.",
                    style: Theme.of(context).textTheme.bodyMedium),
                SizedBox(height: 12),
                Text(
                    "⚠️ Liability Disclaimer: This app is provided 'as is' with no guarantees. The developer is not responsible for any data loss or damage resulting from its use.",
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('disclaimer_shown', true);
                // ignore: use_build_context_synchronously
                if (mounted) Navigator.pop(context);
              },
              child: Text("I Understand"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
