import 'package:flutter/material.dart';

class WaitDialog {
  final BuildContext context;

  WaitDialog(this.context);

  show() {
    return showDialog(
      context: context,
      builder: (context) => const CloudWaitDialog(),
    );
  }

  dispose() {
    if (!context.mounted) return;
    Navigator.pop(context);
  }
}

class CloudWaitDialog extends StatefulWidget {
  const CloudWaitDialog({super.key});

  @override
  State<CloudWaitDialog> createState() => _CloudWaitDialogState();
}

class _CloudWaitDialogState extends State<CloudWaitDialog> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: FittedBox(
          child: Image.asset(
            "assets/loaders/loader_dots.gif",
            color: Theme.of(context).colorScheme.onSecondaryContainer,
            height: 180,
            width: 180,
          ),
        ),
      ),
    );
  }
}
