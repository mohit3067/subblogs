import 'package:equatable/equatable.dart';
import 'package:subblogs/models/blog.dart';
abstract class BlogEvent extends Equatable {
  const BlogEvent();

  @override
  List<Object> get props => [];
}

class FetchBlogs extends BlogEvent {
  @override
  List<Object> get props => [];
}

class InsertOrUpdateBlog extends BlogEvent {
  final Blog blog;

  InsertOrUpdateBlog(this.blog);

  @override
  List<Object> get props => [blog];
}
