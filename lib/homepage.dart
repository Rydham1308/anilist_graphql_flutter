import 'package:anilist/graphql_class/graphql.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final HttpLink httpLink = HttpLink(
  "https://graphql.anilist.co",
);
final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
  GraphQLClient(
    link: httpLink,
    cache: GraphQLCache(),
  ),
);

const String query = """
{
  Page {
    media {
      siteUrL
      title {
        english
        native
      }
      description
      coverImage {
        color
        large
      }
    }
  }
}
""";


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    GetAniList.readRepositories();
  }
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('AniList'),
          backgroundColor: Colors.deepPurple,
        ),
        body: Query(
            options: QueryOptions(
                document: gql(query),
                variables: const <String, dynamic>{"variableName": "value"}),
            builder: (result, {fetchMore, refetch}) {
              if (result.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (result.data == null) {
                return const Center(
                  child: Text("No article found!"),
                );
              } else {
                final page = result.data?['Page'];
                final media = page['media'];
                return ListView.builder(
                  itemCount: media.length,
                  itemBuilder: (context, index) {
                    final des = media[index]['description'];
                    return Column(children: [
                      Text(des),
                      const Divider(
                        height: 1,
                      )
                    ]);
                  },
                );
              }
            }),
      ),
    );
  }
}
