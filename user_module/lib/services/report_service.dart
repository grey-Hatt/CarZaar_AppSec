import '../models/report_model.dart';
import 'supabase_service.dart';

class ReportService {
  final _client = SupabaseService.client;

  Future<String?> submitReport(ReportModel report) async {
    try {
      await _client.from('reports').insert(report.toJson());
      return null;
    } catch (e) {
      return "Failed to submit report: $e";
    }
  }

  Future<List<Map<String, dynamic>>> getReportsAgainstSeller(
    String sellerId,
  ) async {
    try {
      final sellerCars = await _client
          .from('cars')
          .select('id')
          .eq('seller_id', sellerId);

      final carIds = sellerCars.map((c) => c['id']).toList();

      if (carIds.isEmpty) return [];

      final reports = await _client
          .from('reports')
          .select()
          .inFilter('car_id', carIds)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(reports);
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>?> getUserById(String userId) async {
    try {
      return await _client
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();
    } catch (e) {
      return null;
    }
  }

  Future<List<ReportModel>> getMyReports(String userId) async {
    try {
      final response = await _client
          .from('reports')
          .select()
          .eq('reported_by', userId)
          .order('created_at', ascending: false);

      return response.map<ReportModel>((json) {
        return ReportModel.fromJson(json);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>?> getCarById(String carId) async {
    try {
      return await _client.from('cars').select().eq('id', carId).maybeSingle();
    } catch (e) {
      return null;
    }
  }
}
