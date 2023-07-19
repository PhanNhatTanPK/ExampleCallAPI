import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _listHttp = [];
  var _listDio;

  String _postContentHttp = "";

  // Get use HTTP
  Future<List> _getDataHttp() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos'));
    return json.decode(response.body);
  }

  // Post use HTTP
  Future<void> _postDataHttp() async {
    final response = await http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title':
            'Flutter Post Request Example by allaboutflutter.com using http package',
        'body': 'Learnt a lot from allaboutflutter.com and exploring more',
        'userId': 7
      }),
    );
    setState(() {
      _postContentHttp = response.body;
    });
  }

  // Get with Dio
  void _getDataDio() async {
    try {
      var response = await Dio()
          .get("https://protocoderspoint.com/jsondata/superheros.json");
      if (response.statusCode == 200) {
        setState(() {
          _listDio = response.data['superheros'] as List;
        });
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  // Post with Dio
  void _postDataDio() async {
    var response =
        await Dio().post('https://jsonplaceholder.typicode.com/posts', data: {
      'title':
          'Flutter Post Request Example by allaboutflutter.com using http package',
      'body': 'Learnt a lot from allaboutflutter.com and exploring more',
      'userId': 7
    });

    if (response.statusCode == 201) {
      print(response.data);
    }
  }

  @override
  void initState() {
    super.initState();
    _getDataHttp().then((value) {
      setState(() {
        _listHttp = value;
      });
    });
    _getDataDio();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: Scaffold(
        body: Column(children: [
          Center(
            child: Container(height: 42, child: Text("Get/Post with Http")),
          ),
          Container(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _listHttp.length > 5 ? 5 : _listHttp.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(_listHttp[index]['title']),
                  subtitle: Text(_listHttp[index]['completed']
                      ? 'Completed'
                      : 'Incomplete'),
                  leading: CircleAvatar(
                    child: Text(_listHttp[index]['id'].toString()),
                  ),
                );
              },
            ),
          ),
          Center(
            child: Container(
              width: 100,
              height: 30,
              child: ElevatedButton(
                  child: const Text('Post Data',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      )),
                  onPressed: () {
                    _postDataHttp();
                  }),
            ),
          ),
          Container(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(_postContentHttp),
            ),
          ),

          // DIO
          Center(
            child: Container(height: 42, child: Text("Get/Post with Dio")),
          ),
          Container(
            height: 300,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _listDio == null ? 0 : _listDio.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(_listDio[index]['name']),
                  subtitle: Text(_listDio[index]['power']),
                );
              },
            ),
          ),
          Center(
            child: Container(
              width: 100,
              height: 30,
              child: ElevatedButton(
                  child: const Text('Post Data',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      )),
                  onPressed: () {
                    _postDataDio();
                  }),
            ),
          ),
        ]),
      ),
    );
  }
}
