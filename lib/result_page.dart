// Suggested code may be subject to a license. Learn more: ~LicenseLog:1197157839.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:931832322.
import 'package:flutter/material.dart';
import 'package:myapp/provider/service_provider.dart';
import 'package:provider/provider.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ServiceProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text("Result and recommendation"),),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            "${provider.responseData}",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
