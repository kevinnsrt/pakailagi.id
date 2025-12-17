import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tubes_pm/api/notification.dart';
import 'package:tubes_pm/colors/colors.dart';
import 'package:tubes_pm/dashboard/items/beranda.dart';
import 'package:tubes_pm/widget/notification.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  // GlobalKey untuk mengontrol refresh widget anak
  final GlobalKey<ItemBerandaState> _rekomendasiKey = GlobalKey<ItemBerandaState>();
  final GlobalKey<ItemBerandaState> _terbaruKey = GlobalKey<ItemBerandaState>();

  bool _isFetchingNotification = false;

  // Variabel untuk Auto-Slider Banner
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  final List<String> _banners = [
    'assets/beranda_banner.png',
    'assets/beranda_banner2.png',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startAutoSlider();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // Fungsi Refresh via Logo
  Future<void> _handleLogoRefresh() async {
    // Memanggil fungsi handleRefresh di widget anak menggunakan GlobalKey
    _rekomendasiKey.currentState?.handleRefresh();
    _terbaruKey.currentState?.handleRefresh();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Produk telah diperbarui"),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primary500,
      ),
    );
  }

  void _startAutoSlider() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _banners.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  Future<void> _handleNotificationClick() async {
    setState(() => _isFetchingNotification = true);

    try {
      final List<Map<String, dynamic>> notifications =
      await NotificationService().fetchNotifications();

      if (!mounted) return;
      setState(() => _isFetchingNotification = false);

      showDialog(
        context: context,
        builder: (context) => NotificationPopup(notifications: notifications),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isFetchingNotification = false);
      // Opsional: Tampilkan snackbar jika gagal ambil notifikasi
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _handleLogoRefresh,
              child: ListView(
                padding: EdgeInsets.zero,
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  _buildBannerSlider(),
                  const SizedBox(height: 24),

                  _buildSectionTitle("Rekomendasi Produk"),
                  SizedBox(
                      height: 238,
                      child: ItemBeranda(
                          key: _rekomendasiKey,
                          isRandom: true
                      )
                  ),

                  const SizedBox(height: 16),

                  _buildSectionTitle("Produk Terbaru"),
                  SizedBox(
                      height: 238,
                      child: ItemBeranda(
                          key: _terbaruKey,
                          isRandom: false
                      )
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary500,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo yang bisa diklik untuk refresh
              InkWell(
                onTap: _handleLogoRefresh,
                borderRadius: BorderRadius.circular(8),
                splashColor: Colors.white.withOpacity(0.2),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Image.asset(
                    'assets/logo_home.png',
                    width: 110,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // Notification Button
              Material(
                color: Colors.white.withOpacity(0.15),
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: _isFetchingNotification ? null : _handleNotificationClick,
                  customBorder: const CircleBorder(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: _isFetchingNotification
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.5),
                    )
                        : const Icon(
                      Icons.notifications_none_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBannerSlider() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          height: 130,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemCount: _banners.length,
              itemBuilder: (context, index) => Image.asset(
                _banners[index],
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_banners.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 6,
              width: _currentPage == index ? 20 : 6,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? AppColors.primary500
                    : AppColors.grayscale300,
                borderRadius: BorderRadius.circular(10),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
            color: AppColors.primary800,
            fontWeight: FontWeight.bold,
            fontSize: 14),
      ),
    );
  }
}