import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:project_1/data/api/api_service.dart';
import 'package:project_1/data/db/database_helper.dart';

import 'package:project_1/data/model/restaurant_elemen.dart';
import 'package:project_1/provider/database_provider.dart';
import 'package:project_1/provider/list_restaurant/list_restaurant_bloc.dart';
import 'package:project_1/provider/list_restaurant_provider.dart';
import 'package:project_1/provider/restauran_detail_provider.dart';
import 'package:project_1/provider/scheduling_provider.dart';
import 'package:project_1/ui/detail_restaurant.dart';
import 'package:project_1/ui/list_restaurant.dart';
import 'package:project_1/tex_themde.dart';
import 'package:project_1/utils/background_service.dart';
import 'package:project_1/utils/notification_helper.dart';
import 'package:provider/provider.dart';

import 'common/navigation.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final NotificationHelper notificationHelper = NotificationHelper();
  final BackgroundService service = BackgroundService();
  service.initializeIsolate();
  await AndroidAlarmManager.initialize();
  await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(
        //   create: (context) => ListRestaurantProvider(
        //     apiService: ApiService(),
        //   ),
        // ),
        ChangeNotifierProvider(
          create: (context) => DatabaseProvider(
            databaseHelper: DatabaseHelper(),
          ),
        ),
        ChangeNotifierProvider<SchedulingProvider>(
          create: (_) => SchedulingProvider(),
        ),
        ChangeNotifierProvider<RestaurantDetailProvider>(
          create: (context) => RestaurantDetailProvider(
            apiService: ApiService(),
          ),
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => ListRestaurantBloc(apiService: ApiService(),
              ),
          )
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          title: 'Flutter Demo',
          theme: ThemeData(
              visualDensity: VisualDensity.adaptivePlatformDensity,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
              textTheme: myTextheme),
          initialRoute: ListRestaurant.routeName,
          routes: {
            ListRestaurant.routeName: (context) => const ListRestaurant(),
            RestaurantDetailPage.routeName: (context) => RestaurantDetailPage(
                restaurantElement: ModalRoute.of(context)?.settings.arguments
                    as RestaurantElement),
          },
        ),
      ),
    );
  }
}
