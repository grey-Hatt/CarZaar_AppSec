import 'package:flutter_test/flutter_test.dart';
import 'package:carzaar_user/models/bid_model.dart';
import 'package:carzaar_user/models/car_model.dart';
import 'package:carzaar_user/utils/format.dart';

void main() {
  group('formatPrice', () {
    test('adds thousands separators', () {
      expect(formatPrice(2500000), 'Rs. 2,500,000');
      expect(formatPrice(1000), 'Rs. 1,000');
    });

    test('handles small, zero and decimal values', () {
      expect(formatPrice(999), 'Rs. 999');
      expect(formatPrice(0), 'Rs. 0');
      expect(formatPrice(1234.6), 'Rs. 1,235');
    });
  });

  group('input helpers', () {
    test('digitsOnly strips everything except digits', () {
      expect(digitsOnly('+92 300-1234567'), '923001234567');
    });

    test('looksLikeEmail accepts and rejects the right strings', () {
      expect(looksLikeEmail('ali@example.com'), isTrue);
      expect(looksLikeEmail('not-an-email'), isFalse);
      expect(looksLikeEmail('a@b'), isFalse);
    });
  });

  group('models', () {
    test('CarModel survives a toJson / fromJson round trip', () {
      final car = CarModel(
        sellerId: 's1',
        carName: 'Civic',
        brand: 'Honda',
        model: 'Oriel',
        year: 2021,
        price: 5200000,
        description: 'Well maintained',
        location: 'Islamabad',
      );

      final copy = CarModel.fromJson(car.toJson());

      expect(copy.carName, 'Civic');
      expect(copy.year, 2021);
      expect(copy.price, 5200000);
      expect(copy.status, 'active');
      expect(copy.isFeatured, isFalse);
    });

    test('BidModel parses numeric strings and defaults to pending', () {
      final bid = BidModel.fromJson({
        'id': 'b1',
        'car_id': 'c1',
        'buyer_id': 'u1',
        'seller_id': 'u2',
        'bid_amount': '150000.5',
      });

      expect(bid.bidAmount, 150000.5);
      expect(bid.bidStatus, 'pending');
    });
  });
}
