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

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "MindBalance quotes",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
            Consumer<ServiceProvider>(builder: (context, val, _) {
              return ElevatedButton(
                onPressed: () {
                  val.getQoutes(
                    mood: val.selectedMood,
                    stressLevel: val.stressLevel,
                    sleepHour: val.averageSleep,
                  );
                },
                child: const Text(
                  "see more quotes",
                ),
              );
            })
        ],
      ),
    );
  }
}
