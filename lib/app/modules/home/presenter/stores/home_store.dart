// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_triple/flutter_triple.dart' as triple;

import '../../../../core/constants/process_type.dart';
import '../../../../core/stores/proxies/user/home_user_proxy_store.dart';
import '../../domain/usecases/get_process_periods/entity.dart';
import '../../domain/usecases/set_device_code/params.dart';
import '../device_info.dart';
import '../pages/scholarship_params.dart';
import 'home_store_states.dart';
import 'usecases/get_process_periods/store.dart' as get_processes_periods;
import 'usecases/get_processes_years/store.dart' as get_processes_years;
import 'usecases/get_scholarship_by_period/store.dart' as get_scholarship_by_period;
import 'usecases/set_device_code/store.dart' as set_device_code;

class HomeStore extends triple.StreamStore<String, HomeStoreState> {
  final HomeUserProxyStore _homeUserProxyStore;
  final get_processes_years.Store getYearsUsecaseStore;
  final get_processes_periods.Store getPeriodsUsecaseStore;
  final get_scholarship_by_period.Store getScholarshipUsecaseStore;
  final set_device_code.Store setDeviceCodeUsecaseStore;
  final ScholarshipParams params;

  HomeStore(
    this._homeUserProxyStore,
    this.getYearsUsecaseStore,
    this.getPeriodsUsecaseStore,
    this.getScholarshipUsecaseStore,
    this.params,
    this.setDeviceCodeUsecaseStore,
  ) : super(InitialState());

  Future<void> logout() async {
    setLoading(true, force: true);
    await _homeUserProxyStore.logout();
    await finishPushNotification();
    await const FlutterSecureStorage().deleteAll();
    Modular.to.pushNamedAndRemoveUntil('../auth/', (r) => false);
    setLoading(false, force: true);
  }

  Future<void> getAllProcessesYears() async {
    setLoading(true, force: true);
    await getYearsUsecaseStore();
    final yearsError = getYearsUsecaseStore.error;
    if (yearsError == null) {
      _setLatestYearByDefault();
    } else {
      setError(yearsError.toString());
    }
    setLoading(false, force: true);
  }

  void _setLatestYearByDefault() {
    final years = getYearsUsecaseStore.state.years;
    if (years.isNotEmpty) {
      final latestYear = _getLatestYear(years);
      update(SuccessState(latestYear, state.processesNew, state.processesRenewal, state.chosenProcessNew, state.chosenProcessRenewal),
          force: true);
    }
  }

  int _getLatestYear(List<int> years) {
    years.sort();
    return years.last;
  }

  void setProcessYear(int year) {
    update(SuccessState(year, state.processesNew, state.processesRenewal, state.chosenProcessNew, state.chosenProcessRenewal));
  }

  Future<void> getAllProcessPeriods(int year) async {
    setLoading(true, force: true);
    await getPeriodsUsecaseStore(get_processes_periods.Params(year: year));
    final periodsError = getPeriodsUsecaseStore.error;
    if (periodsError == null) {
      final processesList = getPeriodsUsecaseStore.state.processes;
      if (processesList.isEmpty) {
        setError('Nenhum processo foi encontrado', force: true);
      } else {
        final organizedProcessesList = _organizeProcesses(processesList);
        final latestProcess = organizedProcessesList.latestProcess;
        final processesRenewal = organizedProcessesList.processesRenewal;
        final processesNew = organizedProcessesList.processesNew;
        final chosenProcessNew = _setChosenProcessNew(processesNew: processesNew, latestProcess: latestProcess);
        final chosenProcessRenewal = _setChosenProcessRenewal(processesRenewal: processesRenewal, latestProcess: latestProcess);
        update(SuccessState(state.year, processesNew, processesRenewal, chosenProcessNew, chosenProcessRenewal), force: true);
      }
    } else {
      setError(periodsError.toString(), force: true);
    }
    setLoading(false, force: true);
  }

  _OrganizedProcessesList _organizeProcesses(List<Process> processes) {
    final dateTimeNow = DateTime.now();
    try {
      final listOfDurationsFromDateTimeNow = <DifferenceFromNowProcess>[];
      final processesNew = <Process>[];
      final processesRenewal = <Process>[];
      for (final process in processes) {
        final registerStart = process.registerStart;
        final registerStartDateTime = DateTime.tryParse(registerStart);
        if (registerStartDateTime == null) {
          throw (Exception('Não foi possível converter a data do processo com id ${process.id}'));
        }
        process.processType == ProcessType.fresh ? processesNew.add(process) : processesRenewal.add(process);
        final differenceFromNow = dateTimeNow.difference(registerStartDateTime);
        listOfDurationsFromDateTimeNow.add(DifferenceFromNowProcess(differenceFromNow, process.id));
      }
      listOfDurationsFromDateTimeNow.sort(((a, b) => a.duration.compareTo(b.duration)));
      final closerDifference = listOfDurationsFromDateTimeNow.first;
      final latestProcess = processes.firstWhere((element) => element.id == closerDifference.id);
      return _OrganizedProcessesList(processesNew: processesNew, processesRenewal: processesRenewal, latestProcess: latestProcess);
    } catch (e) {
      setError(e.toString());
      return _OrganizedProcessesList.empty();
    }
  }

