import 'package:anilist/graphql_class/anilist_model.dart';
import 'package:anilist/graphql_class/graphQl.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    GetAniList.readRepositories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AniList'),
      ),
      body: StreamBuilder(
        stream: GetAniList.apiHelperStream,
        builder: (context, snapshot) {
          if (snapshot.data?.status == ApiStatus.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data?.status == ApiStatus.isLoaded) {
            return ListView.builder(
              itemCount: snapshot.data?.mediaModel?.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          '${snapshot.data?.mediaModel?[index].title.english ?? snapshot.data?.mediaModel?[index].title.native}',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(
                          '${snapshot.data?.mediaModel?[index].description ?? ''}'),
                      const Padding(
                        padding: EdgeInsets.all(5),
                        child: Divider(
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text('No Data'),
            );
          }
        },
      ),
    );
  }
}
