  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:project_1/common/ui_state.dart';
  import 'package:project_1/data/api/api_service.dart';
  import 'package:project_1/data/model/restaurant_detail.dart';
  import 'package:project_1/provider/add_review_provider.dart';
  import 'package:project_1/provider/database_provider.dart';
  import 'package:project_1/provider/restaurant_detail/restaurant_detail_bloc.dart';
  import 'package:project_1/ui/add_review_page.dart';
  import 'package:project_1/widget/submit_button.dart';
  import 'package:provider/provider.dart';

  import '../data/model/restaurant_element.dart';
  import '../widget/box_list.dart';
  import '../widget/review_item.dart';
  import 'detail_review.dart';

  class RestaurantDetailPage extends StatefulWidget {
    static const routeName = '/restaurant_detail';

    final RestaurantElement restaurantElement;

    const RestaurantDetailPage({Key? key, required this.restaurantElement})
        : super(key: key);

    @override
    State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
  }

  class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
    @override
    void initState() {
      super.initState();
      Future.microtask(() {
        BlocProvider.of<RestaurantDetailBloc>(context)
            .add(FetchDetailRestaurant(id: widget.restaurantElement.id));
      });
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.restaurantElement.name),
        ),
        body: SingleChildScrollView(
          child: BlocBuilder<RestaurantDetailBloc, UiState>(
              builder: (context, state) {
                debugPrint("apiNilai: $state");
            if (state is Loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is Success<RestaurantDetail>) {
              return detailContent(state, context);
            } else if (state is Error) {
              return Center(
                child: Material(
                  child: Text(state.errorMessage),
                ),
              );
            } else {
              return const SizedBox();
            }
          }),
        ),
      );
    }

    Widget detailContent(Success<RestaurantDetail> state, BuildContext context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Hero(
                tag: widget.restaurantElement.name,
                child: Image.network(
                  "${ApiService.imageLarge}${state.data.pictureId}",
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: -25,
                right: MediaQuery.of(context).size.width / 10,
                child: Consumer<DatabaseProvider>(builder: (context, state, _) {
                  return FutureBuilder<bool>(
                      future: state.isBookmarked(widget.restaurantElement.id),
                      builder: (context, snapshot) {
                        var isBookmarked = snapshot.data ?? false;
                        return InkWell(
                          borderRadius: BorderRadius.circular(25),
                          onTap: () {
                            if (isBookmarked) {
                              Provider.of<DatabaseProvider>(context,
                                      listen: false)
                                  .removeBookmark(widget.restaurantElement.id);
                            } else {
                              Provider.of<DatabaseProvider>(context,
                                      listen: false)
                                  .addBookmark(widget.restaurantElement);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(0),
                            width: 50,
                            height: 50,
                            decoration:
                                const BoxDecoration(shape: BoxShape.circle),
                            child: Card(
                              elevation: 4,
                              shape: const CircleBorder(),
                              child: (isBookmarked)
                                  ? Icon(
                                      Icons.favorite,
                                      size: 25,
                                      color: Colors.red[400],
                                    )
                                  : Icon(Icons.favorite_border,
                                      color: Colors.red[400], size: 25),
                            ),
                          ),
                        );
                      });
                }),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.data.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const Icon(Icons.location_on_outlined),
                    Text("${state.data.city}, ${state.data.address}")
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const Icon(Icons.star_border_outlined),
                    Text(state.data.rating.toString())
                  ],
                ),
                const Divider(color: Colors.grey),
                Container(
                    padding: const EdgeInsets.only(top: 10, bottom: 5),
                    child: Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleMedium,
                    )),
                Text(
                  state.data.description,
                  maxLines: 8,
                  overflow: TextOverflow.ellipsis,
                ),
                const Divider(color: Colors.grey),
                Container(
                    padding: const EdgeInsets.only(top: 10, bottom: 5),
                    child: Text(
                      'Menus',
                      style: Theme.of(context).textTheme.titleMedium,
                    )),
                const Text('Foods: '),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: state.data.menus.foods.length,
                    itemBuilder: (context, index) {
                      return BoxList(
                        title: state.data.menus.foods[index].name,
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('drinks : '),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: state.data.menus.drinks.length,
                    itemBuilder: (context, index) {
                      return BoxList(
                        title: state.data.menus.drinks[index].name,
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(color: Colors.grey),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Ulasan",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext ctx) {
                              return DetailReview(
                                restaurantDetail: state.data,
                              );
                            });
                      },
                      child: Text("Lihat Semua",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: Colors.deepPurple)),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                ReviewItem(
                  date: state.data.customerReviews[0].date,
                  review: state.data.customerReviews[0].review,
                  userName: state.data.customerReviews[0].name,
                ),
                const Divider(color: Colors.grey),
                const SizedBox(
                  height: 10,
                ),
                SubmitButton(
                    text: "Add Review",
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (_) {
                          return ChangeNotifierProvider(
                            create: (_) =>
                                AddReviewProvider(ApiService(), state.data.id),
                            child: AddReviewPage(
                                pictureId: state.data.pictureId,
                                name: state.data.name),
                          );
                        },
                      ));
                    })
              ],
            ),
          ),
        ],
      );
    }
  }
