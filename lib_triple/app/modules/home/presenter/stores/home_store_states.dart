import '../../domain/usecases/get_process_periods/entity.dart';

abstract class HomeStoreState {
  final int year;
  final List<Process> processesNew;
  final List<Process> processesRenewal;
  final Process chosenProcessNew;
  final Process chosenProcessRenewal;

  const HomeStoreState(this.year, this.processesNew, this.processesRenewal, this.chosenProcessNew, this.chosenProcessRenewal);

  HomeStoreState copyWith({int? year, List<Process>? processesNew, List<Process>? processesRenewal, Process? chosenProcessNew, Process? chosenProcessRenewal});
}

class InitialState extends HomeStoreState {
  InitialState() : super(-1, [], [], Process.empty(), Process.empty());

  @override
  InitialState copyWith({int? year, List<Process>? processesNew, List<Process>? processesRenewal, Process? chosenProcessNew, Process? chosenProcessRenewal}) => InitialState();
}

class SuccessState extends HomeStoreState {
  const SuccessState(super.year, super.processNew, super.processRenewal, super.chosenProcessNew, super.chosenProcessRenewal);

  @override
  SuccessState copyWith({int? year, List<Process>? processesNew, List<Process>? processesRenewal, Process? chosenProcessNew, Process? chosenProcessRenewal}) {
    return SuccessState(year ?? this.year, processesNew ?? this.processesNew, processesRenewal ?? this.processesRenewal, chosenProcessNew ?? this.chosenProcessNew, chosenProcessRenewal ?? this.chosenProcessRenewal);
  }
}

class SettingsState extends HomeStoreState {
  const SettingsState(super.year, super.processNew, super.processRenewal, super.chosenProcessNew, super.chosenProcessRenewal);

  @override
  SettingsState copyWith({int? year, List<Process>? processesNew, List<Process>? processesRenewal, Process? chosenProcessNew, Process? chosenProcessRenewal}) {
    return SettingsState(year ?? this.year, processesNew ?? this.processesNew, processesRenewal ?? this.processesRenewal, chosenProcessNew ?? this.chosenProcessNew, chosenProcessRenewal ?? this.chosenProcessRenewal);
  }
}
