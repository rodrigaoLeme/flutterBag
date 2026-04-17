import 'package:flutter/material.dart';

import '../../../../ui/modules/food/food_page.dart';
import 'food_presenter_factory.dart';

Widget makeFoodPage() => FoodPage(
      presenter: makeFoodPresenter(),
    );
