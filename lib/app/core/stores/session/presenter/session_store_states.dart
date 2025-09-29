import '../../../entities/logged_user_v2.dart';

abstract class SessionStoreStates {
  final LoggedUser entity;

  const SessionStoreStates(this.entity);
}

class SessionStoreInitialState extends SessionStoreStates {
  SessionStoreInitialState() : super(LoggedUser.empty());
}

class SessionStoreUpdatedState extends SessionStoreStates {
  SessionStoreUpdatedState(super.entity) : super();
}
