import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movie_app/provider/provider.dart';

class DetailsPage extends StatefulWidget {
  final dynamic movieData;

  const DetailsPage({super.key, required this.movieData});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late Future<List<dynamic>> castFuture;

  @override
  void initState() {
    super.initState();
    castFuture = Future.value([]); // Initialize with a default value
    Future.microtask(() {
      // ignore: use_build_context_synchronously
      final myProvider = Provider.of<MyProvider>(context, listen: false);
      setState(() {
        castFuture = myProvider.getCast(widget.movieData['id'], widget.movieData['media_type'] ?? 'movie');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.movieData['title'] ?? widget.movieData['name'] ?? 'Details',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMoviePoster(context),
            _buildMovieDetails(context),
            _buildCastSection(context, castFuture),
          ],
        ),
      ),
    );
  }
Widget _buildMoviePoster(BuildContext context) {
  return Center(
    child: Container(
      width: MediaQuery.of(context).size.width > 600 ? 600 : double.infinity, // Increased width
      height: MediaQuery.of(context).size.width > 600 ? 900 : 400, // Increased height
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: widget.movieData['poster_path'] != null
            ? DecorationImage(
                image: NetworkImage('https://image.tmdb.org/t/p/w500${widget.movieData['poster_path']}'),
                fit: BoxFit.contain, // Ensures the entire image is visible
              )
            : null,
      ),
      child: widget.movieData['poster_path'] == null
          ? const Center(child: Icon(Icons.movie, size: 100, color: Colors.white))
          : null,
    ),
  );
}
  Widget _buildMovieDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.movieData['title'] ?? widget.movieData['name'] ?? 'Unknown',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          _buildRatingRow(),
          _buildDetailText('Release Date:', widget.movieData['release_date'] ?? widget.movieData['first_air_date'] ?? 'N/A'),
          _buildDetailText('Language:', widget.movieData['original_language']?.toUpperCase() ?? 'N/A'),
          _buildDetailText('Duration:', widget.movieData['runtime'] != null ? '${widget.movieData['runtime']} min' : 'N/A'),
          _buildWatchNowButton(),
          const SizedBox(height: 10),
          const Text('Overview:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 5),
          Text(widget.movieData['overview'] ?? 'No description available.', style: const TextStyle(color: Colors.white70, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildRatingRow() {
    return Row(
      children: [
        const Icon(Icons.star, color: Colors.amber),
        const SizedBox(width: 5),
        Text(
          '${widget.movieData['vote_average']?.toStringAsFixed(1) ?? 'N/A'}/10',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildDetailText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text('$label $value', style: const TextStyle(color: Colors.grey, fontSize: 14)),
    );
  }

  Widget _buildWatchNowButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: const Text('Watch Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
    );
  }

  Widget _buildCastSection(BuildContext context, Future<List<dynamic>> castFuture) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Cast:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 5),
          FutureBuilder<List<dynamic>>(
            future: castFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.amber));
              } else if (snapshot.hasError) {
                return const Text('Failed to load cast', style: TextStyle(color: Colors.white));
              }
              final cast = snapshot.data ?? [];
              return SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: cast.length,
                  itemBuilder: (context, index) {
                    final actor = cast[index];
                    return _buildActorCard(actor);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActorCard(dynamic actor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: actor['profile_path'] != null
                ? NetworkImage('https://image.tmdb.org/t/p/w200${actor['profile_path']}')
                : null,
            child: actor['profile_path'] == null
                ? const Icon(Icons.person, size: 40, color: Colors.white)
                : null,
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: 80,
            child: Text(
              actor['name'],
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
