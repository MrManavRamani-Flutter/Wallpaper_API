import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wallpaper_api/model/photos.dart';

class PhotoApi {
  PhotoApi._();
  static final PhotoApi photoApi = PhotoApi._();

  String apiKey = "33101047-aca489f6993b653291e2c4523";
  Future<List<Photo>?> fetchedPhotos([String searchedText = ""]) async {
    String api =
        "https://pixabay.com/api/?key=$apiKey&q=$searchedText&orientation=vertical";
    http.Response response = await http.get(Uri.parse(api));
    if (response.statusCode == 200) {
      String data = response.body;
      Map decodedData = jsonDecode(data);
      List photosData = decodedData['hits'];
      return photosData.map((e) {
        return Photo(largeImageURL: e['largeImageURL']);
      }).toList();
    }
    return null;
  }
}
