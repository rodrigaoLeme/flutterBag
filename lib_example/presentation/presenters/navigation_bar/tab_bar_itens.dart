import '../../../ui/modules/maps/maps_view_model.dart';

enum TabBarItens {
  home(0),
  schedule(1),
  map(2),
  exhibitions(3),
  more(4);

  final int value;
  const TabBarItens(this.value);

  int getIndex(bool removeMap) {
    if (this == TabBarItens.home || this == TabBarItens.schedule) {
      return value;
    }

    if (removeMap && value >= TabBarItens.map.value) {
      return value - 1;
    }

    return value;
  }

  static TabBarItens fromIndex(int index, bool removeMap) {
    if (removeMap) {
      switch (index) {
        case 0:
          return TabBarItens.home;
        case 1:
          return TabBarItens.schedule;
        case 2:
          return TabBarItens.exhibitions;
        case 3:
          return TabBarItens.more;
        default:
          throw ArgumentError('Index inválido: $index');
      }
    } else {
      switch (index) {
        case 0:
          return TabBarItens.home;
        case 1:
          return TabBarItens.schedule;
        case 2:
          return TabBarItens.map;
        case 3:
          return TabBarItens.exhibitions;
        case 4:
          return TabBarItens.more;
        default:
          throw ArgumentError('Index inválido: $index');
      }
    }
  }
}

class ParamController {
  String? globalParam;
  MapsViewModel? mapViewModel;

  void setParam(String value) => globalParam = value;
  String getParam() => globalParam ?? '';

  void setViewModel(MapsViewModel value) => mapViewModel = value;
  MapsViewModel? getViewModel() => mapViewModel;
}
