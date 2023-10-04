import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:subblogs/models/blog.dart';
import 'blog_event.dart';
import 'blog_state.dart';
import 'dart:convert';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final String apiUrl = "https://intent-kit-16.hasura.app/api/rest/blogs";
  final String adminSecret =
      "32qR4KmXOIpsGPQKMqEJHGJS27G5s7HdSKO3gdtQd2kv5e852SiYwWNfxkZOBuQ6";

  BlogBloc() : super(BlogInitial()) {
    on<FetchBlogs>((event, emit) async {
      print('fetching blogs....');
      emit(BlogLoading());
      final connectivityResult = await Connectivity().checkConnectivity();
      print(connectivityResult);
      if (connectivityResult == ConnectivityResult.none) {
        final blogs = await _getBlogsFromDatabase();
        emit(BlogLoaded(blogs: blogs));
        return;
      }
      try {
        final response = await http.get(
          Uri.parse(apiUrl),
          headers: {
            'x-hasura-admin-secret': adminSecret,
          },
        );
        print('Response status code: ${response.statusCode}');
        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          final List<dynamic> blogsData = responseData['blogs'];

          final List<Blog> blogs = blogsData.map((blogData) {
            final blog = Blog.fromJson(blogData);
            _insertOrUpdateBlog(blog);
            return blog;
          }).toList();
          emit(BlogLoaded(blogs: blogs));
        } else {
          emit(BlogError(error: 'failed to load the blogs'));
        }
      } catch (e) {
        print('Error: $e');
        emit(BlogError(error: 'Error: $e'));
      }
    });
  }

  Future<void> _insertOrUpdateBlog(Blog blog) async {
    final box = await Hive.openBox<Blog>('blogs');
    await box.put(blog.id, blog);
  }

  Future<List<Blog>> _getBlogsFromDatabase() async {
    final box = await Hive.openBox<Blog>('blogs');
    return box.values.toList();
  }
}
