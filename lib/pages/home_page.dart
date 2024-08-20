// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// NOTE! for new flutter versions make sure to add these lines to your main AndroidManifest.xml


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

// declaring empty variables that would be used later to store values form our API
  String stringResponse = "";
  List listResponse = [];
  Map mapResponse = {};
  List listOfFacts = [];


// use a Future and async to create function so that the UI doesn't need to wait for the API to load
  Future fetchdata() async{
    http.Response response;
    response = await http.get(Uri.parse('https://thegrowingdeveloper.org/apiview?id=2'));

// to check if API call was successful, 200 = success, 404 = route was not found, 500 = server error
    if(response.statusCode == 200){
      setState(() {
        mapResponse = json.decode(response.body);
        listOfFacts = mapResponse['facts'];
      });
    }
  }


//make sure to always initstate to request for the function; takes priority
  @override
  void initState() {
    fetchdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fetch Data From Internet"),
        backgroundColor: Colors.blue[900],
      ),

      body:
//check if API hasn't called yet and return black container(to avoid red error screen)
      mapResponse.isEmpty
          ? Container()
          : SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  mapResponse['category'].toString(),
                  style: TextStyle(fontSize: 20),
                ),
                ListView.builder(
                    shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: listOfFacts.isEmpty
                    ? 0
                    : listOfFacts.length,
                itemBuilder: (context,index){
                  return Container(
                    child: Column(
                      children: [
                        Image.network(listOfFacts[index]['image_url']),
                      ],
                    ),
                  );
                      }),
              ],
            ),
          )
    );
  }
}