  Process _setChosenProcessNew({required List<Process> processesNew, required Process latestProcess}) {
    Process chosenProcess;
    if (latestProcess.processType == ProcessType.fresh) {
      chosenProcess = latestProcess;
    } else if (processesNew.isEmpty) {
      chosenProcess = Process.empty();
    } else {
      chosenProcess = processesNew.length > 1 ? Process.empty() : processesNew.first;
    }
    return chosenProcess;
  }

  Process _setChosenProcessRenewal({required List<Process> processesRenewal, required Process latestProcess}) {
    Process chosenProcess;
    if (latestProcess.processType == ProcessType.renewal) {
      chosenProcess = latestProcess;
    } else if (processesRenewal.isEmpty) {
      chosenProcess = Process.empty();
    } else {
      chosenProcess = processesRenewal.length > 1 ? Process.empty() : processesRenewal.first;
    }
    return chosenProcess;
  }

  Future<void> getScholarshipByPeriod(String periodId, ProcessType processType) async {
    setLoading(true, force: true);
    await getScholarshipUsecaseStore(get_scholarship_by_period.Params(periodId: periodId), processType);
    final scholarshipError = getScholarshipUsecaseStore.error;
    if (scholarshipError == null) {
      update(state, force: true);
    } else {
      setError(scholarshipError.toString());
    }
    setLoading(false, force: true);
  }

  void setScholarshipIdForSelectGroupPage(String id) {
    params.id = id;
  }

  void setException(String message) {
    setError(message);
  }

  String get username => _homeUserProxyStore.currentUser.name;
  String get nameIdentifier => _homeUserProxyStore.currentUser.nameIdentifier;
  String get emailAddres => _homeUserProxyStore.currentUser.emailAddress;

  void goToSettings() {
    update(SettingsState(state.year, state.processesNew, state.processesRenewal, state.chosenProcessNew, state.chosenProcessRenewal));
  }

  void backToHome() {
    update(SuccessState(state.year, state.processesNew, state.processesRenewal, state.chosenProcessNew, state.chosenProcessRenewal));
  }

  Future<Params> checkDeviceWithEmail(String nameIdentifier, String emailAddres) async {
    const storage = FlutterSecureStorage();
    String? localDeviceCode = "";
    String? localEmailAddres = "";
    //String deviceCode = DeviceInfo.shared.deviceCode;
    String deviceCode = await FirebaseMessaging.instance.getToken() ?? "";

    localDeviceCode = await storage.read(key: "EBOLSA-DEVICE-CODE");
    localEmailAddres = await storage.read(key: "EBOLSA-EMAILADDRES");

    if ((localDeviceCode != deviceCode) || (localEmailAddres != emailAddres)) {
      debugPrint('Setando device e email no storage');
      await DeviceInfo.shared.setNewData(deviceCode, emailAddres);
      localDeviceCode = await storage.read(key: "EBOLSA-DEVICE-CODE");
      localEmailAddres = await storage.read(key: "EBOLSA-EMAILADDRES");
    } else {
      debugPrint("storage ok");
    }

    debugPrint("LocalDeviceCode: $localDeviceCode - DeviceCode: $deviceCode");
    debugPrint("NameIdentifier $nameIdentifier");
    debugPrint("Localemail: $localEmailAddres - email: $emailAddres");
    return Params(deviceCode: deviceCode, nameidentifier: nameIdentifier, operation: SetDeviceCodeOperation.start);
  }

  Future<void> initPushNotification() async {
    final setDeviceCodeParams = await checkDeviceWithEmail(nameIdentifier, emailAddres);
    await setDeviceCodeUsecaseStore(setDeviceCodeParams);
  }

  Future<void> finishPushNotification() => setDeviceCodeUsecaseStore(Params.finish());
}

class DifferenceFromNowProcess {
  final Duration duration;
  final String id;

  DifferenceFromNowProcess(this.duration, this.id);
}

class _OrganizedProcessesList {
  final List<Process> processesNew;
  final List<Process> processesRenewal;
  final Process latestProcess;

  factory _OrganizedProcessesList.empty() =>
      _OrganizedProcessesList(processesNew: [], processesRenewal: [], latestProcess: Process.empty());

  const _OrganizedProcessesList({
    required this.processesNew,
    required this.processesRenewal,
    required this.latestProcess,
  });
}
