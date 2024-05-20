// import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
// import 'package:http/http.dart' as http;
import 'package:myapp/config/config.dart';

enum NetworkState {
  idle,
  loading,
  loaded,
  error,
}

class ServiceProvider extends ChangeNotifier {

  String? responseData;

  NetworkState networkState = NetworkState.idle;

  void setNetworkState(NetworkState state) {
    networkState = state;
    notifyListeners();
  }



  Future<void> getHealthResponse({ String mood="", String sleepHour="", String stressLevel="",} ) async {
            setNetworkState(NetworkState.loading);

    try {
        final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

        final prompt = """I am developing a health tracker app that takes into account various user inputs to assess their current health state and provide personalized recommendations. Based on the user's inputs: Mood: 
        $mood, Average sleep duration: $sleepHour hours,
        Stress Levels: $stressLevel out of 10.
        Use the above input to state their current health status, and make necessary recommendations the recommendations should include self awareness, coping mechanism(such as meditation), mental well-being""";
        final content = [Content.text(prompt)];
        final response = await model.generateContent(content);

        responseData = response.text;
        notifyListeners();

        setNetworkState(NetworkState.loaded);
      

        log("Response:${response.text!}");
      
    } catch (e) {
      
    }
  
  }
}
