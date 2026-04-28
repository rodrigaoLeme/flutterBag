import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';

import '../../../main/routes/routes.dart';
import '../../components/onboarding_item.dart';
import 'onboarding_presenter.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key, required OnboardingPresenter presenter});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<OnboardingItem> items = [
    OnboardingItem(
      title: 'e-Bolsa',
      description:
          'Com o E-bolsa você solicita pedido de bolsa para qualquer unidade escolar da rede Adventista no Brasil!',
      image: 'lib/ui/assets/images/map_brasil.svg',
    ),
    OnboardingItem(
      title: '1º Passo',
      description:
          'Para concorrer a um bolsa cadastre as  informações socioeconômicas da  família e do(s) candidatos.',
      image: 'lib/ui/assets/images/group_3.svg',
    ),
    OnboardingItem(
      title: '2º Passo',
      description:
          'Envie os documentos da família e do candidato solicitados pelo edital.',
      image: 'lib/ui/assets/images/group_1.svg',
    ),
    OnboardingItem(
      title: 'Vamos começar!',
      description: '',
      image: 'lib/ui/assets/images/group_2.svg',
    ),
  ];

  void _nextPage() {
    if (_currentIndex < items.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          /// CARROSSEL
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: items.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              itemBuilder: (_, index) {
                final item = items[index];

                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(item.image ?? '', height: 250),
                      const SizedBox(height: 24),
                      Text(
                        item.title ?? '',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        item.description ?? '',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(items.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.all(4),
                width: _currentIndex == index ? 12 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentIndex == index ? Colors.blue : Colors.grey,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),

          const SizedBox(height: 24),

          /// BOTÕES
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                /// VER EDITAIS
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Modular.to.pushNamed(Routes.noticesTerms),
                    child: const Text('Ver Editais'),
                  ),
                ),

                const SizedBox(width: 12),

                /// ENTRAR / PRÓXIMO
                Expanded(
                  child: ElevatedButton(
                    onPressed: _nextPage,
                    child: Text(
                      _currentIndex == items.length - 1 ? 'Entrar' : 'Próximo',
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
