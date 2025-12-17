import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tubes_pm/authentication/token.dart';
import 'package:tubes_pm/colors/colors.dart';
import 'package:http/http.dart' as http;

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? _imageFile;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  String _nama="";
  String _noHp="";

  // fungsi ambil gambar
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // fungsi post ke laravel
  Future<void> postEdit (String _nama, String _noHp)async{
    final token = UserToken().getToken();
    final url = Uri.parse("https://pakailagi.user.cloudjkt02.com/api/user/profile");

    bool _isUploading = false;
    
    var request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath(
      'profile_picture', // field di backend
      _imageFile!.path,
    ));
    // tambah field lain
    request.fields['nama_lengkap'] = _nama;
    request.fields['no_hp'] = _noHp;

    // jika pakai token (authorization)
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';

    try {
      var response = await request.send();

      setState(() {
        _isUploading = false;
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload berhasil!')),
        );
        setState(() {
          _imageFile = null; // reset avatar setelah upload
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload gagal: ${response.statusCode}')),
        );
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi error saat upload')),
      );
    }
  }

  // dialog untuk pilih sumber gambar
  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Pilih Sumber Gambar'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Galeri'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Kamera'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Edit Profil", style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // avatar
              Container(
                width: 120,
                height: 120,
                child: Stack(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        backgroundImage:
                        _imageFile != null ? FileImage(_imageFile!) : null,
                        child: _imageFile == null
                            ? Icon(Icons.person, size: 50)
                            : null,
                      ),
                    ),
                    Positioned(
                      top: 80,
                      right: 6,
                      child: SizedBox(
                        width: 33,
                        height: 33,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: CircleBorder(),
                              backgroundColor: Colors.white),
                          onPressed: _showImageSourceDialog,
                          child: Icon(
                            Icons.edit,
                            size: 18,
                            color: AppColors.grayscale500,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 48),

              // data diri
              Container(
                width: 365,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Nama Lengkap"),
                    SizedBox(height: 4),
                    _textField(_nameController),
                    SizedBox(height: 16),
                    Text("No. Handphone"),
                    SizedBox(height: 4),
                    _textField(_numberController),
                  ],
                ),
              ),
              SizedBox(height: 32),

              // Button Simpan
              Container(
                width: 365,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary500,
                      foregroundColor: Colors.white,
                      elevation: 6),
                  onPressed: () async{
                      postEdit(_nameController.text, _numberController.text);
                  },
                  child: Text(
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

Widget _textField(TextEditingController controller) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}
