import 'package:flutter/material.dart';
import '../bidding/edit_bid.dart';
import '../communication/talk.dart';
import '../models/bid_model.dart';
import '../services/bid_service.dart';
import '../services/connects_service.dart';
import '../services/session_service.dart';
import '../utils/format.dart';
import '../widgets/status_chip.dart';

class MyBids extends StatefulWidget {
  const MyBids({super.key});

  @override
  State<MyBids> createState() => _MyBidsState();
}

class _MyBidsState extends State<MyBids> {
  final bidService = BidService();
  final connects = ConnectsService();
  List<BidModel> bids = [];
  bool loading = true;

  // Cached lookups so a rebuild does not re-query the database for every card.
  final Map<String, Future<List<Map<String, dynamic>?>>> _details = {};
  final Map<String, Future<bool>> _unlocked = {};

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final u = SessionService.currentUser;
    if (u == null) {
      if (mounted) setState(() => loading = false);
      return;
    }
    final result = await bidService.getBuyerBids(u.id!);
    if (!mounted) return;
    setState(() {
      bids = result;
      _details.clear();
      _unlocked.clear();
      loading = false;
    });
  }

  void showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> withdraw(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Withdraw bid?'),
        content: const Text('The seller will no longer see this bid.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Withdraw', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    final e = await bidService.withdrawBid(id);
    if (!mounted) return;
    showMessage(e ?? 'Bid withdrawn');
    load();
  }

  Future<List<Map<String, dynamic>?>> detailsFor(BidModel b) {
    return _details.putIfAbsent(
      b.id ?? '${b.carId}-${b.sellerId}',
      () => Future.wait<Map<String, dynamic>?>([
        bidService.getCarById(b.carId),
        bidService.getUserById(b.sellerId),
      ]),
    );
  }

  Future<bool> unlockedFor(BidModel b) {
    return _unlocked.putIfAbsent(
      b.id!,
      () => connects.isContactUnlocked(
        userId: SessionService.currentUser!.id!,
        carId: b.carId,
        bidId: b.id!,
      ),
    );
  }

  Widget bidCard(BidModel b) {
    return FutureBuilder<List<Map<String, dynamic>?>>(
      future: detailsFor(b),
      builder: (_, snap) {
        final done = snap.connectionState == ConnectionState.done;
        final car = snap.data?[0];
        final seller = snap.data?[1];
        final carName = car?['car_name'] ?? (done ? 'Unknown car' : 'Loading car...');
        final sellerName =
            seller?['name'] ?? (done ? 'Unknown seller' : 'Loading seller...');
        final sellerPhone = (seller?['phone'] ?? '').toString();

        return Card(
          margin: const EdgeInsets.only(bottom: 14),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                CircleAvatar(
                  backgroundColor: Colors.orange.shade100,
                  child: const Icon(Icons.gavel, color: Colors.black),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    carName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                StatusChip(b.bidStatus),
              ]),
              const SizedBox(height: 10),
              Text('Seller: $sellerName'),
              Text('Bid Amount: ${formatPrice(b.bidAmount)}'),
              if (b.bidStatus == 'pending') ...[
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit'),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => EditBid(bid: b)),
                        );
                        load();
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.close),
                      label: const Text('Withdraw'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => withdraw(b.id!),
                    ),
                  ),
                ]),
              ],
              if (b.bidStatus == 'accepted') ...[
                const SizedBox(height: 12),
                FutureBuilder<bool>(
                  future: unlockedFor(b),
                  builder: (_, s) {
                    final unlocked = s.data ?? false;
                    if (unlocked) {
                      return SizedBox(
                        width: double.infinity,
                        child: Talk(
                          phone: sellerPhone,
                          message:
                              'Hello, my bid was accepted for $carName on CarZaar.',
                        ),
                      );
                    }
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.lock_open),
                        label: const Text('Unlock Contact - 5 Connects'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () async {
                          final e = await connects.unlockContact(
                            userId: SessionService.currentUser!.id!,
                            carId: b.carId,
                            bidId: b.id!,
                          );
                          if (!mounted) return;
                          showMessage(e ?? 'Contact unlocked');
                          setState(() => _unlocked.remove(b.id!));
                        },
                      ),
                    );
                  },
                ),
              ],
            ]),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final visible = bids.where((b) => b.bidStatus != 'withdrawn').toList();

    return Scaffold(
      appBar: AppBar(title: const Text('My Bids')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: load,
              child: visible.isEmpty
                  ? ListView(
                      children: const [
                        SizedBox(height: 120),
                        Icon(Icons.gavel, size: 60, color: Colors.black26),
                        SizedBox(height: 10),
                        Center(child: Text('No bids yet')),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(14),
                      itemCount: visible.length,
                      itemBuilder: (_, i) => bidCard(visible[i]),
                    ),
            ),
    );
  }
}
