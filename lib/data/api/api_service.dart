import 'dart:convert';

import 'package:project_1/data/model/restaurant_detail.dart';
import 'package:project_1/data/model/restaurant_element.dart';
import 'package:http/http.dart' as http;

import '../model/cutomer_review.dart';
import '../model/result_list_restaurant.dart';

class ApiService {
  static const _baseUrl = "https://restaurant-api.dicoding.dev";
  static const _listRestaurant = "/list";
  static const _detailRestaurant = "/detail/";
  static const _searchRestaurant = "/search?q=";
  static const _addReview = "/review";
  static const imageSmall = "https://restaurant-api.dicoding.dev/images/small/";
  static const imageLarge = "https://restaurant-api.dicoding.dev/images/large/";

  Future<ResultListRestauran> resultListRestaurant(http.Client client) async {
    final response = await client.get(Uri.parse("$_baseUrl$_listRestaurant"));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      if (json["message"] == "success") {
        ResultListRestauran restaurant =
            ResultListRestauran.fromRawJson(response.body);

        return restaurant;
      } else {
        throw Exception("List Restaurant not succes");
      }
    } else {
      throw Exception("Failed to load List Restaurant");
    }
  }

  Future<List<RestaurantElement>> listRestaurant() async {
    final response = await http.get(Uri.parse("$_baseUrl$_listRestaurant"));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      if (json["message"] == "success") {
        List<dynamic> jsonDynamic = json["restaurants"];

        List<RestaurantElement> restaurant =
            jsonDynamic.map((e) => RestaurantElement.fromJson(e)).toList();

        return restaurant;
      } else {
        throw Exception("List Restaurant not succes");
      }
    } else {
      throw Exception("Failed to load List Restaurant");
    }
  }

  Future<RestaurantDetail> detailRestaurant(String id) async {
    final response =
        await http.get(Uri.parse("$_baseUrl$_detailRestaurant$id"));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      if (json["message"] == "success") {
        final jsonDynamic = json["restaurant"];

        RestaurantDetail restaurant = RestaurantDetail.fromJson(jsonDynamic);

        return restaurant;
      } else {
        throw Exception("List Restaurant not succes");
      }
    } else {
      throw Exception("Failed to load List Restaurant");
    }
  }

  Future<List<RestaurantElement>> searchRestaurant(String query) async {
    final response =
        await http.get(Uri.parse("$_baseUrl$_searchRestaurant$query"));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      if (json["error"] == false) {
        List<dynamic> jsonDynamic = json["restaurants"];

        List<RestaurantElement> restaurant =
            jsonDynamic.map((e) => RestaurantElement.fromJson(e)).toList();

        return restaurant;
      } else {
        throw Exception("List Restaurant not found");
      }
    } else {
      throw Exception("Failed to load List Restaurant");
    }
  }

  Future<List<CustomerReview>> addCustomerReview(
      String id, String name, String review) async {
    final response = await http.post(
      Uri.parse("$_baseUrl$_addReview"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id": id, "name": name, "review": review}),
    );

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body);

      if (json["error"] == false) {
        List<dynamic> jsonDynamic = json["customerReviews"];

        List<CustomerReview> custumerReview =
            jsonDynamic.map((e) => CustomerReview.fromJson(e)).toList();
        return custumerReview;
      } else {
        throw Exception("List review not found");
      }
    } else {
      throw Exception("Failed to load List Review");
    }
  }
}
