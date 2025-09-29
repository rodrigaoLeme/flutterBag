// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../../../../../core/constants/process_type.dart';

class Entity {
  final List<Process> processes;
  const Entity({
    required this.processes,
  });
  factory Entity.empty() => const Entity(processes: []);
}

class Process {
  final String id;
  final ProcessType processType;
  final String? documentationUploadDeadline;
  final String? documentationReturnUploadDeadLine;
  final String registerStart;
  final String registerEnd;
  final String resultRelease;

  const Process({
    required this.id,
    required this.processType,
    this.documentationUploadDeadline,
    this.documentationReturnUploadDeadLine,
    required this.registerStart,
    required this.registerEnd,
    required this.resultRelease,
  });

  factory Process.empty() => const Process(
        processType: ProcessType.fresh,
        id: '',
        documentationUploadDeadline: '',
        documentationReturnUploadDeadLine: '',
        registerStart: '',
        registerEnd: '',
        resultRelease: '',
      );
}
