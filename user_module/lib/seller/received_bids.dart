import 'package:flutter/material.dart';
import '../services/bid_service.dart';
import '../services/session_service.dart';
import '../utils/format.dart';
import '../widgets/status_chip.dart';

class ReceivedBids extends StatefulWidget {
  const ReceivedBids({super.key});

  @override
  State<ReceivedBids> createState() => _ReceivedBidsState();
}

class _ReceivedBidsState extends State<ReceivedBids> {
  final service = BidService();
  List<Map<String, dynamic>> bids = [];
  bool loading = true;

  // Cached lookups so a rebuild does not re-query the database for every card.
  final Map<String, Future<List<Map<String, dynamic>?>>> _details = {};

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
    final result = await service.getSellerReceivedBids(u.id!);
    if (!mounted) return;
    setState(() {
      bids = result;
      _details.clear();
      loading = false;
    });
  }

  Future<void> action(Future<String?> task, String msg) async {
    final e = await task;
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e ?? msg)));
    load();
  }

  Future<List<Map<String, dynamic>?>> detailsFor(Map<String, dynamic> b) {
    return _details.putIfAbsent(
      '${b['id']}',
      () => Future.wait<Map<String, dynamic>?>([
        service.getCarById(b['car_id']),
        service.getUserById(b['buyer_id']),
      ]),
    );
  }

  Widget bidCard(Map<String, dynamic> b) {
    return FutureBuilder<List<Map<String, dynamic>?>>(
      future: detailsFor(b),
      builder: (_, s) {
        final done = s.connectionState == ConnectionState.done;
        final car = s.data?[0];
        final buyer = s.data?[1];
        final status = (b['bid_status'] ?? 'pending').toString();
        final amount = double.tryParse(b['bid_amount'].toString()) ?? 0;

        return Card(
          margin: const EdgeInsets.only(bottom: 14),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.orange.shade100,
                      child: const Icon(Icons.gavel, color: Colors.black),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        car?['car_name'] ?? (done ? 'Unknown car' : 'Loading car...'),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    StatusChip(status),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Buyer: ${buyer?['name'] ?? (done ? 'Unknown buyer' : 'Loading buyer...')}',
                ),
                Text("Phone: ${buyer?['phone'] ?? ''}"),
                Text('Bid Amount: ${formatPrice(amount)}'),
                const SizedBox(height: 12),
                if (status == 'pending')
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.check),
                          label: const Text('Accept'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () => action(
                            service.acceptBid(b['id'], b['car_id']),
                            'Bid accepted',
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.close),
                          label: const Text('Reject'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () => action(
                            service.rejectBid(b['id']),
                            'Bid rejected',
                          ),
                        ),
                      ),
                    ],
                  ),
                if (status == 'accepted') ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.done_all),
                      label: const Text('Mark Sold'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () => action(
                        service.markCarSold(b['car_id']),
                        'Car marked as sold',
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.cancel),
                      label: const Text('Deal Failed - Accept Other Bid'),
                      onPressed: () => action(
                        service.cancelAcceptedBid(b['id'], b['car_id']),
                        'Deal cancelled',
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final visible = bids.where((b) => b['bid_status'] != 'withdrawn').toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Received Bids')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: load,
              child: visible.isEmpty
                  ? ListView(
                      children: const [
                        SizedBox(height: 120),
                        Icon(Icons.price_check, size: 60, color: Colors.black26),
                        SizedBox(height: 10),
                        Center(child: Text('No bids received yet')),
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
