import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tubes_pm/colors/colors.dart';
import 'package:tubes_pm/widget/top_notif.dart';

class EditPassword extends StatefulWidget {
  const EditPassword({super.key});

  @override
  State<EditPassword> createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _isGoogleUser = false;

  @override
  void initState() {
    super.initState();
    _checkProvider();
  }

  void _checkProvider() {
    final user = _auth.currentUser;
    if (user != null) {
      // Cek apakah ada provider 'google.com' di data user
      final providers = user.providerData.map((e) => e.providerId).toList();
      setState(() {
        _isGoogleUser = providers.contains('google.com');
      });
    }
  }

  Future<void> _sendResetPassword() async {
    setState(() => _isLoading = true);
    try {
      final String? email = _auth.currentUser?.email;
      if (email != null) {
        await _auth.sendPasswordResetEmail(email: email);
        if (!mounted) return;
        _showSuccessDialog(email);
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      TopNotif.error(context, e.message ?? "Terjadi kesalahan");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSuccessDialog(String email) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Email Terkirim"),
        content: Text("Link reset kata sandi telah dikirim ke $email."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK")),
        ],
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
        title: const Text("Pengaturan Kata Sandi", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isGoogleUser ? Icons.account_circle : Icons.lock_reset_rounded,
              size: 100,
              color: _isGoogleUser ? Colors.blue : AppColors.primary500,
            ),
            const SizedBox(height: 24),
            Text(
              _isGoogleUser ? "Akun Terhubung Google" : "Atur Ulang Kata Sandi?",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Teks Kondisional
            Text(
              _isGoogleUser
                  ? "Anda masuk menggunakan akun Google. Untuk alasan keamanan, pengaturan kata sandi dikelola langsung oleh Google."
                  : "Klik tombol di bawah untuk menerima email berisi link pengaturan ulang kata sandi akun Anda.",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, height: 1.5),
            ),

            const SizedBox(height: 40),

            // Tombol Kondisional
            if (_isGoogleUser)
              OutlinedButton.icon(
                onPressed: () {
                  // Opsional: Arahkan ke bantuan Google atau tutup
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text("Kembali"),
                style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
              )
            else
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary500,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _isLoading ? null : _sendResetPassword,
                  child: _isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text("Kirim Email Reset", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}