import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gpa_calculator/core/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AiAdvisorRemoteDataSource {
  Future<String> getAiAnalysis(String prompt);
  Future<void> incrementAiUsage(String userId);
}

class AiAdvisorRemoteDataSourceImpl implements AiAdvisorRemoteDataSource {
  final SupabaseClient _supabaseClient;
  static const String _model = 'google/gemma-4-31b-it:free';
  static const String _url = 'https://openrouter.ai/api/v1/chat/completions';

  AiAdvisorRemoteDataSourceImpl(this._supabaseClient);

  @override
  Future<String> getAiAnalysis(String prompt) async {
    final apiKey = dotenv.env['OPENROUTER_API_KEY'];
    if (apiKey == null) {
      throw Exception('OpenRouter API key is missing.');
    }

    final response = await http.post(
      Uri.parse(_url),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
        'HTTP-Referer': 'https://gpa-calculator-app.com',
        'X-Title': 'GPA Calculator',
      },
      body: jsonEncode({
        'model': _model,
        'messages': [
          {
            'role': 'system',
            'content': 'You are an expert Academic Advisor. Your goal is to help the student optimize their GPA and plan their studies. Be concise, encouraging, and highly analytical.',
          },
          {'role': 'user', 'content': prompt},
        ],
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final content = jsonResponse['choices'][0]['message']['content'];
      return content as String;
    } else {
      throw Exception('Failed to generate AI analysis: ${response.body}');
    }
  }

  @override
  Future<void> incrementAiUsage(String userId) async {
    final data = await _supabaseClient
        .from('profiles')
        .select('ai_usage_count')
        .eq('id', userId)
        .single();

    int currentCount = data['ai_usage_count'] as int? ?? 0;

    await _supabaseClient
        .from('profiles')
        .update({'ai_usage_count': currentCount + 1})
        .eq('id', userId);
  }
}
