import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


class NotificationService {


  static final NotificationService _notificationService = NotificationService._internal();


  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  FlutterLocalNotificationsPlugin notificationPlugin = FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project

  Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

    final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: null,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: null);

    await notificationPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  static Future selectNotification(String payload) async {
    //Handle notification tapped logic here
  }
  Future<void> displayNotification() async {
    var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('foodExpiring', 'channel for food expiring',
            'your channel description',
            importance: Importance.max,
            channelShowBadge: false,
            priority: Priority.high,
            showWhen: true,
            fullScreenIntent: true,
            ticker: '');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        'Some of your food is about to go bad!',
        "How about using it or letting someone else have it?",
        platformChannelSpecifics,
        );

  }

  
  /// Schedules a notification that specifies a different icon, sound and vibration pattern
}
void scheduleNotifications() async{


    var _auth = FirebaseAuth.instance;
    tz.initializeTimeZones();
    List<PendingNotificationRequest> pending = await getPending();
    //get query values
    QuerySnapshot userItems = await FirebaseFirestore.instance.collection("items")
        .where("ownerid", isEqualTo: (_auth.currentUser == null) ? "" : _auth.currentUser.uid)
        .get();
      
    for (var item in userItems.docs) {
      
      
      DateTime current = tz.TZDateTime.now(tz.local);
      DateTime expiry = item["expiryDate"].toDate();
      int difference = expiry.difference(current).inDays;
      int dayBefore = difference -1;
      int fourDaysBefore = difference -4;
      
      int notificationId = item.id.substring.hashCode;
      int secondNotificationId = notificationId-4;
      
      if (pending.isEmpty){
        scheduleNotification(item["name"], notificationId, dayBefore, 1);
        scheduleNotification(item["name"], secondNotificationId, fourDaysBefore,4);
      } else{
      for (var n in pending){
        //alreayd scheduled
        if (n.id == notificationId || n.id == secondNotificationId){
          break;  
        }
        scheduleNotification(item["name"], notificationId, dayBefore, 1);
        scheduleNotification(item["name"], secondNotificationId, fourDaysBefore,4);

      }
      }
    }    
    printNotifications();
  }
bool scheduleNotification(String itemName, int notificationId, int inDays, int left){
  NotificationService().notificationPlugin.zonedSchedule(
        notificationId,
        "$itemName is going to expire in $left days!",
        "How about using it or letting someone else have it?",
        tz.TZDateTime.now(tz.local).add(Duration(days: inDays)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
              "0", 
              "Expiry",
              "Notify of food expiring")),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
        return true;
}



Future<List<PendingNotificationRequest>> getPending()async{
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  List<PendingNotificationRequest> pendingNotificationRequests =await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  return pendingNotificationRequests;
}

void deleteNotifications() async{
  await NotificationService().notificationPlugin.cancelAll();
}
Future<void> printNotifications() async {
  List<PendingNotificationRequest> m = await getPending();
  for (var p in m){
    print(p.title);

  }
}