import 'package:flutter/material.dart';
import 'package:mind_balance/provider/service_provider.dart';
import 'package:mind_balance/widget/dialog.dart';
import 'package:provider/provider.dart';

class ResultPage extends StatefulWidget {
  final String mood;
  final String stressLevel;
  final String sleepHour;

  const ResultPage({
    Key? key,
    required this.mood,
    required this.stressLevel,
    required this.sleepHour,
  }) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isAtBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  showDialogPop() {
    context.read<ServiceProvider>().setQuoteState(QuoteState.idle);
    if (_isAtBottom) {
      Future.delayed(const Duration(seconds: 1), () {
        showQuoteDialog(context);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    setState(() {
      _isAtBottom = currentScroll >= maxScroll - 100;
    });
  }

  void showQuoteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogWidget(widget: widget);
      },
    );
  }

  RichText formattedText(String text) {
    final RegExp regExp = RegExp(r'\*\*\s*(.*?)\s*\*\*');
    List<TextSpan> spans = [];

    text.splitMapJoin(
      regExp,
      onMatch: (Match match) {
        spans.add(TextSpan(
          text: match.group(1),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ));
        return match.group(0) ?? '';
      },
      onNonMatch: (String nonMatch) {
        spans.add(TextSpan(
          text: nonMatch,
        ));
        return nonMatch;
      },
    );

    return RichText(
      text: TextSpan(
        children: spans,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ServiceProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Result and recommendation",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification) {
            _scrollListener();
            showDialogPop();
          }
          return false;
        },
        child: ListView(
          controller: _scrollController,
          padding: const EdgeInsets.all(20),
          children: [
            formattedText(provider.testResponseData!),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
