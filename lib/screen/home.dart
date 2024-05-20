import 'package:flutter/material.dart';
import 'package:mind_balance/provider/service_provider.dart';
import 'package:mind_balance/screen/result_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _moodController = TextEditingController();
  final TextEditingController _sleepHourController = TextEditingController();
  final TextEditingController _stressLevelController = TextEditingController();

  List<String> moodData = [
    "Happy",
    "Hopeful",
    "Worried",
    "Stressed",
    "Sad",
    "Angry",
  ];

  String? currentMood;
  @override
  void dispose() {
    _moodController.dispose();
    _sleepHourController.dispose();
    _stressLevelController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mind balance',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                  "Track your mental wellbeing and take control of your happiness. Share your mood, sleep, and stress levels to gain valuable insights and receive personalized recommendations for a healthier mind."),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    "How are you feeling today?:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
              _showMoodCard(),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _sleepHourController,
                decoration:
                    const InputDecoration(hintText: "Average sleeping hours"),
              ),
              const SizedBox(
                height: 40,
              ),
              TextFormField(
                controller: _stressLevelController,
                decoration:
                    const InputDecoration(hintText: "Stress level (1-10)"),
              ),
              const SizedBox(
                height: 40,
              ),
              Consumer<ServiceProvider>(builder: (context, val, _) {
                return ElevatedButton(
                  onPressed: () {
                    context.read<ServiceProvider>().getHealthResponse(
                        mood: _moodController.text,
                        sleepHour: _sleepHourController.text,
                        stressLevel: _stressLevelController.text);
                  },
                  child: Text(
                    val.networkState == NetworkState.loading
                        ? "Loading..."
                        : "Start Tracking",
                  ),
                );
              }),
              const SizedBox(
                height: 40,
              ),
              Consumer<ServiceProvider>(builder: (context, val, _) {
                if (val.networkState == NetworkState.loaded) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ResultPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "View Results",
                    ),
                  );
                }

                return const SizedBox();
              }),
            ],
          ),
        ),
      ),
    );
  }

  _showMoodCard() {
    return Wrap(
      spacing: 5,
      runSpacing: 10,
      children: moodData.map<Widget>((mood) {
        return InkWell(
            onTap: () {
              setState(() {
                currentMood = mood;
              });
            },
            child: Card(
              color: mood == currentMood
                  ? Theme.of(context).colorScheme.inversePrimary
                  : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  mood,
                  style: TextStyle(
                    color: mood == currentMood ? Colors.white : Colors.purple,
                  ),
                ),
              ),
            ));
      }).toList(),
    );
  }
}
