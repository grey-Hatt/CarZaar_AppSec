import '../models/user_model.dart';
import 'supabase_service.dart';

class AuthService {
  final _client = SupabaseService.client;

  Future<String?> signUp(UserModel user) async {
    try {
      final existingUser = await _client
          .from('users')
          .select()
          .eq('email', user.email)
          .maybeSingle();

      if (existingUser != null) {
        return "Email already registered";
      }

      final insertedUser = await _client
          .from('users')
          .insert(user.toJson())
          .select()
          .single();

      await _client.from('connects_wallet').insert({
        'user_id': insertedUser['id'],
        'balance': 0,
      });

      return null;
    } catch (e) {
      return "Signup failed: $e";
    }
  }

  Future<UserModel?> login(String email, String password) async {
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('email', email)
          .eq('password', password)
          .eq('status', 'active')
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return UserModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<String?> resetPassword(
    String email,
    String phone,
    String newPassword,
  ) async {
    try {
      final user = await _client
          .from('users')
          .select()
          .eq('email', email)
          .eq('phone', phone)
          .maybeSingle();

      if (user == null) {
        return "Verification failed. Email and phone do not match.";
      }

      await _client
          .from('users')
          .update({'password': newPassword})
          .eq('email', email)
          .eq('phone', phone);

      return null;
    } catch (e) {
      return "Password reset failed: $e";
    }
  }
}
