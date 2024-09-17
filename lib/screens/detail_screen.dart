
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movietime/extensions/extension_util/context_extensions.dart';
import 'package:movietime/extensions/extension_util/int_extensions.dart';
import 'package:movietime/extensions/extension_util/widget_extensions.dart';
import 'package:movietime/extensions/text_styles.dart';
import 'package:movietime/utils/app_common.dart';

import '../extensions/widgets.dart';
import '../models/detail_movie_response.dart';
import '../network/rest_api.dart';
import '../utils/app_config.dart';

class DetailScreen extends StatefulWidget {
  final int movieId;

  const DetailScreen({super.key, required this.movieId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  DetailResponse? movieDetails;
  bool isLoading = true;
  bool hasError = false;
  double _userRating = 0.0;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    print("ID ==>" + widget.movieId.toString());
    getDetails();
    setState(() {});
  }

  Future<void> getDetails() async {
    await getMovieDetailsApi(widget.movieId).then((value) {
      print(value.toJson());
      movieDetails = value;

      isLoading = false;
      _userRating = double.parse(movieDetails!.voteAverage.toString());
      setState(() {});
    }).catchError((e) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('',

          context: context,
          titleSpacing: 0),
      body: SingleChildScrollView(
        child: isLoading
            ? Center(child: Center(child: CircularProgressIndicator()))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movieDetails!.originalTitle.toString(),
                    style: boldTextStyle(size: 26),
                  ).paddingLeft(6),
                  10.height,

                  cachedImage(
                      '${mImageUrl}' + movieDetails!.posterPath.toString(),
                      height: 250,
                      fit: BoxFit.cover,
                      width: context.width()),

                  // RichText(
                  //   textAlign: TextAlign.center,
                  //   text: TextSpan(
                  //     children: [
                  //       TextSpan(text: movieDetails!.genres!.last.name.toString(),
                  //       )
                  //       TextSpan(text: movieDetails!.genres!.last.name.toString(),
                  //       )
                  //     ],
                  //   ),
                  // ),

                  Column(children: [
                    Row(
                      children: [
                        Text(
                          movieDetails!.genres!.last.name.toString(),
                        ),
                        6.width,
                        Text(
                          movieDetails!.releaseDate.toString().substring(0, 4),
                        ),
                      ],
                    ),
                    10.height,
                    Text(movieDetails!.overview.toString()),
                    10.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        RatingBar.builder(
                          itemSize: 20,
                          initialRating:
                          double.parse(movieDetails!.voteAverage.toString()),
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 10,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            _userRating = rating;
                            setState(() {});
                            print(rating);
                          },
                        ),
                        10.width,
                        Text(_userRating.toString()),
                        Text('/10'),
                      ],
                    ),
                    30.height,
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Starring',
                              style: boldTextStyle(),
                            )
                          ],
                        )
                      ],
                    )

                  ],).paddingAll(16),
                 ],
              ),
      ),
    );
  }
}
