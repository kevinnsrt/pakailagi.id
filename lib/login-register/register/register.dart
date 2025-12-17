import 'package:flutter/material.dart';
import 'package:smooth_transition/smooth_transition.dart';
import 'package:tubes_pm/authentication/register_auth.dart';
import 'package:tubes_pm/colors/colors.dart';
import 'package:tubes_pm/login-register/register/register2.dart';
import 'package:tubes_pm/widget/top_notif.dart'; // Pastikan import ini benar

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  List<bool> toggleList = [true, true];

  void _toggle(int index) {
    setState(() {
      toggleList[index] = !toggleList[index];
    });
  }

  // Fungsi Validasi
  void _handleRegister() {
    final String name = _name.text.trim();
    final String email = _email.text.trim();
    final String password = _pass.text;
    final String confirmPassword = _confirmPass.text;

    // 1. Cek Data Kosong
    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      TopNotif.error(context, "Semua data wajib diisi");
      return;
    }

    // 2. Format Nama (Minimal 3 Karakter)
    if (name.length < 3) {
      TopNotif.error(context, "Nama minimal 3 karakter");
      return;
    }

    // 3. Format Email (Regex)
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (!emailValid) {
      TopNotif.error(context, "Format email tidak valid");
      return;
    }

    // 4. Panjang Password (Minimal 8 Karakter)
    if (password.length < 8) {
      TopNotif.error(context, "Kata sandi minimal 8 karakter");
      return;
    }

    // 5. Konfirmasi Password
    if (password != confirmPassword) {
      TopNotif.error(context, "Konfirmasi kata sandi tidak sesuai");
      return;
    }

    // Jika Lolos Validasi
    RegisterAuth.instance.username = name;
    RegisterAuth.instance.email = email;
    RegisterAuth.instance.password = password;
    RegisterAuth.instance.confirmPassword = confirmPassword;

    RegisterAuth.instance.register1();

    Navigator.push(
      context,
      PageTransition(
        child: const RegisterPage2(),
        type: PageTransitionType.fade,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Sign Up", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // HEADER LOGO (LEBAR)
            SizedBox(
              width: 450, // Tambahkan angka ini jika masih kurang lebar
              child: Image.asset(
                'assets/register_logo.png',
                fit: BoxFit.contain, // Menjaga rasio asli agar tidak gepeng
                alignment: Alignment.centerLeft,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Buat Akun Baru",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary700),
            ),
            const SizedBox(height: 32),

            // FORM FIELDS
            _buildLabel("Nama Lengkap"),
            _buildTextField(_name, "Masukkan nama lengkap", Icons.person_outline),
            const SizedBox(height: 16),

            _buildLabel("Email"),
            _buildTextField(_email, "user@example.com", Icons.email_outlined, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),

            _buildLabel("Kata Sandi"),
            _buildTextField(
              _pass,
              "Minimal 8 karakter",
              Icons.lock_outline,
              obscure: toggleList[0],
              onToggle: () => _toggle(0),
              showToggle: true,
            ),
            const SizedBox(height: 16),

            _buildLabel("Konfirmasi Kata Sandi"),
            _buildTextField(
              _confirmPass,
              "Ulangi kata sandi",
              Icons.lock_outline,
              obscure: toggleList[1],
              onToggle: () => _toggle(1),
              showToggle: true,
            ),

            const SizedBox(height: 40),

            // BUTTON SELANJUTNYA
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: _handleRegister,
                child: const Text("Selanjutnya", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),

            const SizedBox(height: 24),

            // FOOTER
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Sudah Punya Akun? "),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Text(
                    "Sign In",
                    style: TextStyle(color: AppColors.primary800, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(text, style: TextStyle(color: AppColors.grayscale800, fontSize: 13, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String hint,
      IconData icon,
      {bool obscure = false, bool showToggle = false, VoidCallback? onToggle, TextInputType keyboardType = TextInputType.text}
      ) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        prefixIcon: Icon(icon, color: AppColors.primary500, size: 20),
        suffixIcon: showToggle
            ? GestureDetector(
          onTap: onToggle,
          child: Icon(obscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
        )
            : null,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary500, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }
}