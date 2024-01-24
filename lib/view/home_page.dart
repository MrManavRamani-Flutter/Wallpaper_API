import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_api/helper/photo_api.dart';
import 'package:wallpaper_api/model/photos.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    await PhotoApi.photoApi.fetchedPhotos().then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                onChanged: (val) async {
                  await PhotoApi.photoApi.fetchedPhotos(val).then((value) {
                    setState(() {});
                  });
                },
                decoration: const InputDecoration(
                  hintText: "Search",
                ),
              ),
            ),
            Expanded(
              flex: 10,
              child: FutureBuilder(
                future: PhotoApi.photoApi.fetchedPhotos(),
                builder: (context, snapshot) {
                  List<Photo>? data;

                  (snapshot.hasError)
                      ? print(snapshot.error)
                      : snapshot.hasData
                          ? data = snapshot.data as List<Photo>?
                          : const CircularProgressIndicator();

                  return (data == null)
                      ? Container()
                      : GridView(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                  childAspectRatio: 3 / 4),
                          children: data
                              .map(
                                (e) => Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    image: DecorationImage(
                                        image: NetworkImage(e.largeImageURL),
                                        fit: BoxFit.cover),
                                  ),
                                  alignment: Alignment.bottomRight,
                                  child: FloatingActionButton(
                                    mini: true,
                                    onPressed: () async {
                                      await AsyncWallpaper.setWallpaper(
                                        url: e.largeImageURL,
                                        wallpaperLocation:
                                            AsyncWallpaper.BOTH_SCREENS,
                                      );
                                    },
                                    child: const Icon(Icons.wallpaper),
                                  ),
                                ),
                              )
                              .toList(),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
