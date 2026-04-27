import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {

  final VoidCallback onFinish;

  const OnboardingScreen({
    super.key,
    required this.onFinish,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  final PageController _controller = PageController();
  int currentPage = 0;

  List<Map<String, String>> pages = [
    {"image": "assets/images/onboarding1.png"},
    {"image": "assets/images/onboarding2.png"},
    {"image": "assets/images/onboarding3.png"},
  ];

  void finalizarOnboarding() {
    widget.onFinish();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [

          // 🖼️ PÁGINAS
          PageView.builder(
            controller: _controller,
            itemCount: pages.length,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemBuilder: (_, index) {
              return Image.asset(
                pages[index]["image"]!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              );
            },
          ),

          // 🔘 INDICADORES
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(pages.length, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: currentPage == index ? 12 : 8,
                  height: currentPage == index ? 12 : 8,
                  decoration: BoxDecoration(
                    color: currentPage == index
                        ? Colors.orange
                        : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ),

          // ⏭ SKIP (ÚNICO BOTÓN)
          Positioned(
            top: 40,
            right: 20,
            child: TextButton(
              onPressed: finalizarOnboarding,
              child: const Text(
                "Skip",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),

          Positioned(
  bottom: 40,
  right: 20,
  child: TextButton(
    onPressed: finalizarOnboarding,
    child: const Text(
      "Comenzar ahora",
      style: TextStyle(
        color: Colors.white,
        fontSize: 13,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
),
        ],
      ),
    );
  }
}