// lib/services/notification_router.dart
import 'package:birrawrapped/models/group_detail_args.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationRouter {
  /// Retorna la ruta i els arguments a navegar, o null si no s'ha de fer res
  static ({String route, Object? arguments})? resolve(RemoteMessage message) {
    final type = message.data['type'];

    switch (type) {
      case 'meetup':
        final groupId = message.data['groupId'];
        return (
          route: '/groupDetail',
          arguments: GroupDetailArgs(groupId: groupId, initialTab: 1)
        );

      case 'group_chat':
        final groupId = message.data['groupId'];
        return (
          route: '/groupDetail',
          arguments: GroupDetailArgs(groupId: groupId, initialTab: 0)
        );

      case 'newMember':
        final groupId = message.data['groupId'];
        return (route: '/groupDetail', arguments: groupId);

      case 'reminder':
        return (route: '/chooseDrink', arguments: null);

      // Afegeix aquí nous casos en el futur, sense tocar res més
      default:
        return null;
    }
  }
}
