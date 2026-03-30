import 'package:dio/dio.dart';
import 'package:fitness_tracker/data/models/api_exercise.dart';

class ExerciseApiRepository {
  final Dio _dio = Dio();

  static const String _baseUrl = 'https://api.api-ninjas.com/v1/exercises';
  static const String _apiKey = '4PVRn9qboLZas3nTVuGsUsZdVAoojo08khZM5c7O';

  /// Updated search method to support multiple filters.
  Future<List<ApiExercise>> searchExercises({
    String? muscle,
    String? type,
    String? difficulty,
    String? name,
  }) async {
    try {
      // Build query parameters dynamically
      final Map<String, dynamic> queryParams = {};
      if (muscle != null && muscle.isNotEmpty) queryParams['muscle'] = muscle;
      if (type != null && type.isNotEmpty) queryParams['type'] = type;
      if (difficulty != null && difficulty.isNotEmpty) queryParams['difficulty'] = difficulty;
      if (name != null && name.isNotEmpty) queryParams['name'] = name;

      final response = await _dio.get(
        _baseUrl,
        queryParameters: queryParams,
        options: Options(
          headers: {'X-Api-Key': _apiKey},
        ),
      );

      final List<dynamic> data = response.data;
      return data.map((json) => ApiExercise.fromJson(json as Map<String, dynamic>)).toList();
      
    } on DioException catch (e) {
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
