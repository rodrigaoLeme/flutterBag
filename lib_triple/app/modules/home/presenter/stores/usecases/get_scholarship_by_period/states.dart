part of 'store.dart';

abstract class StoreState {
  final Entity processNew;
  final Entity processRenewal;

  const StoreState({required this.processNew, required this.processRenewal});
}

class Initial extends StoreState {
  Initial() : super(processNew: Entity.empty(), processRenewal: Entity.empty());
}

class Set extends StoreState {
  Set({required super.processNew, required super.processRenewal});
}

// class ProcessRenewalSet extends Set {
//   ProcessRenewalSet({required super.processRenewal}) : super(processNew: Entity.empty());
// }

// class ProcessNewSet extends Set {
//   ProcessNewSet({required super.processNew}) : super(processRenewal: Entity.empty());
// }

// class BothProcessesSet extends Set {
//   BothProcessesSet({required super.processNew, required super.processRenewal});
// }
