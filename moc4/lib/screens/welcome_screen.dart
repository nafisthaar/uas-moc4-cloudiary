import 'dart:ui'; 
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'main_layout.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // 1. DATA KONTEN SLIDER (3 pages)
  final List<Map<String, String>> _onboardingData = [
    {
      'emoji': '☁️',
      'title': 'Welcome to Cloudiary',
      'desc': 'Capture your feeling emotions, daily thoughts, and memories safely in the cloud.',
    },
    {
      'emoji': '🌿',
      'title': 'Track emotional waves',
      'desc': 'Understand your emotional patterns over time with our custom analytics and insights.',
    },
    {
      'emoji': '✍️',
      'title': 'Start your journey',
      'desc': 'Every word you write is a step closer to understanding yourself better.',
    },
  ];

  // 2. DATA GRADIENT WARNA BACKGROUND PER SLIDE
  final List<List<Color>> _backgroundGradients = [
    [const Color(0xFFDCEEF8), const Color(0xFFEEF5FA), const Color(0xFFF8F3E8)], // Slide 1
    [const Color(0xFFD1FAE5), const Color(0xFFEEF5FA), const Color(0xFFFEF3C7)], // Slide 2
    [const Color(0xFFEDE9FE), const Color(0xFFDCEEF8), const Color(0xFFFEE2E2)], // Slide 3
  ];

  // 3. WARNA AKTIF INDIKATOR TITIK PER SLIDE
  final List<Color> _activeDotColors = [
    const Color(0xFFBFD7EA), // Slide 1
    const Color(0xFF10B981), // Slide 2
    const Color(0xFF8B5CF6), // Slide 3
  ];

  @override
  void dispose() {
    _pageController.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // LAYER 1: BASE GRADIENT BACKGROUND
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _backgroundGradients[_currentPage],
              ),
            ),
          ),

          // LAYER 2: DECORATIVE BACKGROUND BLOBS
          // Top-Right Blob
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 256,
              height: 256,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0x33BFD7EA), Colors.transparent], 
                ),
              ),
            ),
          ),
          // Bottom-Left Blob
          Positioned(
            bottom: 128,
            left: -64,
            child: Container(
              width: 192,
              height: 192,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0x26F7E6A8), Colors.transparent], 
                ),
              ),
            ),
          ),

          // LAYER 3: KONTEN SLIDER (PageView) & NAVIGASI TOMBOL
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: _onboardingData.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // A. FROSTED GLASS CONTAINER
                            ClipRRect(
                              borderRadius: BorderRadius.circular(24.0), 
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12), 
                                child: Container(
                                  width: 112,
                                  height: 112,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(165), 
                                    borderRadius: BorderRadius.circular(24.0),
                                    border: Border.all(
                                      color: Colors.white.withAlpha(178), 
                                      width: 1.0,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF4B6573).withAlpha(25), 
                                        blurRadius: 24,
                                        offset: const Offset(0, 4),
                                      )
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      _onboardingData[index]['emoji']!,
                                      style: const TextStyle(fontSize: 52), 
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 48),

                            // B. TEXT JUDUL UTAMA (Lora Font)
                            Text(
                              _onboardingData[index]['title']!,
                              textAlign: TextAlign.center,
                              style: CloudiaryTheme.mainHeader.copyWith(
                                color: const Color(0xFF2C4A60),
                                fontSize: 32,
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // C. TEXT DESKRIPSI (DM Sans Font)
                            Container(
                              constraints: const BoxConstraints(maxWidth: 280), 
                              child: Text(
                                _onboardingData[index]['desc']!,
                                textAlign: TextAlign.center,
                                style: CloudiaryTheme.subtext.copyWith(
                                  color: CloudiaryTheme.lightPrimaryText,
                                  fontSize: 16,
                                  height: 1.625, 
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // PAGE INDICATORS & GLASSMORPHIC CALL-TO-ACTION BUTTON
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
                  child: Column(
                    children: [
                      // D. PAGE INDICATORS
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _onboardingData.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4.0), 
                            width: _currentPage == index ? 24.0 : 8.0, 
                            height: 8.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              color: _currentPage == index
                                  ? _activeDotColors[_currentPage]
                                  : const Color(0x598FA3B1), 
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // E. GLASSMORPHIC CALL-TO-ACTION BUTTON
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16.0), 
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                          child: GestureDetector(
                            onTap: () {
                              if (_currentPage < _onboardingData.length - 1) {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                );
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const MainLayout()),
                                );
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 14.0),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(191), 
                                borderRadius: BorderRadius.circular(16.0),
                                border: Border.all(
                                  color: Colors.white.withAlpha(204), 
                                  width: 1.0,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF4B6573).withAlpha(30), 
                                    blurRadius: 20,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  _currentPage == _onboardingData.length - 1
                                      ? 'Start journaling →'
                                      : 'Get Started',
                                  style: const TextStyle(
                                    fontFamily: 'DMSans',
                                    color: Color(0xFF2C4A60),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}