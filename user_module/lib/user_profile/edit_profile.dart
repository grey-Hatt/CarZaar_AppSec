import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../services/supabase_service.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final name = TextEditingController();
  final phone = TextEditingController();
  final city = TextEditingController();
  String profileImage = '';
  String selectedImageName = 'No profile picture selected';
  bool loading = false;

  @override
  void initState() {
    super.initState();
    final u = context.read<AppProvider>().currentUser;
    name.text = u?.name ?? '';
    phone.text = u?.phone ?? '';
    city.text = u?.city ?? '';
    profileImage = u?.profileImage ?? '';
    selectedImageName = profileImage.isEmpty
        ? 'No profile picture selected'
        : 'Current profile picture saved';
  }

  @override
  void dispose() {
    name.dispose();
    phone.dispose();
    city.dispose();
    super.dispose();
  }

  Future<void> pickProfileImage() async {
    try {
      // Profile pictures are small, so downscale hard to keep the DB light.
      final img = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 600,
        imageQuality: 75,
      );
      if (img == null) return;
      final bytes = await img.readAsBytes();
      if (!mounted) return;
      setState(() {
        profileImage = base64Encode(bytes);
        selectedImageName = img.name;
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not pick the image')),
      );
    }
  }

  Future<void> updateProfile() async {
    final provider = context.read<AppProvider>();
    final u = provider.currentUser;
    if (u == null) return;

    if (name.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name cannot be empty')),
      );
      return;
    }

    setState(() => loading = true);
    try {
      await SupabaseService.client.from('users').update({
        'name': name.text.trim(),
        'phone': phone.text.trim(),
        'city': city.text.trim(),
        'profile_image': profileImage,
      }).eq('id', u.id!);

      provider.updateUser(u.copyWith(
        name: name.text.trim(),
        phone: phone.text.trim(),
        city: city.text.trim(),
        profileImage: profileImage,
      ));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      setState(() => loading = false);
    }
  }

  Uint8List? get _avatarBytes {
    if (profileImage.isEmpty) return null;
    try {
      return base64Decode(profileImage);
    } catch (_) {
      return null;
    }
  }

  Widget field(String label, IconData icon, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: icon == Icons.phone ? TextInputType.phone : TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  Widget imagePickerRow() => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(children: [
          const Icon(Icons.image, color: Colors.orange),
          const SizedBox(width: 10),
          Expanded(
            child: Text(selectedImageName,
                maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          TextButton(onPressed: pickProfileImage, child: const Text('Select')),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: Colors.orange,
            backgroundImage: _avatarBytes == null ? null : MemoryImage(_avatarBytes!),
            child: _avatarBytes == null
                ? const Icon(Icons.person, size: 50, color: Colors.black)
                : null,
          ),
          const SizedBox(height: 25),
          imagePickerRow(),
          const SizedBox(height: 15),
          field('Name', Icons.person, name),
          field('Phone', Icons.phone, phone),
          field('City', Icons.location_city, city),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: loading ? null : updateProfile,
              icon: const Icon(Icons.save),
              label: Text(loading ? 'Saving...' : 'Save Changes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.all(15),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
