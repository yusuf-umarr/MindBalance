
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mind_balance/provider/service_provider.dart';
import 'package:mind_balance/widget/animation.dart';
import 'package:mind_balance/screen/result_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<String> moodData = [
    "Happy",
    "Hopeful",
    "Worried",
    "Stressed",
    "Sad",
    "Angry",
  ];

  String title =
      "Track your mental wellbeing and take control of your happiness. Share your mood, sleep, and stress levels to gain valuable insights and receive personalized recommendations for a healthier mind.";

  String? currentMood;
  double averageSleep = 0.0;
  double stressLevel = 0.0;
 

  String getSliderVal(double input) {
    double avValue = input / 10;
    String outputVal = avValue.toStringAsFixed(0);

    return outputVal;
  }

  bool isOpacity = false;

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
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: AnimatedWidgetContainer(
            data: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Track your mental wellbeing and take control of your happiness. Share your mood, sleep, and stress levels to gain valuable insights and receive personalized recommendations for a healthier mind.",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
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
                Row(
                  children: [
                    Text(
                      "Average sleeping hours: ${getSliderVal(averageSleep)} hours",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: CupertinoSlider(
                    min: 0.0,
                    max: 100.0,
                    value: averageSleep,
                    onChanged: (value) {
                      setState(() {
                        averageSleep = value;
                      });
                      context
                          .read<ServiceProvider>()
                          .setNetworkState(NetworkState.idle);
                    },
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    Text(
                      "Stress level : ${getSliderVal(stressLevel)}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: CupertinoSlider(
                    min: 0.0,
                    max: 100.0,
                    value: stressLevel,
                    onChanged: (value) {
                      setState(() {
                        stressLevel = value;
                      });
                      context
                          .read<ServiceProvider>()
                          .setNetworkState(NetworkState.idle);
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
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

                  return Consumer<ServiceProvider>(
                    builder: (context, val, _) {
                      return ElevatedButton(
                        onPressed: () {
                          if (currentMood != null && averageSleep != 0.0) {
                            val.setMood(currentMood!);
                            val.setAverageSleep(getSliderVal(averageSleep));
                            val.setStressLevel(getSliderVal(stressLevel));
                            
                            val.getHealthResponse(
                                  mood: currentMood!,
                                  sleepHour: getSliderVal(averageSleep),
                                  stressLevel: getSliderVal(stressLevel),
                                );
                          }
                        },
                        child: val.networkState == NetworkState.loading
                            ? const CupertinoActivityIndicator()
                            : Text(
                                "Start Tracking",
                                style: TextStyle(
                                  color:
                                      (currentMood != null && averageSleep != 0.0)
                                          ? Colors.purple
                                          : Colors.grey,
                                ),
                              ),
                      );
                    }
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showMoodCard() {
    return Wrap(
      spacing: 5,
      runSpacing: 10,
      children: List.generate(
        moodData.length,
        (index) {
          return InkWell(
            onTap: () {
              setState(() {
                currentMood = moodData[index];
              });
              context
                  .read<ServiceProvider>()
                  .setNetworkState(NetworkState.idle);
            },
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(seconds: 1),
              builder: (BuildContext context, double val, Widget? child) {
                return Opacity(
                  opacity: val == 1 ? 1 : 0,
                  child: Padding(
                    padding: EdgeInsets.only(top: val * 20),
                    child: child,
                  ),
                );
              },
              child: Card(
                color: moodData[index] == currentMood
                    ? Theme.of(context).colorScheme.inversePrimary
                    : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    moodData[index],
                    style: TextStyle(
                      color: moodData[index] == currentMood
                          ? Colors.white
                          : Colors.purple,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
