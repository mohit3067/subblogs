import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subblogs/bloc/blog_bloc.dart';
import 'package:subblogs/bloc/blog_event.dart';
import 'package:subblogs/bloc/blog_state.dart';
import 'package:subblogs/models/blog.dart';
import 'package:hive/hive.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BlogListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BlogBloc()..add(FetchBlogs()),
      child: _BlogListScreen(),
    );
  }
}

class _BlogListScreen extends StatefulWidget {
  @override
  State<_BlogListScreen> createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<_BlogListScreen> {
  List<Blog> favoriteBlogs = [];
  List<Blog> allBlogs = [];

  @override
  void initState() {
    _getBlogsFromDatabase();
    super.initState();
  }

  Future<void> _getBlogsFromDatabase() async {
    final box = await Hive.openBox<Blog>('blogs');
    setState(() {
      allBlogs = box.values.toList();
      favoriteBlogs = allBlogs.where((blog) => blog.isFavorite).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 75, 75, 75),
            title: Center(child: Text('SuBBlogs')),
            bottom: TabBar(
              indicatorColor: const Color.fromARGB(255, 215, 50, 38),
              tabs: [
                Tab(text: 'Blog List'),
                Tab(text: 'Favorites'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              BlocBuilder<BlogBloc, BlogState>(
                builder: (context, state) {
                  if (state is BlogLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is BlogLoaded) {
                    return ListView.builder(
                      itemCount: state.blogs.length,
                      itemBuilder: (context, index) {
                        final blog = state.blogs[index];

                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color.fromARGB(255, 15, 15, 15),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: blog.blogimage,
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 290,
                                              child: Text(
                                                blog.title,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: const Color.fromARGB(
                                                      255, 155, 155, 155),
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                blog.isFavorite
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: blog.isFavorite
                                                    ? Colors.red
                                                    : Colors.grey,
                                              ),
                                              onPressed: () async {
                                                final box =
                                                    await Hive.openBox<Blog>(
                                                        'blogs');
                                                setState(() {
                                                  blog.isFavorite =
                                                      !blog.isFavorite;
                                                  if (blog.isFavorite) {
                                                    if(!favoriteBlogs.contains(blog)){
                                                    favoriteBlogs.add(blog);}
                                                  } else {
                                                    favoriteBlogs.remove(blog);
                                                  }
                                                  box.put(blog.id, blog);
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  } else if (state is BlogError) {
                    return Center(
                      child: Text('Error: ${state.error}'),
                    );
                  }
                  return Center(
                    child: Text('No blogs available.'),
                  );
                },
              ),
              //tab-2
              Container(
                color: Colors.black,
                child: Column(
                  children: [
                    Text(
                      'Favorites',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: favoriteBlogs.length,
                        itemBuilder: (context, index) {
                          final blog = favoriteBlogs[index];

                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Color.fromARGB(255, 15, 15, 15),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: blog.blogimage,
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 290,
                                                child: Text(
                                                  blog.title,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: const Color.fromARGB(
                                                        255, 155, 155, 155),
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  blog.isFavorite
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color: blog.isFavorite
                                                      ? Colors.red
                                                      : Colors.grey,
                                                ),
                                                onPressed: () async {
                                                  final box =
                                                      await Hive.openBox<Blog>(
                                                          'blogs');
                                                  setState(() {
                                                    blog.isFavorite =
                                                        !blog.isFavorite;
                                                    if (blog.isFavorite) {
                                                      favoriteBlogs.add(blog);
                                                    } else {
                                                      favoriteBlogs.remove(blog);
                                                    }
                                                    box.put(blog.id, blog);
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                         },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color.fromARGB(255, 75, 75, 75),
            onPressed: () {
              BlocProvider.of<BlogBloc>(context).add(FetchBlogs());
            },
            tooltip: 'Fetch Data',
            child: Icon(Icons.refresh),
          ),
        ),
      ),
    );
  }
}
