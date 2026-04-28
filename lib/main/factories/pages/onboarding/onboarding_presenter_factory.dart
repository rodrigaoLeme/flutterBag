import '../../../../presentation/presenters/onboarding/stream_onboarding_presenter.dart';
import '../../../../ui/modules/onboarding/onboarding_presenter.dart';
import '../../http/http_factories.dart';

OnboardingPresenter makeOnboardingPresenter() =>
    StreamOnboardingPresenter(secureStorage: makeSecureStorage());
