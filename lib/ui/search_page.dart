import 'package:flutter/material.dart';
import 'package:project_1/provider/restaurant_search_provider.dart';
import 'package:project_1/widget/search_bar.dart';
import 'package:provider/provider.dart';

import '../common/result_state.dart';
import '../data/model/restaurant_element.dart';

import '../widget/card_list_restaurant.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            height: 5,
          ),
          Text(
            "Search",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text(
            "Search Restaurant you want!",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(
            height: 10,
          ),
          const SearchButton(),
          Consumer<RestaurantSearchProvider>(
            builder: (context, state, _) {
              if (state.state == ResultState.loading) {
                return const Expanded(
                    child: Center(child: CircularProgressIndicator()));
              } else if (state.state == ResultState.hasData) {
                final List<RestaurantElement> restaurantData = state.result;

                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: restaurantData.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: CardListRestaurant(
                          restaurantData: restaurantData[index],
                        ),
                      );
                    },
                  ),
                );
              } else if (state.state == ResultState.noData) {
                return Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off,
                          size: 70,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(state.message)
                      ],
                    ),
                  ),
                );
              } else if (state.state == ResultState.error) {
                return Center(
                  child: Material(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 4),
                      child: Text(state.message),
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: Material(
                    child: Text(""),
                  ),
                );
              }
            },
          )
        ]),
      ),
    );
  }
}
