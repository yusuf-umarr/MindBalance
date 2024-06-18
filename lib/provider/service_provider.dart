import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mind_balance/config/config.dart';

enum NetworkState {
  idle,
  loading,
  loaded,
  error,
}

enum QuoteState {
  idle,
  loading,
  loaded,
  error,
}

class ServiceProvider extends ChangeNotifier {
  String? testResponseData;
  String? qouteResponseData;

  String _selectedMood ='';
  String get selectedMood => _selectedMood;
  String _averageSleep ='';
  String get averageSleep => _averageSleep;
  String _stressLevel ='';
  String get stressLevel => _stressLevel;

  NetworkState networkState = NetworkState.idle;

  void setNetworkState(NetworkState state) {
    networkState = state;
    notifyListeners();
  }

  QuoteState quoteState = QuoteState.idle;

  void setQuoteState(QuoteState state) {
    quoteState = state;
    notifyListeners();
  }

  void setMood(mood){
    _selectedMood =mood;
    notifyListeners(); 
  }
  void setAverageSleep(sleep){
    _averageSleep =sleep;
    notifyListeners(); 
  }
  void setStressLevel(stress){
    _stressLevel =stress;
    notifyListeners(); 
  }

  Future<void> getHealthResponse({
    String mood = "",
    String sleepHour = "",
    String stressLevel = "",
  }) async {
 
    setNetworkState(NetworkState.loading);
    try {
      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
      //gemini-pro

      final prompt =
          """I am developing a health tracker app that takes into account various user inputs to assess their current health state and provide personalized recommendations. Based on the user's inputs: Mood: 
        $mood, Average sleep duration: $sleepHour hours,
        Stress Levels: $stressLevel out of 10.
        Use the above input to state their current health status, and make necessary recommendations the recommendations should include self awareness, coping mechanism(such as meditation), mental well-being""";
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      testResponseData = response.text;
      notifyListeners();
      setNetworkState(NetworkState.loaded);
    } catch (e) {
       setNetworkState(NetworkState.error);
      log("Error res:$e");
    }
  }

  Future<void> getQoutes({
    String mood = "",
    String sleepHour = "",
    String stressLevel = "",
  }) async {
    setQuoteState(QuoteState.loading);
    try {
      final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

      final prompt =
          """I am developing a health tracker app that takes into account various user inputs to assess their current health state and provide personalized recommendations. Based on the user's inputs: Mood: 
        $mood, Average sleep duration: $sleepHour hours,
        Stress Levels: $stressLevel out of 10.
        Use the above input to provide 5 different Inspirational quotes or a health pick up line that can help the user in this situation, hint: only shoe the quote and the author and dont show the meaning """;
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      qouteResponseData = response.text;
      notifyListeners();
      setQuoteState(QuoteState.loaded);
    } catch (e) {
      log("Error res:$e");
    }
  }
}
