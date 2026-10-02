import '../models/bid_model.dart';
import 'supabase_service.dart';

class BidService {
  final _client = SupabaseService.client;

  Future<String?> placeBid(BidModel bid) async {
    try {
      final existingBid = await _client
          .from('bids')
          .select()
          .eq('car_id', bid.carId)
          .eq('buyer_id', bid.buyerId)
          .neq('bid_status', 'withdrawn')
          .maybeSingle();

      if (existingBid != null) {
        return "You already placed a bid on this car. Edit your bid instead.";
      }

      await _client.from('bids').insert(bid.toJson());
      return null;
    } catch (e) {
      return "Failed to place bid: $e";
    }
  }

  Future<List<BidModel>> getBuyerBids(String buyerId) async {
    try {
      final response = await _client
          .from('bids')
          .select()
          .eq('buyer_id', buyerId)
          .order('created_at', ascending: false);

      return response.map<BidModel>((json) {
        return BidModel.fromJson(json);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<BidModel>> getCarBids(String carId) async {
    try {
      final response = await _client
          .from('bids')
          .select()
          .eq('car_id', carId)
          .neq('bid_status', 'withdrawn')
          .order('bid_amount', ascending: false);

      return response.map<BidModel>((json) {
        return BidModel.fromJson(json);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<double> getHighestBid(String carId) async {
    try {
      final response = await _client
          .from('bids')
          .select()
          .eq('car_id', carId)
          .eq('bid_status', 'pending')
          .order('bid_amount', ascending: false)
          .limit(1);

      if (response.isEmpty) {
        return 0;
      }

      return double.parse(response.first['bid_amount'].toString());
    } catch (e) {
      return 0;
    }
  }

  Future<String?> updateBid(String bidId, double newAmount) async {
    try {
      await _client
          .from('bids')
          .update({'bid_amount': newAmount, 'bid_status': 'pending'})
          .eq('id', bidId);

      return null;
    } catch (e) {
      return "Failed to update bid: $e";
    }
  }

  Future<String?> withdrawBid(String bidId) async {
    try {
      await _client
          .from('bids')
          .update({'bid_status': 'withdrawn'})
          .eq('id', bidId);

      return null;
    } catch (e) {
      return "Failed to withdraw bid: $e";
    }
  }

  Future<String?> acceptBid(String bidId, String carId) async {
    try {
      // Check if this car already has an accepted bid
      final acceptedBid = await _client
          .from('bids')
          .select()
          .eq('car_id', carId)
          .eq('bid_status', 'accepted')
          .maybeSingle();

      if (acceptedBid != null) {
        return "Another bid is already accepted. Cancel it first if deal failed.";
      }

      // Accept only selected bid
      await _client
          .from('bids')
          .update({'bid_status': 'accepted'})
          .eq('id', bidId);

      // Car is not sold yet, only deal pending
      await _client
          .from('cars')
          .update({'status': 'deal_pending'})
          .eq('id', carId);

      return null;
    } catch (e) {
      return "Failed to accept bid: $e";
    }
  }

  Future<String?> rejectBid(String bidId) async {
    try {
      await _client
          .from('bids')
          .update({'bid_status': 'rejected'})
          .eq('id', bidId);

      return null;
    } catch (e) {
      return "Failed to reject bid: $e";
    }
  }

  Future<List<Map<String, dynamic>>> getSellerReceivedBids(
    String sellerId,
  ) async {
    try {
      final response = await _client
          .from('bids')
          .select()
          .eq('seller_id', sellerId)
          .neq('bid_status', 'withdrawn')
          .order('bid_amount', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>?> getCarById(String carId) async {
    try {
      final response = await _client
          .from('cars')
          .select()
          .eq('id', carId)
          .maybeSingle();

      return response;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserById(String userId) async {
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();

      return response;
    } catch (e) {
      return null;
    }
  }

  Future<String?> cancelAcceptedBid(String bidId, String carId) async {
    try {
      await _client
          .from('bids')
          .update({'bid_status': 'cancelled'})
          .eq('id', bidId);

      await _client.from('cars').update({'status': 'active'}).eq('id', carId);

      return null;
    } catch (e) {
      return "Failed to cancel accepted bid: $e";
    }
  }

  Future<String?> markCarSold(String carId) async {
    try {
      await _client.from('cars').update({'status': 'sold'}).eq('id', carId);

      return null;
    } catch (e) {
      return "Failed to mark car as sold: $e";
    }
  }

  Future<Map<String, dynamic>?> getBidCar(String carId) async {
    try {
      final response = await _client
          .from('cars')
          .select()
          .eq('id', carId)
          .maybeSingle();

      return response;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getSellerDetails(String sellerId) async {
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('id', sellerId)
          .maybeSingle();

      return response;
    } catch (e) {
      return null;
    }
  }
}
