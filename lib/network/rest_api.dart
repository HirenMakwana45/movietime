//
// Future<MediVahanBaseResponse> deleteUserAccountApi() async {
//   return MediVahanBaseResponse.fromJson(await handleResponse(await buildHttpResponse('user/delete-account', method: HttpMethod.DELETE)));
// }Future<MediVahanBaseResponse> forgotPwdApi(Map req) async {
//   return MediVahanBaseResponse.fromJson(await handleResponse(await buildHttpResponse('forgot-password', request: req, method: HttpMethod.POST)));
// }
import '../models/detail_movie_response.dart';
import '../models/upcoming_movies.dart';
import '../utils/app_config.dart';
import 'network_utils.dart';

Future<UpcomingMoviesResponse> getUpComingApi() async {
  return UpcomingMoviesResponse.fromJson(await handleResponse(
      await buildHttpResponse('movie/upcoming?language=en-US',
          method: HttpMethod.GET)));
}

Future<UpcomingMoviesResponse> getNowPlayingApi() async {
  return UpcomingMoviesResponse.fromJson(await handleResponse(
      await buildHttpResponse('movie/now_playing?language=en-US',
          method: HttpMethod.GET)));
}

Future<UpcomingMoviesResponse> getTopRatedApi() async {
  return UpcomingMoviesResponse.fromJson(await handleResponse(
      await buildHttpResponse('movie/top_rated?language=en-US',
          method: HttpMethod.GET)));
}

Future<UpcomingMoviesResponse> searchApi({String? mSearchValue = " "}) async {
  return UpcomingMoviesResponse.fromJson(await handleResponse(
      await buildHttpResponse('search/movie?&query=$mSearchValue',
          method: HttpMethod.GET)));
}
Future<DetailResponse> getMovieDetailsApi(int movieId) async {
  return DetailResponse.fromJson(await handleResponse(
      await buildHttpResponse('/movie/$movieId?language=en-US',
          method: HttpMethod.GET)));
}


