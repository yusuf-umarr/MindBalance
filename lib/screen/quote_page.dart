import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mind_balance/provider/service_provider.dart';
import 'package:mind_balance/screen/result_page.dart';
import 'package:provider/provider.dart';

class QuotePage extends StatefulWidget {
  final ResultPage widget;
  const QuotePage({
    super.key,
    required this.widget,
  });

  @override
  State<QuotePage> createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {
  List<Widget> _buildQuoteWidgets(String input) {
    List<String> quotes = input.trim().split('\n');
    List<Widget> quoteWidgets = [];

    for (String quote in quotes) {
      String cleanedQuote = quote.replaceFirst(RegExp(r'^\d+\.\s*'), '').trim();

      quoteWidgets.add(
        Container(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            cleanedQuote,
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
      );
    }

    return quoteWidgets;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ServiceProvider>();

    log("${provider.qouteResponseData}");
    return Scaffold(
      appBar: AppBar(
        title: const Text("MindBalance quotes"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (provider.quoteState == QuoteState.loading)
            const Center(
              child: CircularProgressIndicator(),
            )
          else
            Column(
              children: _buildQuoteWidgets(provider.qouteResponseData!),
            ),
          const SizedBox(
            height: 20,
          ),
          if (provider.quoteState == QuoteState.loaded)
            ElevatedButton(
              onPressed: () {
                context.read<ServiceProvider>().getQoutes(
                      mood: widget.widget.mood,
                      stressLevel: widget.widget.stressLevel,
                      sleepHour: widget.widget.sleepHour,
                    );
              },
              child: const Text(
                "see more quotes",
              ),
            )
        ],
      ),
    );
  }
}
