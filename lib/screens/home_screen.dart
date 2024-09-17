import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:movietime/extensions/extension_util/widget_extensions.dart';
import 'package:movietime/extensions/horizontal_list.dart';
import 'package:movietime/extensions/text_styles.dart';
import 'package:movietime/utils/app_common.dart';
import 'package:movietime/utils/app_config.dart';

import '../extensions/widgets.dart';
import '../models/upcoming_movies.dart';
import '../network/rest_api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Results> upComingMovieList = [];
  List<Results> nowMovieList = [];
  List<Results> topRatedMovieList = [];
  ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _hasMoreNowPlaying = true;
  bool _hasMoreUpcoming = true;
  bool _hasMoreTopRated = true;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMoreData();
      }
    });
  }

  Future<void> _fetchInitialData() async {
    await _fetchNowPlaying();
    await _fetchUpcoming();
    await _fetchTopRated();
  }

  Future<void> _fetchNowPlaying() async {
    if (_isLoading || !_hasMoreNowPlaying) return;

    setState(() => _isLoading = true);

    try {
      var value = await getNowPlayingApi();
      if (value.results != null && value.results!.isNotEmpty) {
        setState(() {
          nowMovieList.addAll(value.results!);
          _hasMoreNowPlaying = true;
        });
      } else {
        _hasMoreNowPlaying = false;
      }
    } catch (e) {
      toast(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchUpcoming() async {
    if (_isLoading || !_hasMoreUpcoming) return;

    setState(() => _isLoading = true);

    try {
      var value = await getUpComingApi();
      if (value.results != null && value.results!.isNotEmpty) {
        setState(() {
          upComingMovieList.addAll(value.results!);
          _hasMoreUpcoming = true;
        });
      } else {
        _hasMoreUpcoming = false;
      }
    } catch (e) {
      toast(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchTopRated() async {
    if (_isLoading || !_hasMoreTopRated) return;

    setState(() => _isLoading = true);

    try {
      var value = await getTopRatedApi();
      if (value.results != null && value.results!.isNotEmpty) {
        setState(() {
          topRatedMovieList.addAll(value.results!);
          _hasMoreTopRated = true;
        });
      } else {
        _hasMoreTopRated = false;
      }
    } catch (e) {
      toast(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _loadMoreData() {
    if (_hasMoreNowPlaying) _fetchNowPlaying();
    if (_hasMoreUpcoming) _fetchUpcoming();
    if (_hasMoreTopRated) _fetchTopRated();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('The MovieDb',
          textSize: 30, context: context, showBack: false),
      body: Observer(builder: (context) {
        return SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Now Playing',
                style: boldTextStyle(size: 26),
              ).paddingLeft(6),
              HorizontalList(
                itemCount: nowMovieList.length,
                itemBuilder: (context, i) {
                  return ClipRRect(
                    child: cachedImage(
                        '${mImageUrl}' +
                            nowMovieList[i].backdropPath.toString(),
                        height: 280,
                        width: 200,
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  );
                },
              ),
              Text(
                'Upcoming',
                style: boldTextStyle(size: 26),
              ).paddingLeft(6),
              HorizontalList(
                itemCount: upComingMovieList.length,
                itemBuilder: (context, i) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                        child: cachedImage(
                            '${mImageUrl}' +
                                upComingMovieList[i].backdropPath.toString(),
                            height: 180,
                            width: 250,
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      Text(upComingMovieList[i].title.toString())
                    ],
                  );
                },
              ),

              Text(
                'Top Rated',
                style: boldTextStyle(size: 26),
              ).paddingLeft(6),
              HorizontalList(
                itemCount: topRatedMovieList.length,
                itemBuilder: (context, i) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                        child: cachedImage(
                            '${mImageUrl}' +
                                topRatedMovieList[i].backdropPath.toString(),
                            height: 200,
                            width: 250,
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ],
                  );
                },
              ),
              if (_isLoading)
                Center(child: CircularProgressIndicator()), // Loader indicator
            ],
          ).paddingAll(6),
        );
      }),
    );
  }
}
