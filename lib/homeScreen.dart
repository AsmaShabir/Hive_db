import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/boxes/box.dart';
import 'models/photosModel.dart';

class PhotosScreen extends StatefulWidget {
  const PhotosScreen({super.key});

  @override
  State<PhotosScreen> createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {
  Box<photosModel>? photosBox;

  @override
  void initState() {
    super.initState();
    openHiveBox();
    fetchPhotos();
  }

  Future<void> openHiveBox() async {
    photosBox = await Hive.openBox<photosModel>('photoBox');
  }

  Future<List<photosModel>> fetchPhotos() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/photos'),
    );
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      var box = await Hive.openBox<photosModel>('photoBox');
      for (var photo in data) {
        box.add(photosModel.fromJson(photo));
      }
    } else {
      return [];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photos'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: Boxes.getData().listenable(),
              builder: (context, box, _) {
                var data = box.values.toList().cast<photosModel>();
                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Image.network(data[index].url.toString()),
                        SizedBox(height: 10),
                        Text(data[index].title.toString()),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          InkWell(
            onTap: () {
              fetchPhotos();
            },
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }


}