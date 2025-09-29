import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../core/icons/ebolsas_icons_icons.dart';
import '../../core/widgets/alternative_rounded_button.dart';
import '../../core/widgets/background_icon.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_rounded_button.dart';
import '../../core/widgets/custom_scaffold.dart';
import '../../core/widgets/custom_step.dart';
import '../../core/widgets/custom_stepper.dart';
import '../../core/widgets/custom_tab_bar.dart';
import '../../core/widgets/custom_text_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/dotted_border_button.dart';
import '../../core/widgets/expansion_sub_group_card.dart';
import '../../core/widgets/group_card.dart';
import '../../core/widgets/home_user_avatar.dart';
import '../../core/widgets/modal_bottom_sheet_wrapper.dart';
import '../../core/widgets/select_option_widget.dart';
import '../../core/widgets/show_add_more_documents_dialog.dart';
import '../../core/widgets/show_successful_attachment_dialog.dart';
import '../../core/widgets/small_subgroup_card.dart';
import '../../core/widgets/sub_group_card.dart';
import 'camera/camera_example.dart';
import 'camera/camera_overlay.dart';
import 'camera/document_scanner_example.dart';
import 'result_page_example.dart';

const accentColor = Color(0xFF102C4E);
const successColor = Color(0xFF00A357);

class DesignSystemPage extends StatefulWidget {
  const DesignSystemPage({Key? key}) : super(key: key);

  @override
  State<DesignSystemPage> createState() => _DesignSystemPageState();
}

class _DesignSystemPageState extends State<DesignSystemPage> with SingleTickerProviderStateMixin {
  late final FocusNode cpfNode;
  late final FocusNode senhaNode;
  late final FocusNode enterButtonNode;

