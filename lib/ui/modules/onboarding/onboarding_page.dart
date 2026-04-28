import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';

import '../../../main/i18n/app_i18n.dart';
import '../../../main/routes/routes.dart';
import 'onboarding_presenter.dart';

class OnboardingPage extends StatefulWidget {
  final OnboardingPresenter presenter;

  const OnboardingPage({super.key, required this.presenter});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();

  @override
  void initState() {
    super.initState();
    _listenToNavigation();
  }

  void _listenToNavigation() {
    widget.presenter.navigationRouteStream.listen(
      (route) {
        if (mounted && route != null) {
          Modular.to.navigate(Routes.login);
        }
      },
    );
  }

  Future<void> _nextPage(int currentIndex) async {
    await widget.presenter.nextPage(currentIndex);

    if (!widget.presenter.isLastPage(currentIndex) && mounted) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    widget.presenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.presenter.items;

    return Scaffold(
      body: Column(
        children: [
          /// CARROSSEL
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: items.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) {
                final item = items[index];

                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(item.image, height: 250),
                      const SizedBox(height: 24),
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        item.description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          /// INDICADORES (bolinhas)
          StreamBuilder<int>(
            stream: widget.presenter.currentPageIndexStream,
            initialData: 0,
            builder: (context, snapshot) {
              final currentIndex = snapshot.data ?? 0;

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(items.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.all(4),
                    width: currentIndex == index ? 12 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: currentIndex == index ? Colors.blue : Colors.grey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              );
            },
          ),

          const SizedBox(height: 24),

          /// BOTÕES
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: StreamBuilder<int>(
              stream: widget.presenter.currentPageIndexStream,
              initialData: 0,
              builder: (context, snapshot) {
                final currentIndex = snapshot.data ?? 0;
                final isLast = widget.presenter.isLastPage(currentIndex);
                final appStrings = AppI18n.current;

                return Row(
                  children: [
                    /// VER EDITAIS
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () =>
                            Modular.to.pushNamed(Routes.noticesTerms),
                        child: Text(appStrings.onboardingViewNoticesAction),
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// ENTRAR / PRÓXIMO
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _nextPage(currentIndex),
                        child: Text(
                          isLast
                              ? appStrings.onboardingEnterAction
                              : appStrings.onboardingNextAction,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
