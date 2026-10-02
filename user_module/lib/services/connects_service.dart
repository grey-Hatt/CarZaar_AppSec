import 'supabase_service.dart';
import '../models/connects_model.dart';

class ConnectsService {
  final _client = SupabaseService.client;

  Future<int> getBalance(String userId) async {
    try {
      final response = await _client
          .from('connects_wallet')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) {
        await _client.from('connects_wallet').insert({
          'user_id': userId,
          'balance': 0,
        });

        return 0;
      }

      return response['balance'] ?? 0;
    } catch (e) {
      return 0;
    }
  }

  Future<String?> buyConnects({
    required String userId,
    required int connects,
    required double amount,
  }) async {
    try {
      final currentBalance = await getBalance(userId);
      final newBalance = currentBalance + connects;

      await _client
          .from('connects_wallet')
          .update({
            'balance': newBalance,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', userId);

      final transaction = ConnectsTransactionModel(
        userId: userId,
        type: "purchase",
        feature: "buy_connects",
        connects: connects,
        amount: amount,
      );

      await _client.from('connects_transactions').insert(transaction.toJson());

      return null;
    } catch (e) {
      return "Failed to buy connects: $e";
    }
  }

  Future<String?> spendConnects({
    required String userId,
    required int connects,
    required String feature,
    required double amount,
  }) async {
    try {
      final currentBalance = await getBalance(userId);

      if (currentBalance < connects) {
        return "Not enough connects. Please buy more connects.";
      }

      final newBalance = currentBalance - connects;

      await _client
          .from('connects_wallet')
          .update({
            'balance': newBalance,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', userId);

      final transaction = ConnectsTransactionModel(
        userId: userId,
        type: "spend",
        feature: feature,
        connects: connects,
        amount: amount,
      );

      await _client.from('connects_transactions').insert(transaction.toJson());

      return null;
    } catch (e) {
      return "Failed to spend connects: $e";
    }
  }

  Future<List<ConnectsTransactionModel>> getHistory(String userId) async {
    try {
      final response = await _client
          .from('connects_transactions')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return response.map<ConnectsTransactionModel>((json) {
        return ConnectsTransactionModel.fromJson(json);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<String?> makeCarFeatured({
    required String userId,
    required String carId,
  }) async {
    try {
      final error = await spendConnects(
        userId: userId,
        connects: 10,
        feature: "featured_listing",
        amount: 100,
      );

      if (error != null) {
        return error;
      }

      await _client.from('cars').update({'is_featured': true}).eq('id', carId);

      return null;
    } catch (e) {
      return "Failed to feature car: $e";
    }
  }

  Future<String?> unlockContact({
    required String userId,
    required String carId,
    required String bidId,
  }) async {
    try {
      final alreadyUnlocked = await _client
          .from('contact_unlocks')
          .select()
          .eq('user_id', userId)
          .eq('car_id', carId)
          .eq('bid_id', bidId)
          .maybeSingle();

      if (alreadyUnlocked != null) {
        return null;
      }

      final error = await spendConnects(
        userId: userId,
        connects: 5,
        feature: "contact_unlock",
        amount: 50,
      );

      if (error != null) {
        return error;
      }

      await _client.from('contact_unlocks').insert({
        'user_id': userId,
        'car_id': carId,
        'bid_id': bidId,
        'unlocked': true,
      });

      return null;
    } catch (e) {
      return "Failed to unlock contact: $e";
    }
  }

  Future<bool> isContactUnlocked({
    required String userId,
    required String carId,
    required String bidId,
  }) async {
    try {
      final response = await _client
          .from('contact_unlocks')
          .select()
          .eq('user_id', userId)
          .eq('car_id', carId)
          .eq('bid_id', bidId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      return false;
    }
  }
}
