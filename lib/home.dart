import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mcu_api/Models/mcu_model.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var url = "https://mcuapi.herokuapp.com/api/v1/movies";
  List<MCUModel> mcuMovies = [];
  @override
  void initState() {
    super.initState();
    getMarvelMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: mcuMovies.isNotEmpty
          ? GridView.builder(
              itemCount: mcuMovies.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 2 / 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (BuildContext context, int index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: mcuMovies[index].coverUrl.toString(),
                  ),
                );
              })
          : Center(
            child: Container(
                width: 50,
                height: 50,
                child: const CircularProgressIndicator(
                  color: Colors.white60,
                ),
              ),
          ),
    );
  }

  void getMarvelMovies() {
    final uri = Uri.parse(url);
    http.get(uri).then((response) {
      if (response.statusCode == 200) {
        final responseData = response.body;
        final decodedData = jsonDecode(responseData);
        final List marvelData = decodedData['data'];
        for (var i = 0; i < marvelData.length; i++) {
          final mcuMovie =
              MCUModel.fromJson(marvelData[i] as Map<String, dynamic>);
          mcuMovies.add(mcuMovie);
        }
        setState(() {});
      }
    }).catchError((err) {
      debugPrint("======== $err =========");
    });
  }
}
