import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static final List<WelcomeSlider> _welcomeSlider = [
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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _welcomeSlider.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _openLoginPage();
    }
  }

  void _openLoginPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final showSkip =
        _currentPage > 0 && _currentPage < _welcomeSlider.length - 1;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.base5,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                SizedBox(
                  height: 42,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IgnorePointer(
                      ignoring: !showSkip,
                      child: Opacity(
                        opacity: showSkip ? 1 : 0,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: _openLoginPage,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 2,
                              vertical: 10,
                            ),
                            child: Text(
                              'Skip',
                              style: AppTextStyles.list1Regular(
                                AppColors.primary1,
                              ).copyWith(height: 16 / 12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _welcomeSlider.length,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemBuilder: (context, index) {
                      return _WelcomeSlide(item: _welcomeSlider[index]);
                    },
                  ),
                ),
                _PageIndicator(
                  currentPage: _currentPage,
                  itemCount: _welcomeSlider.length,
                ),
                const SizedBox(height: 16),
                GlobalsButton(
                  text: 'Selanjutnya',
                  onPressed: _nextPage,
                  height: 48,
                  radius: 16,
                  elevation: 0,
                  customTextStyle: AppTextStyles.headList1Bold(
                    AppColors.base5,
                  ).copyWith(height: 20 / 16),
                ),
                const SizedBox(height: 46),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WelcomeSlide extends StatelessWidget {
  const _WelcomeSlide({required this.item});

  final WelcomeSlider item;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final contentWidth = (screenWidth - 32).clamp(0.0, 343.0);

    return Center(
      child: SizedBox(
        width: contentWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.square(
              dimension: contentWidth,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Image.asset(item.image, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              item.title,
              textAlign: TextAlign.center,
              style: AppTextStyles.display1SemiBold(
                AppColors.base1,
              ).copyWith(height: 26 / 24),
            ),
            const SizedBox(height: 8),
            Text(
              item.description,
              textAlign: TextAlign.center,
              style: AppTextStyles.headList1Regular(
                AppColors.base1,
              ).copyWith(height: 20 / 16),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.currentPage, required this.itemCount});

  final int currentPage;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        final isActive = currentPage == index;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary1 : AppColors.base3,
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
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
