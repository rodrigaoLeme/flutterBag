import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart' as triple;
import 'package:localization/localization.dart';
import 'package:upgrader/upgrader.dart';

import '../../../../main.dart';
import '../../../core/constants/process_type.dart';
import '../../../core/constants/review_type.dart';
import '../../../core/icons/ebolsas_icons_icons.dart';
import '../../../core/widgets/alternative_rounded_button.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_scaffold.dart';
import '../../../core/widgets/custom_tab_bar.dart';
import '../../../core/widgets/select_option_widget.dart';
import '../../../core/widgets/show_custom_dialog.dart';
import '../../../core/widgets/show_custom_modal_bottom_sheet.dart';
import '../../review_documents/presenter/pages/select_group_with_pendences/scholarship_with_pendences_dto.dart';
import '../domain/usecases/get_process_periods/entity.dart';
import 'stores/home_store.dart';
import 'stores/home_store_states.dart';
import 'stores/usecases/get_processes_years/store.dart' as processes_years;
import 'stores/usecases/get_scholarship_by_period/store.dart' as scholarship;
import 'widgets/process_new_stepper.dart';
import 'widgets/process_renewal_stepper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final store = Modular.get<HomeStore>();

  late final String tabFresh;
  late final String tabRenewal;
  late final String greetings;
  late final String logout;
  late final String selectProcessYear;
  late final String tryAgain;
  late final String unavailableDocumentationUploadDeadline;
  late final String logoutDialogTitle;
  late final String logoutDialogOptionYes;
  late final String logoutDialogOptionNo;
  late final String protocolsHistory;
  late triple.Disposer getScholarshipByPeriodObserver;
  StreamSubscription? pushNotificationSubscription;

  void initLocalizedStrings() {
    tabFresh = getLocalization('tab_fresh');
    tabRenewal = getLocalization('tab_renewal');
    greetings = getLocalization('greetings', params: [store.username]);
    logout = getLocalization('logout');
    selectProcessYear = getLocalization('select_process_year');
    tryAgain = getLocalization('try_again');
    unavailableDocumentationUploadDeadline =
        getLocalization('unavailable_documentation_upload_deadline');
    logoutDialogTitle = getLocalization('logout_dialog_title');
    logoutDialogOptionYes = getLocalization('logout_dialog_option_yes');
    logoutDialogOptionNo = getLocalization('logout_dialog_option_no');
    protocolsHistory = getLocalization('protocols_history');
  }

  String getLocalization(String attribute, {List<String>? params}) =>
      'home_$attribute'.i18n(params ?? []);

  late List<CustomTab> tabs;
  TabController? tabController;

  var lock = false;

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance.setCurrentScreen(screenName: 'Home_Page');
    initLocalizedStrings();

    init();
    startObservingGetScholarshipByPeriodStore();
  }

  void startObservingGetScholarshipByPeriodStore() {
    store.getScholarshipUsecaseStore.observer(
      onError: (error) => showSnackBar(error.toString()),
    );
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void init() {
    getAllProcessesYears().then((value) {
      if (store.error != null) return;
      getAllProcessesPeriods(store.state.year).then((value) async {
        if (store.error != null) return;
        initTabController(
            store.state.processesNew, store.state.processesRenewal);
        await initializeProcesses();
      });
    });
    store.initPushNotification().then((value) {
      pushNotificationSubscription =
          FirebaseMessaging.onMessage.listen(showFlutterNotification);
    });
  }

  void initTabController(
      List<Process> processesNew, List<Process> processesRenewal) {
    tabs = [
      if (processesRenewal.isNotEmpty)
        CustomTab(tabRenewal,
            onTap: processesNew.isEmpty && processesRenewal.length > 1
                ? chooseAnotherProcessRenewal
                : null),
      if (processesNew.isNotEmpty)
        CustomTab(tabFresh,
            onTap: processesRenewal.isEmpty && processesNew.length > 1
                ? chooseAnotherProcessNew
                : null),
    ];
    if (tabController != null) tabController!.dispose();
    tabController = TabController(length: tabs.length, vsync: this);
    if (processesNew.isNotEmpty && processesRenewal.isNotEmpty)
      tabController?.animateTo(1);
  }

  Future<void> initializeProcesses() async {
    store.setLoading(true, force: true);
    final processesNew = store.state.processesNew;
    final processesRenewal = store.state.processesRenewal;
    if (processesNew.isEmpty && processesRenewal.isEmpty) return;
    final futures = <Future Function()>[];
    if (processesNew.isNotEmpty) {
      if (processesNew.length == 1) {
        //tabController!.animateTo(processesRenewal.isEmpty ? 0 : processesNew.first.processType.index);
        futures.add(() => getScholarshipByPeriod(
            processesNew.first.id, processesNew.first.processType));
      } else {
        final process = await showProcessSheet(processesNew);
        //TODO(adbysantos) Se o usuário não escolher nenhum, configurar o primeiro
        //tabController!.animateTo(processesNew.first.processType.index);
        futures.add(
            () => getScholarshipByPeriod(process!.id, process.processType));
        tabController!.addListener(listenForProcessTypeNew);
      }
      if (processesRenewal.isNotEmpty) {
        if (processesRenewal.length == 1) {
          futures.add(() => getScholarshipByPeriod(
              processesRenewal.first.id, processesRenewal.first.processType));
        } else {
          tabController!.addListener(listenForProcessTypeRenewal);
        }
      }
    } else {
      if (processesRenewal.length == 1) {
        futures.add(() => getScholarshipByPeriod(
            processesRenewal.first.id, processesRenewal.first.processType));
      } else {
        final process = await showProcessSheet(processesRenewal);
        futures.add(
            () => getScholarshipByPeriod(process!.id, process.processType));
      }
    }
    for (final futureFunction in futures) {
      await futureFunction();
    }
    store.update(store.state, force: true);
    store.setLoading(false, force: true);
  }

  void listenForProcessTypeRenewal() async {
    if (store.state.processesRenewal.isEmpty) return;
    if (tabController!.index == 0 &&
        tabController!.indexIsChanging &&
        (store.state.chosenProcessRenewal.id.isEmpty ||
            store.state.processesRenewal.length > 1)) {
      store.setLoading(true, force: true);
      final previousEmptyProcessRenewal = store.state.chosenProcessRenewal;
      final chosenProcessRenewal =
          await showProcessSheet(store.state.processesRenewal);
      if (chosenProcessRenewal?.id == previousEmptyProcessRenewal.id) {
        store.update(store.state, force: true);
        return store.setLoading(false, force: true);
      }
      final setProcessRenewal =
          chosenProcessRenewal ?? previousEmptyProcessRenewal;
      if (setProcessRenewal.id.isNotEmpty) {
        getScholarshipByPeriod(
                setProcessRenewal.id, setProcessRenewal.processType)
            .then((value) {
          store.update(
              store.state.copyWith(chosenProcessRenewal: setProcessRenewal));
        }).whenComplete(() => store.setLoading(false, force: true));
      }
    }
  }

  void listenForProcessTypeNew() async {
    if (store.state.processesNew.isEmpty) return;
    if (tabController!.index == 1 &&
        tabController!.indexIsChanging &&
        (store.state.chosenProcessRenewal.id.isEmpty ||
            store.state.processesRenewal.length > 1)) {
      store.setLoading(true, force: true);
      final previousEmptyProcessNew = store.state.chosenProcessNew;
      final chosenProcessNew = await showProcessSheet(store.state.processesNew);
      if (chosenProcessNew?.id == previousEmptyProcessNew.id) {
        store.update(store.state, force: true);
        return store.setLoading(false, force: true);
      }
      final setProcessNew = chosenProcessNew ?? previousEmptyProcessNew;
      if (setProcessNew.id.isNotEmpty) {
        getScholarshipByPeriod(setProcessNew.id, setProcessNew.processType)
            .then((value) {
          store.update(store.state.copyWith(chosenProcessNew: setProcessNew));
        }).whenComplete(() => store.setLoading(false, force: true));
      }
    }
  }

  Future<void> chooseAnotherProcessRenewal() async {
    if (store.state.processesRenewal.length < 2) return;
    store.setLoading(true, force: true);
    final previousEmptyProcessRenewal = store.state.chosenProcessRenewal;
    final chosenProcessRenewal =
        await showProcessSheet(store.state.processesRenewal);
    if (chosenProcessRenewal?.id == previousEmptyProcessRenewal.id) {
      store.update(store.state, force: true);
      return store.setLoading(false, force: true);
    }
    final setProcessRenewal =
        chosenProcessRenewal ?? previousEmptyProcessRenewal;
    if (setProcessRenewal.id.isNotEmpty) {
      getScholarshipByPeriod(
              setProcessRenewal.id, setProcessRenewal.processType)
          .then((value) {
        store.update(
            store.state.copyWith(chosenProcessRenewal: setProcessRenewal));
      }).whenComplete(() => store.setLoading(false, force: true));
    }
  }

  Future<void> chooseAnotherProcessNew() async {
    if (store.state.processesNew.length < 2) return;
    store.setLoading(true, force: true);
    final previousEmptyProcessNew = store.state.chosenProcessNew;
    final chosenProcessNew = await showProcessSheet(store.state.processesNew);
    if (chosenProcessNew?.id == previousEmptyProcessNew.id) {
      store.update(store.state, force: true);
      return store.setLoading(false, force: true);
    }
    final setProcessNew = chosenProcessNew ?? previousEmptyProcessNew;
    if (setProcessNew.id.isNotEmpty) {
      getScholarshipByPeriod(setProcessNew.id, setProcessNew.processType)
          .then((value) {
        store.update(store.state.copyWith(chosenProcessNew: setProcessNew));
      }).whenComplete(() => store.setLoading(false, force: true));
    }
  }

  Future<Process?> showProcessSheet(List<Process> processList) {
    return showCustomModalBottomSheet<Process>(
      context: context,
      hasScrollIcon: true,
      isDismissible: false,
      content: (context) {
        return Column(
          children: [
            const SizedBox(height: 24),
            RichText(
              text: const TextSpan(
                text: 'Selecione o ',
                style: TextStyle(color: Color(0xFF4B4B4B), fontSize: 16),
                children: [
                  TextSpan(
                    text: 'processo',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            ListView.separated(
              shrinkWrap: true,
              itemCount: processList.length,
              separatorBuilder: (context, index) => const Divider(
                indent: 16,
                endIndent: 16,
                color: Color(0xFFE3E8EB),
                thickness: 1,
              ),
              itemBuilder: (context, index) {
                final process = processList[index];
                return ListTile(
                  title: Text(
                    '${formatPeriodsDates(process.registerStart)} - ${formatPeriodsDates(process.registerEnd)}',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  onTap: () {
                    Navigator.pop(context, process);
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  String formatPeriodsDates(String date) {
    final dateTime = DateTime.tryParse(date);
    if (dateTime == null) {
      store.setError('Não foi possível recuperar as datas dos processos');
      return '';
    }
    final year =
        dateTime.year.toString().substring(dateTime.year.toString().length - 2);
    final month = dateTime.month.toString();
    final day = dateTime.day.toString();

    final finalDay = day.length == 1 ? '0$day' : day;
    final finalMonth = month.length == 1 ? '0$month' : month;
    final finalYear = year.length == 1 ? '0$year' : year;

    return '$finalDay/$finalMonth/$finalYear';
  }

  Future<void> getAllProcessesYears() => store.getAllProcessesYears();
  Future<void> getAllProcessesPeriods(int year) =>
      store.getAllProcessPeriods(year);
  Future<void> getScholarshipByPeriod(
          String periodId, ProcessType processType) =>
      store.getScholarshipByPeriod(periodId, processType);

  Future<void> onSetAnotherYear() async {
    final newSetYear = store.state.year;
    return getAllProcessesPeriods(newSetYear).then((value) async {
      if (store.error != null) return;
      initTabController(store.state.processesNew, store.state.processesRenewal);
      await initializeProcesses();
    });
  }

  void retryInitializeHome() {
    init();
  }

  @override
  void dispose() {
    if (tabController != null) tabController!.dispose();
    pushNotificationSubscription?.cancel();
    super.dispose();
  }

  Future onTapResendDocuments(String scholarshipId) {
    return Modular.to.pushNamed('review_documents_with_pendences/',
        arguments: ScholarshipWithPendencesDto(id: scholarshipId));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final secondaryColor = colorScheme.secondary;
    final primaryColor = colorScheme.primary;
    return UpgradeAlert(
      dialogStyle: Platform.isIOS
          ? UpgradeDialogStyle.cupertino
          : UpgradeDialogStyle.material,
      showIgnore: false,
      showLater: false,
      upgrader: Upgrader(durationUntilAlertAgain: Duration.zero),
      child: CustomScaffold(
        appBar: CustomAppBar(
          automaticallyImplyLeading: false,
          title: Container(
            margin: const EdgeInsets.only(left: 20),
            child: Text(
              greetings,
              style: TextStyle(color: secondaryColor, fontSize: 16),
            ),
          ),
          trailing: Container(
            margin: const EdgeInsets.only(right: 5),
            child: Row(
              children: [
                if (kDebugMode)
                  ElevatedButton.icon(
                      onPressed: () => Modular.to.pushNamed('../ds'),
                      icon: const Icon(Icons.design_services),
                      label: const Text('DS')),
                const SizedBox(width: 10),
                ElevatedButton(
                  // style: ButtonStyle(
                  //   elevation: WidgetStateProperty.resolveWith((states) => 0),
                  // ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                  ),
                  child: Icon(EbolsasIcons.icone_menu,
                      color: secondaryColor, size: 16),
                  onPressed: () => store.state is SettingsState
                      ? store.backToHome()
                      : store.goToSettings(),
                ),
              ],
            ),
          ),
        ),
        body: triple.ScopedBuilder<HomeStore, String, HomeStoreState>(
          store: store,
          onError: (context, error) => Stack(
            children: [
              Row(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  AlternativeRoundedButton(
                    label: store.state.year.toString(),
                    backgroundColor: const Color(0xFFDFF2FC),
                    onTap: () {
                      if (store.state.year < 0) return;
                      showCustomModalBottomSheet(
                        hasScrollIcon: true,
                        context: context,
                        content: (context) => Center(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                            child: triple.TripleBuilder<HomeStore, String,
                                HomeStoreState>(
                              store: store,
                              builder: (context, state) {
                                if (store.isLoading) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                return triple.ScopedBuilder<
                                    processes_years.Store,
                                    processes_years.UsecaseException,
                                    processes_years.Entity>(
                                  store: store.getYearsUsecaseStore,
                                  onState: (context, state) {
                                    final years = state.years;
                                    return SelectOptionWidget(
                                      items: years
                                          .map((e) => e.toString())
                                          .toList(),
                                      onChanged: (selectedYearIndex) {
                                        final newSelectedYear =
                                            years[selectedYearIndex];
                                        if (newSelectedYear !=
                                            store.state.year) {
                                          store.setProcessYear(newSelectedYear);
                                          onSetAnotherYear();
                                        }
                                      },
                                      title: selectProcessYear,
                                      selectedIndex: () {
                                        final currentSelectedYearIndex =
                                            years.indexWhere((element) =>
                                                element == store.state.year);
                                        return currentSelectedYearIndex;
                                      }(),
                                    );
                                  },
                                  onLoading: (context) =>
                                      const CircularProgressIndicator(),
                                  onError: (context, exception) {
                                    final years =
                                        store.getYearsUsecaseStore.state.years;
                                    return SelectOptionWidget(
                                      items: years
                                          .map((e) => e.toString())
                                          .toList(),
                                      onChanged: (selectedYearIndex) {
                                        debugPrint(
                                            selectedYearIndex.toString());
                                        final newSelectedYear =
                                            years[selectedYearIndex];
                                        if (newSelectedYear !=
                                            store.state.year) {
                                          store.setProcessYear(newSelectedYear);
                                          onSetAnotherYear();
                                        }
                                      },
                                      title: selectProcessYear,
                                      selectedIndex: () {
                                        final currentSelectedYearIndex =
                                            years.indexWhere((element) =>
                                                element == store.state.year);
                                        return currentSelectedYearIndex;
                                      }(),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(error.toString(), textAlign: TextAlign.center),
                    AlternativeRoundedButton(
                        label: tryAgain, onTap: retryInitializeHome),
                  ],
                ),
              ),
            ],
          ),
          onLoading: (context) =>
              const Center(child: CircularProgressIndicator()),
          onState: (context, state) {
            if (state is SettingsState) {
              return Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.logout, color: primaryColor),
                      title: Text(logout,
                          style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 16)),
                      onTap: () => showLogoutDialog(context),
                    ),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async => init(),
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 54,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AlternativeRoundedButton(
                            label: store.state.year.toString(),
                            backgroundColor: const Color(0xFFDFF2FC),
                            onTap: () {
                              if (store.state is! SuccessState) return;
                              showCustomModalBottomSheet(
                                hasScrollIcon: true,
                                context: context,
                                content: (context) => Center(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        16, 16, 16, 32),
                                    child: triple.TripleBuilder<HomeStore,
                                        String, HomeStoreState>(
                                      store: store,
                                      builder: (context, state) {
                                        if (store.isLoading) {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                        return triple.ScopedBuilder<
                                            processes_years.Store,
                                            processes_years.UsecaseException,
                                            processes_years.Entity>(
                                          store: store.getYearsUsecaseStore,
                                          onState: (context, state) {
                                            final years = state.years;
                                            return SelectOptionWidget(
                                              items: years
                                                  .map((e) => e.toString())
                                                  .toList(),
                                              onChanged: (selectedYearIndex) {
                                                debugPrint(selectedYearIndex
                                                    .toString());
                                                final newSelectedYear =
                                                    years[selectedYearIndex];
                                                if (newSelectedYear !=
                                                    store.state.year) {
                                                  store.setProcessYear(
                                                      newSelectedYear);
                                                  onSetAnotherYear();
                                                }
                                              },
                                              title: selectProcessYear,
                                              selectedIndex: () {
                                                final currentSelectedYearIndex =
                                                    years.indexWhere(
                                                        (element) =>
                                                            element ==
                                                            store.state.year);
                                                return currentSelectedYearIndex;
                                              }(),
                                            );
                                          },
                                          onLoading: (context) =>
                                              const CircularProgressIndicator(),
                                          onError: (context, exception) {
                                            final years = store
                                                .getYearsUsecaseStore
                                                .state
                                                .years;
                                            return SelectOptionWidget(
                                              items: years
                                                  .map((e) => e.toString())
                                                  .toList(),
                                              onChanged: (selectedYearIndex) {
                                                debugPrint(selectedYearIndex
                                                    .toString());
                                                final newSelectedYear =
                                                    years[selectedYearIndex];
                                                if (newSelectedYear !=
                                                    store.state.year) {
                                                  store.setProcessYear(
                                                      newSelectedYear);
                                                  onSetAnotherYear();
                                                }
                                              },
                                              title: selectProcessYear,
                                              selectedIndex: () {
                                                final currentSelectedYearIndex =
                                                    years.indexWhere(
                                                        (element) =>
                                                            element ==
                                                            store.state.year);
                                                return currentSelectedYearIndex;
                                              }(),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.01),
                          if (state is SuccessState &&
                              (state.chosenProcessNew.id.isNotEmpty ||
                                  state.chosenProcessRenewal.id.isNotEmpty))
                            CustomTabBar(
                                tabController: tabController!, tabs: tabs),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: tabController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            //Aba RENOVAÇÕES
                            if (state.processesRenewal.isNotEmpty)
                              triple.ScopedBuilder<scholarship.Store, String,
                                  scholarship.StoreState>(
                                store: store.getScholarshipUsecaseStore,
                                onError: (context, error) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: Text(error.toString()),
                                  );
                                },
                                onLoading: (context) => const Center(
                                    child: CircularProgressIndicator()),
                                onState: (context, state) {
                                  final renewalScholarship =
                                      state.processRenewal;
                                  final chosenProcessRenewal =
                                      store.state.chosenProcessRenewal;
                                  final reversedScholarshipReviews =
                                      renewalScholarship
                                          .scholarshipReviews.reversed
                                          .toList();
                                  final child = ProcessRenewalStepper(
                                    renewalScholarship: renewalScholarship,
                                    processRenewal: chosenProcessRenewal,
                                    onTapSendDocuments: () {
                                      store.setScholarshipIdForSelectGroupPage(
                                          renewalScholarship.id);
                                      Modular.to
                                          .pushNamed('select_group')
                                          .then((response) {
                                        if (response == true) {
                                          init();
                                        }
                                      });
                                    },
                                    onDateTimeError: () => store.setException(
                                        unavailableDocumentationUploadDeadline),
                                    onTapResendDocuments: () {
                                      onTapResendDocuments(
                                              renewalScholarship.id)
                                          .then((response) {
                                        if (response == true) {
                                          init();
                                        }
                                      });
                                    },
                                    onTapHistoryReview: () {
                                      showCustomModalBottomSheet(
                                        context: context,
                                        hasScrollIcon: true,
                                        content: (context) {
                                          return DefaultTextStyle(
                                            style: TextStyle(
                                                color: primaryColor,
                                                fontSize: 14),
                                            child: ListView.separated(
                                              itemCount: renewalScholarship
                                                      .scholarshipReviews
                                                      .length +
                                                  1,
                                              separatorBuilder: (_, __) =>
                                                  const Divider(
                                                thickness: 1,
                                              ),
                                              itemBuilder: (context, index) {
                                                if (index ==
                                                    renewalScholarship
                                                        .scholarshipReviews
                                                        .length) {
                                                  return const SizedBox(
                                                      height: 16);
                                                }
                                                final review =
                                                    reversedScholarshipReviews[
                                                        index];
                                                final dateTime = DateTime.parse(
                                                    review.dateTime);
                                                final day = dateTime.day
                                                    .toString()
                                                    .padLeft(2, '0');
                                                final month = dateTime.month
                                                    .toString()
                                                    .padLeft(2, '0');
                                                final year = dateTime.year
                                                    .toString()
                                                    .padLeft(2, '0');
                                                final hour = dateTime.hour
                                                    .toString()
                                                    .padLeft(2, '0');
                                                final minute = dateTime.minute
                                                    .toString()
                                                    .padLeft(2, '0');
                                                final second = dateTime.second
                                                    .toString()
                                                    .padLeft(2, '0');
                                                return Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 12,
                                                      left: 32,
                                                      bottom: 2),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text('#${index + 1}',
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          16)),
                                                          const SizedBox(
                                                              width: 5),
                                                          Text(
                                                              '$day/$month/$year - $hour:$minute:$second',
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 3),
                                                      Text(
                                                          'Revisado por: ${review.reviewType == ReviewType.attendant ? 'Atendente' : 'Assistente social'}'),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    processPeriod: chosenProcessRenewal,
                                  );

                                  return Column(
                                    children: [
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.03),
                                      Row(
                                        children: [
                                          const SizedBox(width: 22),
                                          Text(
                                            'Período do Processo',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const SizedBox(width: 22),
                                          Text(
                                            '${formatPeriodsDates(chosenProcessRenewal.registerStart)} - ${formatPeriodsDates(chosenProcessRenewal.registerEnd)}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                          ),
                                        ],
                                      ),
                                      child,
                                    ],
                                  );
                                },
                              ),
                            //Aba Novos
                            if (state.processesNew.isNotEmpty)
                              triple.ScopedBuilder<scholarship.Store, String,
                                  scholarship.StoreState>(
                                store: store.getScholarshipUsecaseStore,
                                onError: (context, error) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: Text(error.toString()),
                                  );
                                },
                                onLoading: (context) => const Center(
                                    child: CircularProgressIndicator()),
                                onState: (context, state) {
                                  final processNewScholarship =
                                      state.processNew;
                                  final chosenProcessNew =
                                      store.state.chosenProcessNew;
                                  final child = ProcessNewStepper(
                                    processNewScholarship:
                                        processNewScholarship,
                                    processNew: chosenProcessNew,
                                    onTapSendDocuments: () {
                                      store.setScholarshipIdForSelectGroupPage(
                                          processNewScholarship.id);
                                      Modular.to
                                          .pushNamed('select_group')
                                          .then((response) {
                                        if (response == true) {
                                          init();
                                        }
                                      });
                                    },
                                    onDateTimeError: () => store.setException(
                                        unavailableDocumentationUploadDeadline),
                                    onTapResendDocuments: () {
                                      onTapResendDocuments(
                                              processNewScholarship.id)
                                          .then((response) {
                                        if (response == true) {
                                          init();
                                        }
                                      });
                                    },
                                    processPeriod: chosenProcessNew,
                                  );
                                  return Column(
                                    children: [
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.03),
                                      Row(
                                        children: [
                                          const SizedBox(width: 22),
                                          Text(
                                            'Período do Processo',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const SizedBox(width: 22),
                                          Text(
                                            '${formatPeriodsDates(chosenProcessNew.registerStart)} - ${formatPeriodsDates(chosenProcessNew.registerEnd)}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                          ),
                                        ],
                                      ),
                                      child,
                                    ],
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void showLogoutDialog(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final primaryColor = Theme.of(context).colorScheme.primary;
    showCustomDialog(
      context: context,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: height * 0.025),
          Text(logoutDialogTitle,
              style: TextStyle(color: primaryColor, fontSize: 16)),
          OverflowBar(
            children: [
              AlternativeRoundedButton(
                label: logoutDialogOptionYes,
                onTap: () {
                  Modular.to.pop();
                  store.logout();
                },
              ),
              AlternativeRoundedButton(
                label: logoutDialogOptionNo,
                onTap: Modular.to.pop,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
