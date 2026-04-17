import 'main.dart' as runner;
import 'main/flavors.dart';

Future<void> main() async {
  Flavor.flavorType = FlavorType.prod;
  runner.mainCommon();
}
