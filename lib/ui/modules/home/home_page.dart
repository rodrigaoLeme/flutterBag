import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../main/i18n/app_i18n.dart';
import '../../components/components.dart';
import '../../helpers/themes/themes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final appStrings = AppI18n.current;
  //TODO Remover o mockYear
  final mockYear = 2026;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        actionsPadding: EdgeInsets.only(
          right: 4,
        ),
        centerTitle: false,
        title: Text(
          'Olá, Maria!',
          style: AppTextStyles.titleLarge.copyWith(
            fontSize: 22,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu), // Ícone do botão
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'lib/ui/assets/images/banner-home.png',
            ),
            EBolsaYearSelector(
              years: [2027, 2026, 2025, 2024, 2023, 2022, 2021, 2020],
              selectedYear: 2027,
              onYearSelected: (year) {
                print(year);
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsetsGeometry.fromLTRB(12, 24, 12, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        appStrings.homeTitle,
                        style: AppTextStyles.titleLarge.copyWith(
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${appStrings.homeSubtitleEmptyProcess} $mockYear',
                        style: AppTextStyles.bodyMedium,
                      ),
                      const SizedBox(height: 40),
                      EbolsaButton(
                        onPressed: () {},
                        label: appStrings.homeRenewScholarshipButton,
                      ),
                      const SizedBox(height: 16),
                      EbolsaButton(
                        onPressed: () {},
                        label: appStrings.homeNewScholarshipButton,
                        isOutlined: true,
                      ),
                      const SizedBox(height: 40),
                      EbolsaImportantBanner(
                        title: appStrings.homeImportantTitle,
                        message: appStrings.homeImportantMessage,
                      ),
                      //'')
                    ],
                  ),
                ),
              ),
            ),
            // ElevatedButton(
            //   onPressed: () async {
            //     await sl<SecureStorage>().clean();
            //     Modular.to.navigate(AuthRoutes.login);
            //   },
            //   child: const Text('Sair'),
            // ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            //_currentIndex = index; // Atualiza o estado
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: SvgPicture.asset('lib/ui/assets/icons/notice-icon.svg'),
              label: 'Editais'),
          BottomNavigationBarItem(
              icon: SvgPicture.asset('lib/ui/assets/icons/home-icon.svg'),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: SvgPicture.asset('lib/ui/assets/icons/person-icon.svg'),
              label: 'Perfil'),
        ],
      ),
    );
  }
}
