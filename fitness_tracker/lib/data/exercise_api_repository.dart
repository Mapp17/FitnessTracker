import 'package:dio/dio.dart';
import 'package:fitness_tracker/data/models/api_exercise.dart';

class ExerciseApiRepository {
  // 1
  final Dio _dio = Dio();

  //2
  static const String _baseUrl = 'https://api.api-ninjas.com/v1/exercises';
  static const String _apiKey = '4PVRn9qboLZas3nTVuGsUsZdVAoojo08khZM5c7O';


  Future<List<ApiExercise>> searchExercises(String muscle) async {
    try {
      // 3
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {'muscle': muscle},
        options: Options(
          headers: {'X-Api-Key': _apiKey},
        ),
      );

      // 4
      final List<dynamic> data = response.data;
      
      // 5
      return data.map((json) => ApiExercise.fromJson(json as Map<String, dynamic>)).toList();
      
    } on DioException catch (e) {
      // 6
      if (e.type == DioExceptionType.connectionTimeout || 
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Connection timed out. Check your internet.');
      }

      if (e.response != null) {
        if (e.response?.statusCode == 401) {
          throw Exception('Invalid API key. Check your API Ninjas key.');
        } else if (e.response?.statusCode == 429) {
          throw Exception('Rate limit exceeded. Wait a moment and try again.');
        } else {
          throw Exception('Server error: ${e.response?.statusCode}');
        }
      } else {
        throw Exception('No internet connection.');
      }
    } catch (e) {
      throw Exception('Failed to load exercises: $e');
    }
  }
}
