import 'package:dartchat/services/cloud_messaging_service/cloud_message_repository.dart';
import 'package:dartchat/utils/failure.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class CloudMessagingImpl implements CloudMessageRepository {
  final FirebaseMessaging fcm = FirebaseMessaging.instance;
  static bool isConfigured = false;
  static String previousMessageId = '';
  @override
  void configure({onAppMessage, onAppLaunch, onAppResume}) {
    if (!isConfigured) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification notification = message.notification;
        AndroidNotification android = message.notification?.android;
         if (onAppMessage != null ) {
            final String senderId = notification.body;
            print("============================= notification message body: $senderId");
            // onAppMessage(senderId);
          }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('A new onMessageOpenedApp event was published!');
        
      });
      // fcm.configure(
      //   onMessage: (message) async {
      //     if (onAppMessage != null ) {
      //       final String senderId = message['data']['senderId'];
      //       onAppMessage(senderId);
      //     }
      //   },
      //   onLaunch: (message) async {
      //     if (onAppLaunch != null && previousMessageId == message['data']['google.message_id']) {
      //       previousMessageId = message['data']['google.message_id'];
      //       final String senderId = message['data']['senderId'];
      //       print('firebase');
      //       onAppLaunch(senderId);
      //     }
      //   },
      //   onResume: (message) async {
      //     if (onAppResume != null) {
      //       final String senderId = message['data']['senderId'];
      //       onAppResume(senderId);
      //     }
      //   },
      // );
      // print('cloud_messaging_impl.dart error');
      isConfigured = true;
    }
  }

  @override
  Future<String> getToken() async {
    try {
      String token = await fcm.getToken();
      return token;
    } catch (e) {
      throw UnImplementedFailure();
    }
  }
}
