import 'package:flutter/material.dart';
import 'package:myapp/provider/service_provider.dart';
import 'package:myapp/result_page.dart';
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
        title: const Text('Stay on track'),
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
             const Text("Track your mental wellbeing and take control of your happiness. Share your mood, sleep, and stress levels to gain valuable insights and receive personalized recommendations for a healthier mind."),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _moodController,
                decoration: const InputDecoration(hintText: "Mood"),
              ),
              const SizedBox(
                height: 40,
              ),
              TextFormField(
                controller: _sleepHourController,
                decoration: const InputDecoration(hintText: "Av. Sleep duration"),
              ),
              const SizedBox(
                height: 40,
              ),
              TextFormField(
                controller: _stressLevelController,
                decoration: const InputDecoration(hintText: "Stress level"),
              ),
              const SizedBox(
                height: 40,
              ),
              Consumer<ServiceProvider>(
                builder: (context, val, _) {
                  return ElevatedButton(
                      onPressed: () {
                        context.read<ServiceProvider>().getHealthResponse(
                          mood: _moodController.text, 
                          sleepHour: _sleepHourController.text, 
                          stressLevel: _stressLevelController.text
                        );
                      },
                      child: Text(val.networkState == NetworkState.loading ? "Loading..." : "Start Tracking",),);
                }
              ),
              const SizedBox(
                height: 40,
              ),
              Consumer<ServiceProvider>(
                builder: (context, val, _) {
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
                      child: const Text( "View Results",),);
                  }

                  return const SizedBox();
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
