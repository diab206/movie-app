import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movie_app/provider/provider.dart';
import 'package:movie_app/search/details_page.dart';

class Movies extends StatelessWidget {
  const Movies({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MyProvider>(
      builder: (context, myProvider, child) {
        if (myProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMovieCategory(context, 'Now Playing', myProvider.nowPlayingMovies),
              _buildMovieCategory(context, 'Top Rated', myProvider.topRatedMovies),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMovieCategory(BuildContext context, String title, List<dynamic>? movies) {
    if (movies == null || movies.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 220, // Fixed height for the horizontal list
          child: ListView.builder(
            scrollDirection: Axis.horizontal, // Horizontal scrolling
            physics: const BouncingScrollPhysics(), // Enable bouncing effect
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsPage(movieData: movie),
                    ),
                  );
                },
                child: Container(
                  width: 140, // Fixed width for each movie item
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: movie['poster_path'] != null
                            ? Image.network(
                                'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                                height: 180,
                                width: 140,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                height: 180,
                                width: 140,
                                color: Colors.grey[800],
                                child: const Icon(Icons.movie, color: Colors.white),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          movie['title'] ?? 'Unknown',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}