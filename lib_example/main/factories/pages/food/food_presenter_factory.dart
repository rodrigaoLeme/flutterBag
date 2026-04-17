import 'package:flutter_modular/flutter_modular.dart';

import '../../../../presentation/presenters/food/stream_food_presenter.dart';
import '../../../../ui/modules/dashboard/section_view_model.dart';
import '../../../../ui/modules/food/food_presenter.dart';
import '../../usecases/event/load_current_event_factory.dart';
import '../../usecases/food/load_current_external_food_factory.dart';
import '../../usecases/food/load_external_food_factory.dart';
import '../../usecases/food/load_internal_food_factory.dart';
import '../../usecases/food/save_current_external_food_factory.dart';

FoodPresenter makeFoodPresenter() {
  final typeByRoute = Modular.args.data as SectionType;

  return StreamFoodPresenter(
    loadExternalFood: makeRemoteLoadExternalFood(),
    loadInternalFood: makeRemoteLoadFoodInternal(),
    loadCurrentEvent: makeLocalLoadCurrentEvent(),
    loadCurrentExternalFood: makeLoadCurrentExternalFood(),
    localSaveCurrentFood: makeSaveCurrentExternalFood(),
    sectionType: typeByRoute,
  );
}
