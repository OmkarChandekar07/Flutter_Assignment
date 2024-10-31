import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:movies_app/movieCard.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String apiKey = '2b54ddc8'; // My API Key
  List<Map<String, String>> _movies = [];
  String searchQuery = "";
  bool isLoading = false;

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      setState(() {
        _movies = [];
      });
      return;
    }

    final url = 'http://www.omdbapi.com/?s=$query&apikey=$apiKey';

    setState(() {
      isLoading = true;
    });

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['Response'] == 'True') {
        List<Map<String, String>> movies = [];

        for (var movie in data['Search']) {
          final detailsUrl =
              'http://www.omdbapi.com/?i=${movie['imdbID']}&apikey=$apiKey';
          final detailsResponse = await http.get(Uri.parse(detailsUrl));
          final detailsData = json.decode(detailsResponse.body);

          movies.add({
            "title": movie['Title'] ?? 'No Title Available',
            "genre": detailsData['Genre'] ?? 'Unknown',
            "imdbRating": detailsData['imdbRating'] ?? 'N/A',
            "image": movie['Poster'] != 'N/A'
                ? movie['Poster']
                : 'https://via.placeholder.com/150',
          });
        }

        setState(() {
          _movies = movies;
          isLoading = false;
        });
      } else {
        setState(() {
          _movies = [];
          isLoading = false;
        });
      }
    } else {
      setState(() {
        _movies = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 221, 222, 222),
      ),
      backgroundColor: const Color.fromARGB(255, 234, 232, 232),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                hintText: 'Search',
                hintStyle: TextStyle(
                  fontSize: 20,
                ),
                suffix: Icon(
                  Icons.search,
                  size: 30,
                ),
                border: OutlineInputBorder(),
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
                searchMovies(value);
              },
            ),
            SizedBox(height: 30.0),
            isLoading
                ? CircularProgressIndicator()
                : Expanded(
                    child: _movies.isEmpty
                        ? Center(child: Text('No results found'))
                        : ListView.builder(
                            itemCount: _movies.length,
                            itemBuilder: (context, index) {
                              final movie = _movies[index];
                              return MovieCard(movie: movie);
                            },
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}
