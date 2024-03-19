import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:provider/provider.dart' as provider;
import 'package:sigmahelpdesk/screens/products/CheckLocationPermission.dart';
import 'package:sigmahelpdesk/screens/products/MyTicketMainScreen.dart';
import '/screens/order_process/AddedToCartScreen.dart';
import '/screens/order_process/DeliveryAddressScreen.dart';
import '/screens/launch/HomeScreen.dart';
import '/screens/authentication/LoginScreen.dart';
import '/screens/order_process/MyCartScreen.dart';
import '/screens/products/AllCategoriesScreen.dart';
import '/screens/products/MyAttendanceScreen.dart';
import '/screens/products/MyTicketScreen.dart';
import '/screens/order_process/MyOrdersScreen.dart';
import '/screens/authentication/SignUpScreen.dart';
import '/screens/profile/UserProfileScreen.dart';
import 'colors/Colors.dart';
import 'notifier/dark_theme_provider.dart';
import 'screens/launch/SplashScreen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'globals.dart' as globals;

final storage = new FlutterSecureStorage();
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


  // Read value from secure storage
  String? username = await storage.read(key: 'username');
  String? password = await storage.read(key: 'password');

  print('Username: $username');
  print('Password: $password');

  String initialRoute = '/LoginScreen';

  if (username != null && password != null) {
    try {
      var client = OdooClient(URL);
      globalSession = await client.authenticate('sigmarectrix-11', username, password);
      globalUserId = globalSession.userId;  // Store the user ID
      globalClient = client;  // Update the global client

      print('Authentication successful');
      initialRoute = '/MyTicketMainScreen';

      // Send FCM token to Odoo server
      await globalClient.callKw({
        'model': 'fcm.token',  // Use the new model name
        'method': 'store_fcm_token',  // Use the new method name
        'args': [],
        'kwargs': {
          'user_id': globalUserId,
          'token': globals.fcmToken,
        },
      });
      print('FCM token sent to Odoo server for ${globalUserId}: ${globals.fcmToken}');
    } catch (e) {
      print('Failed to authenticate: $e');
    }
  }

  runApp(ProviderScope(child: MyApp(initialRoute: initialRoute)));
}

class MyApp extends StatefulWidget {
  final String initialRoute;

  const MyApp({Key? key, required this.initialRoute}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
    await themeChangeProvider.themePreferences.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    checkLocationPermission(context);
    return provider.ChangeNotifierProvider(
      create: (_) {
        return themeChangeProvider;
      },
      child: provider.Consumer<DarkThemeProvider>(
        builder: (BuildContext context, value, Widget? child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeData(themeChangeProvider.darkTheme, context),
            initialRoute: widget.initialRoute,
            routes: <String, WidgetBuilder>{
              '/': (context) => SplashScreen(),
              '/LoginScreen': (BuildContext context) => LoginScreen(),
              '/SignUpScreen': (BuildContext context) => SignUpScreen(),
              '/MyTicketMainScreen': (BuildContext context) => MyTicketMainScreen(),
              '/AddedToCartScreen': (BuildContext context) =>
                  AddedToCartScreen(),
              '/MyCartScreen': (BuildContext context) => MyCartScreen(),
              UserProfileScreen.routeName: (BuildContext context) =>
                  UserProfileScreen(),
              AllCategoriesScreen.routeName: (BuildContext context) =>
                  AllCategoriesScreen(),
              '/DeliveryAddressScreen': (BuildContext context) =>
                  DeliveryAddressScreen(
                    key: UniqueKey(), // replace with your key
                    shouldDisplayPaymentButton: true, // replace with your boolean value
                  ),
              '/MyOrdersScreen': (BuildContext context) => MyOrdersScreen(),
            },
          );
        },
      ),
    );
  }
}