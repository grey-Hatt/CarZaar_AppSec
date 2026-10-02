import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../services/connects_service.dart';
import 'buy_connects.dart';
import 'connects_history.dart';

class ConnectsWallet extends StatefulWidget {
  const ConnectsWallet({super.key});

  @override
  State<ConnectsWallet> createState() => _ConnectsWalletState();
}

class _ConnectsWalletState extends State<ConnectsWallet> {
  final connectsService = ConnectsService();
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadBalance();
  }

  Future<void> loadBalance() async {
    await context.read<AppProvider>().loadConnects();
    if (mounted) setState(() => loading = false);
  }

  Widget optionCard(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange.shade100,
          child: Icon(icon, color: Colors.black),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final balance = context.watch<AppProvider>().connectsBalance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Connects Wallet'),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadBalance,
              child: ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      gradient: const LinearGradient(
                        colors: [Colors.black, Colors.orange],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(children: [
                      const Icon(Icons.account_balance_wallet, color: Colors.white, size: 60),
                      const SizedBox(height: 12),
                      const Text('Available Connects',
                          style: TextStyle(color: Colors.white70, fontSize: 18)),
                      const SizedBox(height: 8),
                      Text('$balance',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 46,
                              fontWeight: FontWeight.bold)),
                    ]),
                  ),
                  const SizedBox(height: 25),
                  optionCard(Icons.add_card, 'Buy Connects',
                      'Purchase connects using demo payment', () async {
                    await Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const BuyConnects()));
                    loadBalance();
                  }),
                  optionCard(Icons.history, 'Connects History',
                      'View your buying and spending records', () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const ConnectsHistory()));
                  }),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text(
                      'Use connects for featured listings, contact unlocks, and premium actions.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
