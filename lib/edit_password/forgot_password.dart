import 'package:flutter/material.dart';
import 'package:tubes_pm/colors/colors.dart';
import 'package:tubes_pm/widget/top_notif.dart'; // Menggunakan widget notifikasi Anda

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  void _handleResetPassword() {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      TopNotif.error(context, "Masukkan email Anda terlebih dahulu");
      return;
    }

    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
      TopNotif.error(context, "Format email tidak valid");
      return;
    }

    // Simulasi pengiriman instruksi ke API
    // KirimPasswordReset.instance.send(email);

    TopNotif.success(context, "Instruksi reset password telah dikirim ke email Anda");

    // Kembali ke halaman Login setelah sukses
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Lupa Password",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              "Atur Ulang Password",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Masukkan alamat email yang terdaftar. Kami akan mengirimkan instruksi untuk mengubah password Anda.",
              style: TextStyle(
                fontSize: 14,
                color: AppColors.grayscale500,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),

            // Input Email
            Text(
              "Email",
              style: TextStyle(color: AppColors.grayscale800, fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: "user@example.com",
                prefixIcon: const Icon(Icons.email_outlined),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primary500),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Tombol Kirim
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary500,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                ),
                onPressed: _handleResetPassword,
                child: const Text(
                  "Kirim Instruksi",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}