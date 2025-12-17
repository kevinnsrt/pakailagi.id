import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:tubes_pm/authentication/token.dart';
import 'package:tubes_pm/colors/colors.dart';
import 'package:tubes_pm/widget/top_notif.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? _imageFile;
  bool _isUploading = false;
  bool _isLoadingData = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  String _hintNama = "";
  String _hintNumber = "";
  String _hintImage = "";

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

  Future<void> userdata() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final token = await UserToken().getToken();
    final url = Uri.parse("https://pakailagi.user.cloudjkt02.com/api/login");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"uid": user.uid}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final userMap = data is List ? data[0] : data;

        if (!mounted) return;
        setState(() {
          _hintNama = userMap["name"] ?? "";
          _hintNumber = userMap["number"] ?? "";
          _hintImage = userMap["profile_picture"] ?? "";

          // Set text controller awal agar user tidak perlu mengetik ulang jika hanya ingin ganti foto
          _nameController.text = _hintNama;
          _numberController.text = _hintNumber;
          _isLoadingData = false;
        });
      }
    } catch (e) {
      setState(() => _isLoadingData = false);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 50, // Kompresi agar upload lebih cepat
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            const ListTile(
              title: Text("Ubah Foto Profil", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pilih dari Galeri'),
              onTap: () async {
                // Tutup bottom sheet dulu sampai selesai
                await Navigator.of(context).maybePop();
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Ambil dari Kamera'),
              onTap: () async {
                // Tutup bottom sheet dulu sampai selesai
                await Navigator.of(context).maybePop();
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }


  Future<void> postEdit() async {
    // Tutup keyboard agar notifikasi tidak tertutup keyboard
    FocusScope.of(context).unfocus();

    setState(() => _isUploading = true);

    try {
      final token = await UserToken().getToken();
      final url = Uri.parse("https://pakailagi.user.cloudjkt02.com/api/user/profile");

      final request = http.MultipartRequest('POST', url);
      if (_imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath('profile_picture', _imageFile!.path));
      }

      request.fields['name'] = _nameController.text;
      request.fields['number'] = _numberController.text;
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      final response = await request.send();

      if (!mounted) return;

      if (response.statusCode == 200) {
        // 1. Tampilkan notifikasi terlebih dahulu
        TopNotif.success(context, "Profil berhasil diperbarui");

        await Future.delayed(const Duration(milliseconds: 1500));

        if (mounted) {
          Navigator.of(context).pop(true);
        }
      } else {
        TopNotif.error(context, "Gagal memperbarui profil");
      }
    } catch (e) {
      if (mounted) TopNotif.error(context, "Terjadi kesalahan: $e");
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Ubah Profil", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
      ),
      body: _isLoadingData
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            /// AVATAR SECTION
            Center(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary600.withOpacity(0.2), width: 4),
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[100],
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : (_hintImage.isNotEmpty ? NetworkImage(_hintImage) : null) as ImageProvider?,
                      child: (_imageFile == null && _hintImage.isEmpty)
                          ? const Icon(Icons.person, size: 60, color: Colors.grey)
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: _showImageSourceActionSheet,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary600,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.camera_alt, size: 20, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 40),

            /// FORM SECTION
            _buildLabel("Nama Lengkap"),
            _textField(_nameController, "Masukkan nama lengkap", Icons.person_outline),

            const SizedBox(height: 20),

            _buildLabel("Nomor Handphone"),
            _textField(_numberController, "Contoh: 08123456789", Icons.phone_android_outlined, keyboardType: TextInputType.phone),

            const SizedBox(height: 40),

            /// BUTTON SIMPAN
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary600,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: _isUploading ? null : postEdit,
                child: _isUploading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                    : const Text("Simpan Perubahan", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 8),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ),
    );
  }

  Widget _textField(TextEditingController controller, String hint, IconData icon, {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primary600, size: 20),
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary600, width: 1.5),
        ),
      ),
    );
  }
}