import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/provider/provider.dart';
import 'package:movie_app/screens/movies/movies.dart';
import 'package:movie_app/screens/tv_series/tv_series.dart';
import 'package:movie_app/screens/up_comming/up_comming.dart';
import 'package:movie_app/search/details_page.dart';
import 'package:movie_app/search/search_page.dart'; // Import the search page
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const String routeName = 'Flutter Demo';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedTimePeriod = 'week'; // Default to 'week'

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final myProvider = Provider.of<MyProvider>(context, listen: false);
      myProvider.fetchTrendingMoviesWeek();
      myProvider.fetchNowPlayingMovies();
      myProvider.fetchTopRatedMovies();
      myProvider.fetchUpcomingMovies();
      myProvider.fetchPopularTvSeries();
      myProvider.fetchTopRatedTvSeries();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTimePeriodChanged(String? value) {
    if (value != null) {
      setState(() {
        _selectedTimePeriod = value;
      });
      final myProvider = Provider.of<MyProvider>(context, listen: false);
      if (value == 'week') {
        myProvider.fetchTrendingMoviesWeek();
      } else if (value == 'day') {
        myProvider.fetchTrendingMoviesDay();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final myProvider = Provider.of<MyProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Trending  🔥', style: TextStyle(color: Colors.white)),
            const SizedBox(width: 5),
            DropdownButton<String>(
              value: _selectedTimePeriod,
              dropdownColor: Colors.black,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              underline: Container(),
              onChanged: _onTimePeriodChanged,
              items: const [
                DropdownMenuItem(
                  value: 'week',
                  child: Text('Week', style: TextStyle(color: Color.fromARGB(255, 129, 158, 24))),),
               DropdownMenuItem(
                  value: 'day',
                  child: Text('Day', style: TextStyle(color: Color.fromARGB(255, 129, 158, 24))),
              )  ],
            ),
          ],
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: myProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Consumer<MyProvider>(
                    builder: (context, provider, child) {
                      return provider.trendingMovies.isEmpty
                          ? const Center(
                              child: Text(
                                'No trending movies available',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          : CarouselSlider.builder(
                              itemCount: provider.trendingMovies.length,
                              itemBuilder: (context, index, realIndex) {
                                final movie = provider.trendingMovies[index];
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
                                    margin: const EdgeInsets.symmetric(horizontal: 5),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                        'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress.expectedTotalBytes != null
                                                  ? loadingProgress.cumulativeBytesLoaded /
                                                      loadingProgress.expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                              options: CarouselOptions(
                                height: 300,
                                enlargeCenterPage: true,
                                autoPlay: true,
                                aspectRatio: 16 / 9,
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enableInfiniteScroll: true,
                                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                                viewportFraction: 0.8,
                              ),
                            );
                    },
                  ),
                  const SizedBox(height: 20),
                  
                  // Add search field between carousel and tabbar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SearchPage()),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: const [
                            Icon(Icons.search, color: Colors.grey),
                            SizedBox(width: 8),
                            Text(
                              'Search movies or TV shows...',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  const TabBarViewSection(), // Add the TabBarViewSection here
                ],
              ),
            ),
    );
  }
}

class TabBarViewSection extends StatelessWidget {
  const TabBarViewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            physics: const BouncingScrollPhysics(),
            labelPadding: const EdgeInsets.symmetric(horizontal: 25),
            isScrollable: true,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.amber.withAlpha(102),
            ),
            labelColor: Colors.amber,
            unselectedLabelColor: Colors.white,
            labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            tabs: const [
              Tab(child: Text('TV Series')),
              Tab(child: Text('Movies')),
              Tab(child: Text('Upcoming')),
            ],
          ),
          SizedBox(
            height: 500,
            child: TabBarView(
              children: const [
                TvSeries(),
                Movies(),
                UpComming(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}