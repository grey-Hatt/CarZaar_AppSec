import '../models/car_model.dart';
import 'supabase_service.dart';

class CarService {
  final _client = SupabaseService.client;

  Future<String?> addCar(CarModel car) async {
    try {
      await _client.from('cars').insert(car.toJson());
      return null;
    } catch (e) {
      return "Failed to add car: $e";
    }
  }

  Future<List<CarModel>> getSellerCars(String sellerId) async {
    try {
      final response = await _client
          .from('cars')
          .select()
          .eq('seller_id', sellerId)
          .order('created_at', ascending: false);

      return response.map<CarModel>((json) {
        return CarModel.fromJson(json);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<CarModel>> getAllActiveCars() async {
    try {
      final response = await _client
          .from('cars')
          .select()
          .eq('status', 'active')
          .order('is_featured', ascending: false)
          .order('created_at', ascending: false);

      return response.map<CarModel>((json) {
        return CarModel.fromJson(json);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<String?> updateCar(CarModel car) async {
    try {
      await _client.from('cars').update(car.toJson()).eq('id', car.id!);
      return null;
    } catch (e) {
      return "Failed to update car: $e";
    }
  }

  Future<String?> deleteCar(String carId) async {
    try {
      await _client.from('cars').update({
        'status': 'removed',
      }).eq('id', carId);

      return null;
    } catch (e) {
      return "Failed to delete car: $e";
    }
  }
}