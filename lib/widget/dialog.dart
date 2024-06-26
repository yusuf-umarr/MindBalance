import 'package:flutter/material.dart';
import 'package:mind_balance/provider/service_provider.dart';
import 'package:mind_balance/screen/quote_page.dart';
import 'package:mind_balance/screen/result_page.dart';
import 'package:provider/provider.dart';

class DialogWidget extends StatefulWidget {
  const DialogWidget({
    super.key,
    required this.widget,
  });

  final ResultPage widget;

  @override
  State<DialogWidget> createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('MindBalance'),
      content: const Text('Do you want some mind balance quotes?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('No'),
        ),
        Consumer<ServiceProvider>(
          builder: (context, val, _) {
            return TextButton(
              onPressed: () async {
                val.getQoutes(
                  mood: val.selectedMood,
                  stressLevel: val.stressLevel,
                  sleepHour: val.averageSleep,
                );
                Navigator.of(context).pop();
            
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  QuotePage(widget: widget.widget,),
                  ),
                );
              },
              child: const Text('Yes'),
            );
          }
        ),
      ],
    );
  }
}
