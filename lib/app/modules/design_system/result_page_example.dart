import 'package:flutter/material.dart';

import '../../core/icons/ebolsas_icons_icons.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_scaffold.dart';

class ResultPageExample extends StatefulWidget {
  const ResultPageExample({Key? key}) : super(key: key);

  @override
  State<ResultPageExample> createState() => _ResultPageExampleState();
}

class _ResultPageExampleState extends State<ResultPageExample> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return CustomScaffold(
      appBar: const CustomAppBar(),
      body: Container(
        margin: const EdgeInsets.only(left: 32.5, top: 26, right: 32.5),
        child: Column(
          children: [
            Row(
              children: const [
                Icon(
                  EbolsasIcons.icon_resultado,
                  color: Color(0xFFE89F01),
                ),
                SizedBox(width: 17),
                Text(
                  'Resultado',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF2A600),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(thickness: 1, height: 30),
                itemCount: 2,
                itemBuilder: (context, index) => SizedBox(
                  height: height * 0.3,
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          children: const [
                            Text(
                              'João Silva',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF102C4E),
                              ),
                            ),
                            SizedBox(width: 32),
                            ResultWidget.approved(),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: const [
                            Text(
                              'Processo: 04/04/22 - 10/04/22',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF003366),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'Parabéns!!',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF003366),
                              ),
                            ),
                            Text(
                              'O aluno João Silva foi aprovado no processo de Bolsas na Escola Adventista da Liberdade.',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF003366),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          Text(
                            'Saber mais',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF04A0F9),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultWidget extends StatelessWidget {
  final String label;
  final Color labelColor;
  final Color backgroundColor;
  const ResultWidget({Key? key, required this.label, required this.labelColor, required this.backgroundColor}) : super(key: key);

  const factory ResultWidget.approved() = _ResultWidgetApproved;

  const factory ResultWidget.disapproved() = _ResultWidgetDisapproved;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: backgroundColor,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: labelColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ResultWidgetApproved extends ResultWidget {
  const _ResultWidgetApproved() : super(label: 'APROVADO', labelColor: const Color(0xFF00A357), backgroundColor: const Color(0xFFDCFFEF));
}

class _ResultWidgetDisapproved extends ResultWidget {
  const _ResultWidgetDisapproved()
      : super(label: 'RECUSADO', labelColor: const Color(0xFFE62020), backgroundColor: const Color(0xFFFFC2C2));
}
