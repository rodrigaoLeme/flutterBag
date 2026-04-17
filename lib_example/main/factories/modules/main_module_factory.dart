import 'package:flutter_modular/flutter_modular.dart';

import '../../routes/core_module.dart';
import '../../routes/routes_app.dart';
import '../pages/accessibility/accessibility_page_factory.dart';
import '../pages/broadcast/broadcast_page_factory.dart';
import '../pages/brochures/brochures_page_factory.dart';
import '../pages/business/business_page_factory.dart';
import '../pages/chat_support/chat_support_page_factory.dart';
import '../pages/devotional/devotional_page_factory.dart';
import '../pages/documents/documents_page_factory.dart';
import '../pages/emergency/emergency_page_factory.dart';
import '../pages/exhibition/exhibition_page_factory.dart';
import '../pages/map/map_page_factory.dart';
import '../pages/music/music_page_factory.dart';
import '../pages/music_details/music_details_page_factory.dart';
import '../pages/notification/notification_page_factory.dart';
import '../pages/pages.dart';
import '../pages/prayer_room/prayer_room_page_factory.dart';
import '../pages/profile/profile_page_factory.dart';
import '../pages/social_media/social_media_page_factory.dart';
import '../pages/spiritual/spiritual_page_factory.dart';
import '../pages/st_louis/st_louis_page_factory.dart';
import '../pages/translation/translation_page_factory.dart';
import '../pages/translation_channel/translation_channel_page_factory.dart';
import '../pages/transport/transport_page_factory.dart';

class MainModule extends Module {
  @override
  List<Module> get imports => [
        CoreModule(),
      ];

  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child(
      Routes.getInLine,
      child: (_) => makeGetInLinePage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      Routes.stLouis,
      child: (_) => makeStLouisPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      Routes.exhibition,
      child: (_) => makeExhibitionPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      Routes.support,
      child: (_) => makeSupportPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      Routes.chatSupport,
      child: (_) => makeChatSupportPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      Routes.userId,
      child: (_) => makeChatSupportPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      Routes.profile,
      child: (_) => makeProfilePage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      Routes.editProfile,
      child: (_) => makeEditProfilePage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      Routes.food,
      child: (_) => makeFoodPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      Routes.voting,
      child: (_) => makeVotingPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      Routes.map,
      child: (_) => makeMapPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      Routes.notification,
      child: (_) => makeNotificationPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      Routes.emergency,
      child: (_) => makeEmergencyPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      Routes.spiritual,
      child: (_) => makeSpiritualPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      Routes.translation,
      child: (_) => makeTranslationPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      Routes.business,
      child: (_) => makeBusinessPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      Routes.brochures,
      child: (_) => makeBrochuresPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      Routes.broadcast,
      child: (_) => makeBroadcastPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      Routes.documents,
      child: (_) => makeDocumentsPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      Routes.prayerRoom,
      child: (_) => makePrayerRoomPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      Routes.music,
      child: (_) => makeMusicPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      Routes.musicDetails,
      child: (_) => makeMusicDetailsPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      Routes.devotional,
      child: (_) => makeDevotionalPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      Routes.translationChannel,
      child: (_) => makeTranslationChannelPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      Routes.transport,
      child: (_) => makeTransportPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      Routes.accessibility,
      child: (_) => makeAccessibilityPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      Routes.socialMedia,
      child: (_) => makeSocialMediaPage(),
      transition: TransitionType.fadeIn,
    );
  }
}
