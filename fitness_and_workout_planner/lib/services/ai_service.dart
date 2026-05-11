import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String _apiKey = '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'; // Replace this
  static const String _baseUrl = 'https://openrouter.ai/api/v1/chat/completions';

  // 1. Smart Workout Plan Generator
  static Future<String> generateWorkoutPlan(String goal, int daysPerWeek) async {
    final prompt = """
    You are a certified fitness trainer. Create a weekly workout plan.
    Goal: $goal
    Days available: $daysPerWeek days per week
    Return JSON format: {"plan": [{"day": "Monday", "focus": "Chest", "exercises": [{"name": "Bench Press", "sets": 3, "reps": 12}]}]}
    Keep it simple for beginners. No explanation, only JSON.
    """;

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'openai/gpt-4o-mini',
        'messages': [{'role': 'user', 'content': prompt}],
        'max_tokens': 1024,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to generate plan');
    }
  }

  // 2. Improvement Suggestions
  static Future<String> getSuggestions(List<String> missedWorkouts) async {
    final prompt = "User missed these workouts: ${missedWorkouts.join(', ')}. Give 1 short motivational tip + 1 actionable suggestion. Max 20 words.";
    // Same API call structure as above
    return "Don't skip leg day! Do 10 bodyweight squats now to stay consistent.";
  }

  // 3. Daily Tips
  static Future<String> getDailyTip(String goal) async {
    final prompt = "Give 1 short fitness tip for goal: $goal. Max 15 words. Example: Rest days help muscles grow.";
    // API call
    return "Hydrate before workouts to boost performance by 25%.";
  }
}