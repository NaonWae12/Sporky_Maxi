import 'package:flutter/material.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/views/initial_display/login_page.dart';

import '../../components/globals/button/globals_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // checkSession();
  }

  final List<WelcomeSlider> welcomeSlider = [
    WelcomeSlider(
      title: 'Bunda Nggak Perlu Bingung Masak!',
      description:
          "Menu harian sehat & lezat sudah disiapkan sesuai usia dan kebutuhan nutrisi anak.",
      image: 'assets/imagewlc1.png',
    ),
    WelcomeSlider(
      title: 'Ngobrol Langsung dengan Ahlinya',
      description:
          "Konsultasi cepat dan nyaman bersama dokter atau ahli gizi terpercaya, via chat atau Zoom.",
      image: 'assets/imagewlc2.png',
    ),
    WelcomeSlider(
      title: 'Catat Perkembangan Anak Lebih Praktis',
      description:
          "Pantau tinggi, berat, dan pola makan anak dalam satu tempat. Lebih mudah dan teratur!",
      image: 'assets/imagewlc3.png',
    ),
    WelcomeSlider(
      title: 'Pahami Selera Makan Anak',
      description:
          "Catat sisa makanan untuk bantu kenali makanan favorit dan rekomendasi menu yang lebih pas.",
      image: 'assets/imagewlc4.png',
    ),
  ];

  void _nextPage() {
    if (_currentPage < welcomeSlider.length - 1) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.base5,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                  child: Text('Skip',
                      style: AppTextStyles.list1Regular(AppColors.primary1)),
                ),
              ),
              // PageView
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: welcomeSlider.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final item = welcomeSlider[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(item.image, height: 250),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            item.title,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.heading1SemiBold(),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            item.description,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.headList1Regular(),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              // Page Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  welcomeSlider.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 16 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? Colors.orange
                          : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Button
              GlobalsButton(
                text: _currentPage == welcomeSlider.length - 1
                    ? "Masuk"
                    : "Selanjutnya",
                onPressed: _nextPage,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 15,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class WelcomeSlider {
  final String title;
  final String description;
  final String image;

  WelcomeSlider({
    required this.title,
    required this.description,
    required this.image,
  });
}
