import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:project_1/data/api/api_service.dart';

import '../data/model/restaurant_element.dart';

import '../ui/detail_restaurant.dart';

class CardListRestaurant extends StatelessWidget {
  const CardListRestaurant({super.key, required this.restaurantData});

  final RestaurantElement restaurantData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 6,
      child: GestureDetector(
        onTap: () async {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return RestaurantDetailPage(
                restaurantElement: restaurantData,
              );
            },
          ));
        },
        child: Card(
          color: Colors.white,
          child: Row(
            children: [
              Hero(
                tag: restaurantData.name,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    "${ApiService.imageSmall}${restaurantData.pictureId}",
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return Image.asset(
                        "assets/placeholder-480.png",
                        height: MediaQuery.of(context).size.height / 6,
                        width: MediaQuery.of(context).size.width / 3,
                        fit: BoxFit.cover,
                      );
                    },
                    height: MediaQuery.of(context).size.height / 6,
                    width: MediaQuery.of(context).size.width / 3,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurantData.name,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      RatingBar.builder(
                          itemCount: 5,
                          initialRating: restaurantData.rating,
                          itemSize: 18,
                          itemBuilder: (context, index) {
                            return const Icon(
                              Icons.star,
                              color: Colors.yellow,
                            );
                          },
                          onRatingUpdate: (rating) {}),
                      const SizedBox(
                        height: 5,
                      ),
                      Expanded(
                        child: Text(
                          restaurantData.city,
                          style: Theme.of(context).textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
