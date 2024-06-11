import 'dart:io';
import 'package:anilist/graphql_class/anilist_model.dart';
import 'package:graphql/client.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:rxdart/rxdart.dart';

class GetAniList {
  static BehaviorSubject<ApiHelper> apiHelperStream =
      BehaviorSubject<ApiHelper>();

  static Future<void> readRepositories() async {
    apiHelperStream.add(ApiHelper(status: ApiStatus.isLoading));
    GraphQLClient getGraphQLClient() {
      final Link link = HttpLink(
        'https://graphql.anilist.co',
      );

      return GraphQLClient(
        cache: GraphQLCache(),
        link: link,
      );
    }

    final GraphQLClient client = getGraphQLClient();
    final query = await rootBundle.loadString('assets/graphql/aniquery.graphql');
    final QueryOptions options = QueryOptions(
      document: gql(query),
    );

    final QueryResult result = await client.query(options);
    if (result.hasException) {
      stderr.writeln(result.exception.toString());
      exit(2);
    }

    final page = result.data?['Page'];
    final media = page['media'];
    final mediaList = (media is List)
        ? (media)
        : null;
    final mediaData =
    mediaList?.map((e) => MediaModel.fromJson(e)).toList();

    apiHelperStream
        .add(ApiHelper(status: ApiStatus.isLoaded, mediaModel: mediaData));
    // print(result.data!['Page']['media'][0]['siteUrl']);
    // return result;
  }
}
