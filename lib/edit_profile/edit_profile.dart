import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'package:tubes_pm/authentication/token.dart';
import 'package:tubes_pm/colors/colors.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? _imageFile;
  bool _isUploading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  String _hintNama = "";
  String _hintNumber = "";
  String _hintImage = "";

  /// =============================
  /// AMBIL DATA USER
  /// =============================
  Future<void> userdata() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final token = await UserToken().getToken();
    if (token == null) return;

    final url =
    Uri.parse("https://pakailagi.user.cloudjkt02.com/api/login");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"uid": user.uid}),
      );

      if (response.statusCode != 200) return;

      final data = json.decode(response.body);
      final userMap = data is List ? data[0] : data;

      if (!mounted) return;
      setState(() {
        _hintNama = userMap["name"] ?? "";
        _hintNumber = userMap["number"] ?? "";
        _hintImage = userMap["profile_picture"] ?? "";
      });
    } catch (e) {
      debugPrint("Userdata error: $e");
    }
  }

  /// =============================
  /// PICK IMAGE
  /// =============================
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 70,
      maxWidth: 1024,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Pilih Sumber Gambar'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeri'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Kamera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// =============================
  /// POST UPDATE PROFILE
  /// =============================
  Future<void> postEdit(String name, String number) async {
    setState(() => _isUploading = true);

    final token = await UserToken().getToken();
    if (token == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User belum login')),
        );
      }
      setState(() => _isUploading = false);
      return;
    }

    final url =
    Uri.parse("https://pakailagi.user.cloudjkt02.com/api/user/profile");

    try {
      final request = http.MultipartRequest('POST', url);

      if (_imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'profile_picture',
            _imageFile!.path,
          ),
        );
      }

      request.fields['name'] = name;
      request.fields['number'] = number;

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      final response = await request.send();
      final resBody = await response.stream.bytesToString();

      debugPrint("Status: ${response.statusCode}");
      debugPrint("Body: $resBody");

      if (response.statusCode != 200 && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal update profile")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    userdata();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  /// =============================
  /// UI
  /// =============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Edit Profil"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 24),

              /// AVATAR
              Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : (_hintImage.isNotEmpty
                        ? NetworkImage(_hintImage)
                        : null) as ImageProvider?,
                    child: (_imageFile == null && _hintImage.isEmpty)
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                  Positioned(
                    bottom: 6,
                    right: 6,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: _showImageSourceDialog,
                      child: const Icon(Icons.edit, size: 18),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 48),

              /// FORM
              SizedBox(
                width: 360,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Nama Lengkap"),
                    const SizedBox(height: 4),
                    _textField(_nameController, _hintNama),
                    const SizedBox(height: 16),
                    const Text("No. Handphone"),
                    const SizedBox(height: 4),
                    _textField(_numberController, _hintNumber),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              /// BUTTON SIMPAN
              SizedBox(
                width: 360,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary500,
                    foregroundColor: Colors.white
                  ),
                  onPressed: _isUploading
                      ? null
                      : () async {
                    final name = _nameController.text.isEmpty
                        ? _hintNama
                        : _nameController.text;

                    final number = _numberController.text.isEmpty
                        ? _hintNumber
                        : _numberController.text;

                    await postEdit(name, number);

                    if (!mounted) return;
                    Navigator.pop(context, true);
                  },
                  child: _isUploading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    "Simpan",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// =============================
/// TEXTFIELD REUSABLE
/// =============================
Widget _textField(TextEditingController controller, String hint) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}
