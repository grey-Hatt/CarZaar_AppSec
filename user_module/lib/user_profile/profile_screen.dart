import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'edit_profile.dart';

class UProfile extends StatelessWidget {
  const UProfile({super.key});

  Uint8List? safeImage(String? image) {
    if (image == null || image.isEmpty) return null;
    try {
      return base64Decode(image);
    } catch (_) {
      return null;
    }
  }

  Widget infoTile(IconData icon, String title, String value) => Card(
        margin: const EdgeInsets.only(bottom: 10),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.orange.shade100,
            child: Icon(icon, color: Colors.black),
          ),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(value),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppProvider>().currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('User Profile')),
        body: const Center(child: Text('No user logged in')),
      );
    }

    final imageBytes = safeImage(user.profileImage);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 35),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Colors.orange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(children: [
              CircleAvatar(
                radius: 55,
                backgroundColor: Colors.white,
                backgroundImage: imageBytes == null ? null : MemoryImage(imageBytes),
                child: imageBytes == null
                    ? Text(
                        user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                        style: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      )
                    : null,
              ),
              const SizedBox(height: 12),
              Text(user.name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold)),
              Text(user.email, style: const TextStyle(color: Colors.white70)),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(children: [
              infoTile(Icons.person, 'Name', user.name),
              infoTile(Icons.email, 'Email', user.email),
              infoTile(Icons.phone, 'Phone', user.phone),
              infoTile(Icons.location_city, 'City', user.city),
              infoTile(Icons.verified, 'Verified Seller', user.isVerified ? 'Yes' : 'No'),
              infoTile(Icons.info, 'Account Status', user.status),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditProfile()),
                  ),
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Profile'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.all(15),
                  ),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
