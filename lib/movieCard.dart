import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  final Map<String, String> movie;

  const MovieCard({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String title = movie['title'] ?? 'No Title Available';
    final String genre = movie['genre'] ?? 'Unknown Genre';
    final String imdbRating = movie['imdbRating'] ?? 'N/A';
    final String imageUrl = movie['image'] != null && movie['image'] != 'N/A'
        ? movie['image']!
        : 'https://via.placeholder.com/150';

    double? ratingValue;
    if (imdbRating != 'N/A') {
      ratingValue = double.tryParse(imdbRating);
    }

    Color ratingColor;
    if (ratingValue != null && ratingValue >= 7.0) {
      ratingColor = Color(0xFF5EC570);
    } else {
      ratingColor = Color(0xFF1C7EEB);
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 70),
          child: Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.only(bottom: 40.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 100),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 38),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF212121),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                          Text(
                            genre,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: ratingColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: Text(
                              '$imdbRating IMDb',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: -22,
          left: 8,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Image.network(
                imageUrl,
                width: 130,
                height: 200,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
