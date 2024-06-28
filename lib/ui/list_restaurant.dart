import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_1/data/api/api_service.dart';
import 'package:project_1/provider/list_restaurant/list_restaurant_bloc.dart';
import 'package:project_1/provider/restaurant_search_provider.dart';
import 'package:project_1/ui/search_page.dart';
import 'package:project_1/ui/settings_page.dart';
import 'package:provider/provider.dart';

import '../common/result_state.dart';
import '../utils/notification_helper.dart';
import '../widget/card_list_restaurant.dart';
import 'detail_restaurant.dart';
import 'favorite_restaurant.dart';

class ListRestaurant extends StatefulWidget {
  static const routeName = '/list_restaurant';

  const ListRestaurant({super.key});

  @override
  State<ListRestaurant> createState() => _ListRestaurantState();
}

class _ListRestaurantState extends State<ListRestaurant> {
  final NotificationHelper _notificationHelper = NotificationHelper();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ListRestaurantBloc>(context).add(FetchListRestaurant());
    _notificationHelper.configureSelectNotificationSubject(
        context, RestaurantDetailPage.routeName);
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const SettingsPage();
                }),
              );
            },
            icon: const Icon(Icons.settings),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const FavoriteRestaurantPage();
                }),
              );
            },
            icon: const Icon(Icons.bookmark),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return ChangeNotifierProvider(
                    create: (contex) => RestaurantSearchProvider(
                      apiService: ApiService(),
                    ),
                    child: const SearchPage(),
                  );
                }),
              );
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(
                height: 5,
              ),
              Text(
                "Restaurant",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                "Recommendation restauran for you!",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              BlocBuilder<ListRestaurantBloc, RestaurantState>(
                builder: (context, state) {
                  if (state.state == ResultState.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.state == ResultState.hasData) {
                    final restaurantData = state.listRestaurant!;

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: restaurantData.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: CardListRestaurant(
                            restaurantData: restaurantData[index],
                          ),
                        );
                      },
                    );
                  } else if (state.state == ResultState.noData) {
                    return Center(
                      child: Material(
                        child: Text(state.message!),
                      ),
                    );
                  } else if (state.state == ResultState.error) {
                    return Center(
                      child: Material(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 4),
                          child: Text(state.message!),
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              )
            ]),
          ),
        ),
      ),
    );
  }
}
