import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movie_app/provider/provider.dart';
import 'package:movie_app/search/details_page.dart';

class TvSeries extends StatelessWidget {
  const TvSeries({super.key});

  @override
  Widget build(BuildContext context) {
    final myProvider = Provider.of<MyProvider>(context);
    
    if (myProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

   if (myProvider.errorMessage?.isNotEmpty ?? false) {
      return Center(
        child: Text(
          myProvider.errorMessage??'something went wrong',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSeriesList(context, myProvider.popularTvSeries, 'Popular TV Series'),
          _buildSeriesList(context, myProvider.topRatedTvSeries, 'Top Rated TV Series'),
        ],
      ),
    );
  }

  Widget _buildSeriesList(BuildContext context, List<dynamic>? series, String title) {
    if (series == null || series.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 4.0),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: series.length,
            itemBuilder: (context, index) {
              final tvSeries = series[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsPage(movieData: tvSeries),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w500${tvSeries['poster_path']}',
                      width: 140,
                      height: 210,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 210,
                          width: 140,
                          color: Colors.grey[800],
                          child: const Icon(Icons.error, color: Colors.white),
                        );
                      },
                    ),
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