  final tabs = [
    const CustomTab('Renovações'),
    const CustomTab('Novos'),
  ];
  late TabController tabController;

  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
    cpfNode = FocusNode();
    senhaNode = FocusNode();
    enterButtonNode = FocusNode();
    tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    cpfNode.dispose();
    senhaNode.dispose();
    enterButtonNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = colorScheme.primary;
    final secondaryColor = colorScheme.secondary;
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        children: [
          const PageWidgetPresentation(name: 'Result Page Example', child: ResultPageExample()),
          WidgetPresentation(
            name: 'Successfully sent document + edit',
            child: ExpansionSubGroupCard(
              subGroupCard: SubGroupCard.success(
                title: 'Comprovante de endereço',
                onTap: () {},
              ),
              content: const Text('Hello World'),
              trailingWhenExpanded: const Icon(
                Icons.close,
                color: Color(0xFFB1F3D4),
              ),
            ),
          ),
          WidgetPresentation(
            name: 'Expansion Sub Group Card V2',
            child: ExpansionSubGroupCardV2(
              subGroupCard: SubGroupCard.initial(
                title: 'Comprovante de Endereço',
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
              ),
              content: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DottedBorderButton(
                          leading: Icon(Icons.camera_alt_rounded, color: primaryColor, size: 20),
                          label: 'Tire uma foto',
                          labelColor: primaryColor,
                          onTap: () {},
                        ),
                        const SizedBox(height: 14),
                        DottedBorderButton(
                          leading: Icon(Icons.attachment_rounded, color: primaryColor, size: 20),
                          label: 'Selecione do celular',
                          labelColor: primaryColor,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              isExpanded: isExpanded,
            ),
          ),
          PageWidgetPresentation(
              name: 'Camera Overlay',
              child: Scaffold(
                  backgroundColor: Colors.black,
                  body: CameraOverlay(
                    onTapToSwitchCameras: () {},
                    onTapToTakePicture: () {},
                  ))),
          const PageWidgetPresentation(name: 'Camera use case', child: CameraExample()),
          const PageWidgetPresentation(name: 'Document Scanner', child: DocumentScannerExample()),
          WidgetPresentation(
            name: '#1 Login Components',
            children: [
              const SizedBox(height: 10),
              CustomTextField(
                focusNode: cpfNode,
                onChanged: (value) {},
                label: 'CPF',
                labelColor: accentColor,
                onEditingComplete: () {
                  senhaNode.requestFocus();
                },
                keyboardType: TextInputType.number,
                inputFormatters: [
                  MaskTextInputFormatter(mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy)
                ],
              ),
              const SizedBox(height: 40),
              CustomTextField(
                focusNode: senhaNode,
                onChanged: (value) {},
                label: 'Senha',
                labelColor: accentColor,
                isSecret: true,
                onEditingComplete: () {
                  enterButtonNode.requestFocus();
                },
              ),
              const SizedBox(height: 40),
              CustomTextButton(onTap: () {}, label: 'Esqueci minha senha', labelColor: primaryColor),
              const SizedBox(height: 40),
              CustomRoundedButton(
                focusNode: enterButtonNode,
                backgroundColor: primaryColor,
                label: 'Entrar',
                labelColor: secondaryColor,
                onTap: () {},
              ),
              const SizedBox(height: 20),
            ],
          ),
          WidgetPresentation(
            name: '#2 Group Cards',
            children: [
              GroupCard.initial(
                leading: Icon(EbolsasIcons.icon_metro_home, size: 18, color: primaryColor),
                title: 'Grupo familiar',
                onTap: () {},
              ),
              GroupCard.success(
                leading: const Icon(EbolsasIcons.icon_metro_home, size: 18, color: Color(0xFF00A357)),
                title: 'Grupo familiar',
                onTap: () {},
              ),
              GroupCard.error(
                leading: Icon(EbolsasIcons.icon_metro_home, size: 18, color: primaryColor),
                title: 'Grupo familiar',
                onTap: () {},
              ),
            ],
          ),
          WidgetPresentation(
            name: '#3 Sub Group Cards',
            children: [
              SubGroupCard.initial(
                title: 'Comp. Telefone / Internet / Celular',
                onTap: () {},
              ),
              SubGroupCard.success(
                title: 'Comprovante de endereço',
                onTap: () {},
              ),
              SubGroupCard.error(
                title: 'Conta de água',
                onTap: () {},
              ),
            ],
          ),
          WidgetPresentation(
            name: '#4 Small Sub Group Cards',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SmallSubGroupCard.success(title: 'Frente', onTap: () {}),
                SmallSubGroupCard.initial(title: 'Verso', onTap: () {}),
              ],
            ),
          ),
          WidgetPresentation(
            name: '#5 Expansion Sub Group Cards',
            children: [
              ExpansionSubGroupCard(
                subGroupCard: SubGroupCard.initial(
                  title: 'Comp. Telefone / Internet / Celular',
                  onTap: () {},
                ),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SmallSubGroupCard.success(title: 'Frente', onTap: () {}),
                    SmallSubGroupCard.initial(title: 'Verso', onTap: () {}),
                  ],
                ),
              ),
              ExpansionSubGroupCard(
                subGroupCard: SubGroupCard.success(
                  title: 'Comp. Telefone / Internet / Celular',
                  onTap: () {},
                ),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SmallSubGroupCard.success(title: 'Frente', onTap: () {}),
                    SmallSubGroupCard.initial(title: 'Verso', onTap: () {}),
                  ],
                ),
              ),
              ExpansionSubGroupCard(
                subGroupCard: SubGroupCard.error(
                  title: 'Comp. Telefone / Internet / Celular',
                  onTap: () {},
                ),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SmallSubGroupCard.success(title: 'Frente', onTap: () {}),
                    SmallSubGroupCard.initial(title: 'Verso', onTap: () {}),
                  ],
                ),
              ),
            ],
          ),
          const WidgetPresentation(
            name: '#6 Home User Avatar',
            backgroundColor: Colors.black12,
            child: HomeUserAvatar(),
          ),
          PageWidgetPresentation(
            name: '#7 Custom Scaffold',
            child: CustomScaffold(
              appBar: CustomAppBar(
                preferredSize: const Size.fromHeight(87),
                title: Text(
                  'Title',
                  style: TextStyle(color: secondaryColor),
                ),
                trailing: Text(
                  'Trailing',
                  style: TextStyle(color: secondaryColor),
                ),
                bottomWidget: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    'Bottom Widget',
                    style: TextStyle(color: secondaryColor),
                  ),
                ),
              ),
            ),
          ),
          WidgetPresentation(
            name: '#8 Alternative Rounded Button',
            child: AlternativeRoundedButton(label: 'Estou ciente', onTap: () {}),
          ),
          WidgetPresentation(
            name: '#9 Custom Stepper',
            child: CustomStepper(
              physics: const NeverScrollableScrollPhysics(),
              currentStep: 1,
              margin: EdgeInsets.zero,
              controlsBuilder: (context, details) => const SizedBox(),
              steps: [
                const CustomStep(
                  title: Text('Cadastro', style: TextStyle(color: successColor)),
                  content: SizedBox(),
                  icon: Icon(EbolsasIcons.check, color: successColor, size: 40),
                ),
                CustomStep(
                  icon: const Icon(EbolsasIcons.warning, color: Color(0xFFFFC547), size: 40),
                  title: const Text('Envio de documentação', style: TextStyle(color: Color(0xFFFFC547))),
                  content: AlternativeRoundedButton(
                    label: 'Iniciar Envio',
                    onTap: () {},
                  ),
                ),
                const CustomStep(
                  icon: BackgroundIcon(icon: Icon(EbolsasIcons.revisao_de_doc, color: Color(0xFF949494), size: 40)),
                  title: Text('Revisão da documentação', style: TextStyle(fontSize: 16, color: Color(0xFF04A0F9))),
                  content: Text('Clique aqui'),
                ),
                const CustomStep(
                  icon: Icon(EbolsasIcons.clock, color: Color(0xFF04A0F9), size: 40),
                  title: Text('Revisão da documentação', style: TextStyle(fontSize: 16, color: Color(0xFF04A0F9))),
                  content: Text('Clique aqui'),
                ),
                CustomStep(
                  icon: Icon(EbolsasIcons.question_mark, color: Theme.of(context).colorScheme.error, size: 40),
                  title: Text('Revisão da documentação', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                  content: const Text('Clique aqui'),
                ),
                const CustomStep(
                  icon: BackgroundIcon(
                    icon: Icon(EbolsasIcons.avaliacao_socioconomica, color: Color(0xFF949494), size: 40),
                  ),
                  title: Text('Avaliação socioeconômica'),
                  content: Text('Clique aqui'),
                ),
                const CustomStep(
                  icon: BackgroundIcon(
                    icon: Icon(EbolsasIcons.resultado, color: Color(0xFF949494), size: 40),
                  ),
                  title: Text('Resultado'),
                  content: Text('Clique aqui'),
                ),
              ],
            ),
          ),
          WidgetPresentation(
            name: '#10 Modal Bottom Sheet Wrapper',
            child: ModalBottomSheetWrapper(
              hasScrollIcon: true,
              content: Container(
                margin: const EdgeInsets.fromLTRB(32, 32, 32, 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean quis eros eu enim gravida gravida. Nullam volutpat id leo non malesuada. Maecenas egestas dui ac odio pretium pellentesque. Aliquam purus tellus, iaculis vitae mollis in, pretium eu tellus. Maecenas nunc ligula, consectetur eu enim in, elementum accumsan orci. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Pellentesque quis nibh turpis. Vivamus ultrices, tellus in mollis aliquet, augue neque ullamcorper est, eget ultrices metus tellus sit amet turpis. Quisque tincidunt in nulla a vehicula. Suspendisse potenti. Morbi ut nisl tortor. Nunc scelerisque nec nulla et hendrerit. Curabitur non sem mollis, cursus libero sed, accumsan ligula.',
                        style: TextStyle(
                          color: Color(0xFF6B6B6B),
                        )),
                    const SizedBox(height: 24),
                    AlternativeRoundedButton(
                      label: 'Estou ciente',
                      onTap: () {
                        Navigator.maybePop(context);
                      },
                    )
                  ],
                ),
              ),
              child: const Text('Clique aqui'),
            ),
          ),
          WidgetPresentation(
            name: '#11 Custom Dialogs',
            children: [
              GestureDetector(
                child: const Text('Adicionar mais documentos: Mockup p. 12'),
                onTap: () {
                  showAddMoreDocumentsDialog(
                      context: context,
                      onTapYes: () {
                        debugPrint('--- Toquei em sim ---');
                        Modular.to.maybePop();
                      },
                      onTapNo: () {
                        debugPrint('--- Toquei em não ---');
                        Modular.to.maybePop();
                      });
                },
              ),
              GestureDetector(
                child: const Text('Documentos anexados: Mockup p. 20 e 27'),
                onTap: () {
                  showSuccessfulAttachmentDialog(
                    context: context,
                  );
                },
              ),
            ],
          ),
          WidgetPresentation(
            name: '#12 CustomTabBar',
            child: CustomTabBar(
              tabController: tabController,
              tabs: tabs,
            ),
          ),
          WidgetPresentation(
            name: 'Forgot my password fields',
            children: [
              Text(
                'Problemas para entrar?',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CustomTextField(
                onChanged: (value) {},
                label: 'E-mail',
                labelColor: accentColor,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
              CustomRoundedButton(
                backgroundColor: primaryColor,
                label: 'Enviar',
                labelColor: secondaryColor,
              ),
            ],
          ),
          WidgetPresentation(
              name: 'SelectOptionWidget',
              child: SelectOptionWidget(
                selectedIndex: 3,
                title: 'Selecione o ano do processo',
                onChanged: (p0) {},
                items: const ['2022', '2021', '2020', '2019', '2018', '2017'],
              )),
        ],
      ),
    );
  }
}

class WidgetPresentation extends StatelessWidget {
  final String name;
  final Widget? child;
  final List<Widget>? children;
  final Color? backgroundColor;
  const WidgetPresentation({Key? key, required this.name, this.child, this.children, this.backgroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final finalChildren = <Widget>[];
    if (children != null || child != null) {
      finalChildren.add(const SizedBox(height: 10));
    }
    if (children != null) {
      finalChildren.addAll(children!);
    }
    if (child != null) {
      finalChildren.addAll([child!]);
    }
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: primaryColor),
        color: backgroundColor,
      ),
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: primaryColor),
          ),
          ...finalChildren,
        ],
      ),
    );
  }
}

class PageWidgetPresentation extends WidgetPresentation {
  const PageWidgetPresentation({super.key, required super.name, required super.child});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: primaryColor),
        color: backgroundColor,
      ),
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(10),
      child: TextButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => child!),
          );
        },
        child: Text('Next page: $name'),
      ),
    );
  }
}
